#!/usr/bin/env bash
set +e
echo -e "AUTOMATE_TYPE: ${AUTOMATE_TYPE}"
echo -e "TEST_TYPE: ${TEST_TYPE}"
echo -e "TEST_ENV: ${TEST_ENV}"
echo -e "JOB_URL: ${JOB_URL}"
echo -e "Create Jira tickets..."
python /usr/local/bin/task_on_fails.py "2" ${AUTOMATE_TYPE} ${TEST_TYPE} ${TEST_ENV} ${REPORT_DIR}"/output.xml" ${JOB_URL}

