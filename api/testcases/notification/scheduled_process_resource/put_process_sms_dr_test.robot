*** Settings ***
Documentation    Tests to verify that processSmsDR api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/scheduled_process_resource_keywords.robot

# scope: batch_processor
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_06341
    [Documentation]    [Notification][processSmsDR] Request API to move all DR files to "processing" folder
    [Tags]    Regression    Medium    Smoke    UnitTest
    Put Process Sms DR
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_06344
    [Documentation]     [Notification][processSmsDR] Request API without "batch_processor" scope returns 403
    [Tags]      Regression     Medium    Smoke
    [Setup]    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}    client_id_and_secret=robotautomationclientnoscope
    Put Process Sms DR
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    scope    batch_processor
    Response Should Contain Property With Value    error_description    Insufficient scope for this resource
    Response Should Contain Property With Value    error    insufficient_scope