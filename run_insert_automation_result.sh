#!/usr/bin/env bash
set +e
#Add script to insert automation result with running elap time into MC DB, O2O dashboard will be found at http://54.169.158.250:8081/
echo -e "Inserting test results into the QA Dashboard DB..."
python /usr/local/bin/insert_automation_result.py "2" ${AUTOMATE_TYPE} ${SERVICE_NAME} ${TEST_TYPE} ${TEST_ENV} ${REPORT_DIR}"/output.xml" ${JOB_URL}

#Add script to read E2E feature name and insert into MC DB
if [ "${TEST_TYPE}" == "E2E" ]
then
    echo -e "Inserting E2E feature name into the QA Dashboard DB..."
    python /usr/local/bin/read_robot_result_by_file_name.py "2" ${AUTOMATE_TYPE} ${TEST_TYPE} ${TEST_ENV} ${REPORT_DIR}"/output.xml" ${JOB_URL}
fi