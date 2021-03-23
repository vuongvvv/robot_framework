#!/usr/bin/env bash
set +e
echo -e "Executing robot test"
robot --variable env:${TEST_ENV} --loglevel TRACE -i ${TEST_TYPE} ${EXCLUDE_TEST_TYPE_COMMAND}  -e 'ASCO2O-[0-9]*ORO2O-[0-9]*' --outputdir ${REPORT_DIR} /robot/${AUTOMATE_TYPE}/testcases/${SERVICE_NAME}