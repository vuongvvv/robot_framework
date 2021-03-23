#!/usr/bin/env bash
set +e
#hardcode to edit /etc/hosts
echo "103.55.2.248   saleapp-audit-alpha.eggdigital.com" >> /etc/hosts;
echo -e "Executing robot test"
#Run test cases in all components except mobile
robot -v env:${TEST_ENV} --loglevel TRACE --suite api --suite web --suite e2e-tests -i ${TEST_TYPE} -e 'ASCO2O-[0-9]*ORO2O-[0-9]*'  --outputdir ${REPORT_DIR} /robot/