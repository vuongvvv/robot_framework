*** Settings ***
Documentation    Tests to verify that getAllHistories api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification_producer/notification_producer_keywords.robot

# permission: notification.history.read
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}    
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_06944
    [Documentation]    [API][NotificationProducer][getAllHistories] Request with "notification.history.read" permission returns 200
    [Tags]    Regression    High    Smoke    UnitTest
    Get All Histories
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    .id
    Response Should Contain All Property Values Are List Of Base64 Strings    .contact
    Response Should Contain All Property Values Are String    .transactionReference
    Response Should Contain All Property Values Are String    .remark
    Response Should Contain All Property Values Are String    .sourceType
    Response Should Contain All Property Values Are String    .sourceId
    Response Should Contain All Property Values Are String    .nestedTemplateHistory.action
    Response Should Contain All Property Values Are String    .nestedTemplateHistory.type
    Response Should Contain All Property Values Are String    .nestedTemplateHistory.template
    Response Should Contain All Property Values Are String    .nestedTemplateHistory.senderName