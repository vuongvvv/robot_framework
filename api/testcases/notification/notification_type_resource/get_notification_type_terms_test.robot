*** Settings ***
Documentation    Tests to verify that getNotificationTypeTerms api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/notification_type_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${1}

*** Test Cases ***
TC_O2O_01041
    [Documentation]     [Notification][getNotificationTypeTerms] User can access getNotificationTypeTerms API without scope or permission
    [Tags]      Regression     High    Smoke    UnitTest
    Get Notification Type Terms    ${type_id}
    Response Correct Code    ${SUCCESS_CODE}