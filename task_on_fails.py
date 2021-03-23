import sys
from xml.etree import ElementTree as ET
import mysql.connector
import requests
import time
import datetime
import json

based_url = "https://truemoney.atlassian.net/rest/api/2/issue/"
headers = {
        'Authorization': 'Basic Y2hhbmFwaGFuLmNob0Bhc2NlbmRjb3JwLmNvbTpUUjlveDl3WHlJMXVxUFh1aENvOEY4QjM=',
        'Content-Type': 'application/json',
        'Cookie': 'atlassian.xsrf.token=B4AG-MCM0-PWEG-7J7L_1f61709cc94d8df3e89e481a9ee977333b86cdb6_lin'
        }
def connect_db():
    conn = mysql.connector.connect(
        host="10.100.0.64",
        user="qadashboard",
        passwd="C0mq@2019",
        database="qadashboard"
    )
    return conn

def get_fails_components(xml_file, test_type):
    fail_list = []
    robot = ET.parse(xml_file).getroot()
    if test_type == 'E2E':
        ids = [suite.get('id') for suite in robot.findall('.//suite') if(str(suite.get('source'))[-6:] == '.robot')]
    elif test_type == 'Smoke':
        ids = []
        for suite in robot.findall('.//suite'):
            if(str(suite.get('source')).count('/') == 4):
                ids = [suite.get('id')]
    for stat in robot.findall(".//stat"):
        if(stat.get("id") in ids and stat.get('fail') != '0'):
            fail_list.append(stat.attrib)
    return fail_list

def get_component_status(component_name, env):
    try:
        conn = connect_db()
        cur = conn.cursor()
        cur.execute("SELECT * FROM issues WHERE component_name='{}' and env='{}'".format(component_name, env))
        issue = cur.fetchone()
        if not (issue and issue[4]):
            return 
        url = "{}{}".format(based_url, issue[4])
        response = requests.request("GET", url, headers=headers)
        val = {
            "id": issue[0],
            "component_name": component_name,
            "jira_id": issue[4],
            "status": response.json()['fields']['status']['name']
        }
        return val
    except Exception as e:
        print(e)
        return 

def create_jira(summary, detail, tags):

    payload = {
        'fields': { 
            'summary': summary,
            'description': detail,
            'project': { 'id': '25749' },
            'issuetype':{ 'id': '1' },
            'labels' : tags,
            'customfield_15960':{ 'value': 'O2O-QA Pool' },
            'assignee':{ 'id': '5a4db4e003ffbd29f8a4c1ab' }      
        }
    }
    response = requests.request("POST", based_url, headers=headers, data = json.dumps(payload))
    print(response.json())
    return response.json()['key']

def insert_db(component_name, test_type, env, jira_id, build_no, fails):
    ts = time.time()
    timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
    try:
        conn = connect_db()
        cur = conn.cursor()

        sql = "INSERT INTO issues (component_name, test_type, env, jira_id, build_no, created_at, updated_at, fails) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        val = (component_name, test_type, env, jira_id, build_no, timestamp, timestamp, fails)
        cur.execute(sql, val)

        conn.commit()
        print("insert {}".format(component_name))
    except Exception as e:
        print(e)
        return 

def cleanup():
    try:
        conn = connect_db()
        cur = conn.cursor()
        sql = "DELETE FROM issues WHERE jira_id is NULL "
        cur.execute(sql)
        conn.commit()
        cur.execute("SELECT * FROM issues")
        issues = cur.fetchall()
        for issue in issues:
            url = "{}{}".format(based_url, issue[4])
            response = requests.request("GET", url, headers=headers)
            if response.json()['fields']['status']['name'] in ('Closed', 'Done'):
                sql = "DELETE FROM issues WHERE jira_id = '{}'".format(issue[4])
                cur.execute(sql)
                conn.commit()
                print("delete:",issue[1])

    except Exception as e:
        print(e)
        return 
# Recieve variables from file calling and input into local variables
unit_id = sys.argv[1]
automate_type = sys.argv[2]
test_type = sys.argv[3]
env = sys.argv[4]
robot_result_xml_url = sys.argv[5]
job_url = sys.argv[6]

# env = "staging"
# job_url = "https://gitlab.com/o2oplatform/o2o-api-automation/-/jobs/568884949"
# test_type = "Smoke"
# robot_result_xml_url = "/Users/chanaphanchonyusen/Downloads/testreports/output.xml"

fails = get_fails_components(robot_result_xml_url, test_type)
# cleanup closed issues
cleanup()
for fail in fails:
    component_name = fail.get('name')
    fails = fail.get('fail')
    issue_item = get_component_status(component_name, env)
    if (not issue_item):
        summary = "[{} - Automation] {} ({})".format(test_type, component_name, fails)
        detail = "ENV: {}, Detail: {}".format(env, job_url)
        tags = ['Automation', test_type]
        jira_id = create_jira(summary, detail, tags)
        insert_db(component_name, test_type, env, jira_id, job_url, fails)
    # else:
    #     print("Todo: update jira/db")

    
