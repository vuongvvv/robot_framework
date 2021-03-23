*** Settings ***
Documentation    Tests to verify that getAllNotificationTypes api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/notification_type_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_01611
    [Documentation]     [notification][getAllNotificationTypes] Verify Get All Notification types api with correct request will return valid response and match with "notification.notification_type" type table
    [Tags]      Regression     High    Smoke
    Get All Notification Types
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Number    .id
    Response Should Contain All Property Values Are String    .name
    Response Should Contain Property With Number String    .quotaLimit
    Response Should Contain All Property Values Are String Or Null    .rule
    Response Should Contain All Property Values Are String    .terms