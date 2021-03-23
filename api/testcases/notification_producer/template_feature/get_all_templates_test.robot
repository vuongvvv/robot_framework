*** Settings ***
Documentation    Tests to verify that getAllTemplates api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification_producer/notification_producer_keywords.robot

# permission_name=notification.template.read
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}    
Test Teardown     Delete All Sessions

*** Variables ***
@{status_list}    ACTIVE    INACTIVE

*** Test Cases ***
TC_O2O_06974
    [Documentation]    [NotificationProducer][getAllTemplates] Request with "notification.template.read" permission returns 200
    [Tags]    Regression    High    Smoke
    Get All Templates
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Number    .id
    Response Should Contain All Property Values Are String    .action
    Response Should Contain All Property Values Are String    .type
    Response Should Contain All Property Values Are String    .template
    Response Should Contain All Property Values Include In List    .status    ${status_list}