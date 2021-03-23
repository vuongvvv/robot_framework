import sys
from xml.dom import minidom
import json
import os
import time
import mysql.connector
from datetime import timedelta as td, datetime

# Recieve variables from file calling and input into local variables
unit_id = sys.argv[1]
automate_type = sys.argv[2]
service_name = sys.argv[3]
test_type = sys.argv[4]
env = sys.argv[5]
result_xml_url = sys.argv[6]
job_url = sys.argv[7]

# Switch sub_unit_wording to be sub_unit_id follow value in Nitrade DB of sub_unit table
def switch_sub_unit(sub_unit_wording):
   switcher = {
      'api':3,
      'e2e-tests':4,
      'mobile': 5,
      'web': 6,
      'na': 7
   }
   return switcher.get(sub_unit_wording,0)
sub_unit_id = switch_sub_unit(automate_type)


# Parse xml result file for get running time, end run time, pass cases amount, fail case amount
dom = minidom.parse(result_xml_url)

stat = dom.getElementsByTagName('stat')

high_failed = [items.attributes['fail'].value for items in stat if items.firstChild.nodeValue == "High"]
h_failed = 0 if not high_failed else int(high_failed[0])

high_passed = [items.attributes['pass'].value for items in stat if items.firstChild.nodeValue == "High"]
h_passes = 0 if not high_passed else int(high_passed[0])

h_total = h_passes + h_failed

medium_failed = [items.attributes['fail'].value for items in stat if items.firstChild.nodeValue == "Medium"]
m_failed = 0 if not medium_failed else int(medium_failed[0])

medium_passed = [items.attributes['pass'].value for items in stat if items.firstChild.nodeValue == "Medium"]
m_passes = 0 if not medium_passed else int(medium_passed[0])

low_failed = [items.attributes['fail'].value for items in stat if items.firstChild.nodeValue == "Low"]
l_failed = 0 if not low_failed else int(low_failed[0])

low_passed = [items.attributes['pass'].value for items in stat if items.firstChild.nodeValue == "Low"]
l_passes = 0 if not low_passed else int(low_passed[0])

failed = [items.attributes['fail'].value for items in stat if items.firstChild.nodeValue == "All Tests"]
passed = [items.attributes['pass'].value for items in stat if items.firstChild.nodeValue == "All Tests"]

total = int(failed[0]) + int(passed[0])

# get total running time
robotList = dom.getElementsByTagName('robot')
start_run_time = robotList[0].attributes['generated'].value
statusList = dom.getElementsByTagName('status')
lenStatusList = (len(statusList))-1
end_run_time = statusList[lenStatusList].attributes['endtime'].value

start_date_time = datetime.strptime(start_run_time, '%Y%m%d %H:%M:%S.%f')
end_date_time = datetime.strptime(end_run_time, '%Y%m%d %H:%M:%S.%f')
elap = end_date_time - start_date_time

# Connect to Nitrade DB, if run in local, need to set host="localhost",port="3306"
db = mysql.connector.connect(
  host="10.100.0.64",
  user="qadashboard",
  passwd="C0mq@2019",
  database="qadashboard",
)
result = db.cursor()

st = end_date_time
thai_st_date_time = st+td(hours=7)

print("Total: {}, passed: {}, failed: {}".format(total, passed[0], failed[0]))

# Insert value that got from previous steps into automation_result_by_filename table
try:
   sql_insert = """INSERT INTO automation_result VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"""
   data_insert = [(None, unit_id, sub_unit_id, service_name, test_type, env, h_passes, h_failed, m_passes, m_failed, l_passes, l_failed, int(passed[0]), int(failed[0]), thai_st_date_time, elap.total_seconds(),job_url)]

   result.executemany(sql_insert,data_insert)
   db.commit()
   print("insert data complete")
except:
   db.rollback()
   print("error while insert")

db.close()