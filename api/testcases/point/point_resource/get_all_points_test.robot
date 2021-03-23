*** Settings ***
Documentation    Tests to verify that getAllPoints api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/point/point_resource_keywords.robot

# permission_name=point.point.list
Test Setup    Run Keywords    Generate Robot Automation Header    ${POINT_USERNAME}    ${POINT_PASSWORD}
...    AND    Prepare Point Test Data
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_04913
    [Documentation]     [Point][getAllPoints] Request with "equals" filter and "thaiId" field with user with "point.point.list" permission returns 200 with correct data
    [Tags]      Regression     Medium    Smoke    ASCO2O-2306
    Get All Points    thaiId.equals=${THAI_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .thaiId    ${THAI_ID}