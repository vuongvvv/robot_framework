import sys
import time
from xml.etree import ElementTree as ET
from datetime import timedelta as td, datetime
import mysql.connector

# Connect to Nitrade DB, if run in local, need to set host="localhost",port="3306" or port "3306"
db = mysql.connector.connect(
  host="10.100.0.64",
  user="qadashboard",
  passwd="C0mq@2019",
  database="qadashboard"
)
result = db.cursor()

# Recieve variables from file calling and input into local variables
unit_id = sys.argv[1]
automate_type = sys.argv[2]
test_type = sys.argv[3]
env = sys.argv[4]
robot_result_xml_url = sys.argv[5]
job_url = sys.argv[6]

#Declare expected for level get test name in xml file
if (automate_type == 'na'): expected_for_level_get_test_name = 3
else: expected_for_level_get_test_name = 1

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

# Parse xml result file for get running time, end run time, pass cases amount, fail case amount, robot file name
# And insert into automation_result_by_filename table
doc = ET.parse(robot_result_xml_url).getroot()
try:
    ts = datetime.now()
    thai_ts_date_time = ts + td(hours=7)
    st = thai_ts_date_time.strftime('%Y-%m-%d %H:%M:%S')
    for suitelv in doc.iter('suite'):
        for suitename_status in suitelv.iter('stat'):
            id = suitename_status.get('id')
            lv = str(id).count('-')
            name = suitename_status.get('name')
            suffix = "Test";
            is_file_name = name.endswith(suffix)
            if ((lv >= expected_for_level_get_test_name) & (is_file_name)) :
                filename = suitename_status.get('name')
                no_fail = suitename_status.get('fail')
                no_pass = suitename_status.get('pass')
                fullpath = suitename_status.text
                sql_insert = """INSERT INTO automation_result_by_filename VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"""
                data_insert = [(None, unit_id, sub_unit_id, filename, fullpath, test_type, env, no_pass, no_fail, job_url, st)]
                result.executemany(sql_insert, data_insert)
                db.commit()
    print ("insert file name data complete")

except Exception as e:
            print(e)
            db.rollback()
            print ("error while insert")
db.close()