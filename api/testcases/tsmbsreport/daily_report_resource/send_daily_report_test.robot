*** Settings ***
Documentation    Tests to verify that "Send Daily Report" API works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/tsmbsreport/daily_report_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${TSMBS_REPORT_USERNAME}    ${TSMBS_REPORT_PASSWORD}
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_07360
    [Documentation]    Verify user will get 403 if call "Send Daily Report" API without "batch_processor" scope
    [Tags]    BE-tsm-bs-report    Regression    High    Smoke    Unittest    Sanity    
    Get Send Daily Report
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/daily-report
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message