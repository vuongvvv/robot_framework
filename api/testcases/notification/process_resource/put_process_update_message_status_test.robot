*** Settings ***
Documentation    Tests to verify that processUpdateMessageStatus api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/process_resource_keywords.robot

# scope: batch_processor
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_01236
    [Documentation]     [notification][processUpdateMessageStatus] Only client has "batch_processor" scope can access
    [Tags]      Regression     Medium    Smoke
    Put Process Update Message Status
    Response Correct Code    ${SUCCESS_CODE}