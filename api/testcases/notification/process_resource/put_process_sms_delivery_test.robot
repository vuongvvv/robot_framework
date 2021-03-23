*** Settings ***
Documentation    Tests to verify that processSMSDelivery api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/process_resource_keywords.robot

# scope: batch_processor
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_01365
    [Documentation]     [notification][processSMSDelivery] Only client has "batch_processor" scope can access
    [Tags]      Regression     Medium    Smoke    UnitTest
    Put Process SMS Delivery
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_01366
    [Documentation]     [notification][processSMSDelivery] Client without batch_processor" scope can NOT access
    [Tags]      Regression     Medium    Smoke
    [Setup]    Generate Gateway Header With Scope and Permission    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
    Put Process SMS Delivery
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    scope    batch_processor
    Response Should Contain Property With Value    error_description    Insufficient scope for this resource
    Response Should Contain Property With Value    error    insufficient_scope