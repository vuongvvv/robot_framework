*** Settings ***
Documentation    Tests to verify that processUpdateMessageStatus api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/scheduled_process_resource_keywords.robot

# scope: batch_processor
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_06345
    [Documentation]    [Notification][processUpdateMessageStatus] Request API will update message and audiences status
    [Tags]    Regression    Medium    Smoke    UnitTest
    Put Process Update Message Status
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_06348
    [Documentation]     [notification][processUpdateMessageStatus] Request API without "batch_processor" scope returns 403
    [Tags]      Regression     Medium    Smoke
    [Setup]    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}    client_id_and_secret=robotautomationclientnoscope
    Put Process Update Message Status
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    scope    batch_processor
    Response Should Contain Property With Value    error_description    Insufficient scope for this resource
    Response Should Contain Property With Value    error    insufficient_scope