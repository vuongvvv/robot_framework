*** Settings ***
Documentation    Tests to verify that getMessageItemDetail api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/message_resource_keywords.robot

# permission_name=notification.registration.approve,notification.message.approve
Test Setup    Run Keywords    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
...    AND    Get Message Id Test Data
Test Teardown     Delete All Sessions

*** Variables ***
${status_regex}    ^(SENDING|CANCELED|REJECTED|REQUESTED|PENDING|COMPLETED)$
${date_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[Z]$

*** Test Cases ***
TC_O2O_00972
    [Documentation]     [notification][getMessageItemDetail] Request with valid messageId returns data match with "notification.message" table
    [Tags]      Regression     High    Smoke    UnitTest
    Get Message Item Detail    ${TEST_DATA_MESSAGE_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${TEST_DATA_MESSAGE_ID}
    Response Should Contain Property With String Value    merchantNotificationTypeId
    Response Should Contain Property With String Value    title
    Response Should Contain Property With String Value    messageBody
    Response Should Contain Property Matches Regex    status    ${status_regex}
    Response Should Contain Property With Number String    creditsPerMessage
    Response Should Contain Property With Number String    numberOfAudiences
    Response Should Contain Property Matches Regex    createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    condition..rule
    Response Should Contain All Property Values Match Regex    condition..start    ${date_regex}
    Response Should Contain All Property Values Match Regex    condition..end    ${date_regex}