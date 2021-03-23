*** Settings ***
Documentation    Tests to verify that getAllMessages api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/message_resource_keywords.robot

# permission_name=notification.message.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${status_regex}    ^(SENDING|CANCELED|REJECTED|REQUESTED|PENDING|COMPLETED|FAILED)$
${last_modified_date_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[Z]$

*** Test Cases ***
TC_O2O_00756
    [Documentation]     [notification][getAllMessages] Request with valid type and merchantId returns data match with "notification.message" table
    [Tags]      Regression     High    Smoke
    Get All Messages
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Number    .id
    Response Should Contain All Property Values Are String    .merchantId
    Response Should Contain All Property Values Are Number    .notificationTypeId
    Response Should Contain All Property Values Are Number    .merchantNotificationTypeId
    Response Should Contain All Property Values Are String    .title
    Response Should Contain All Property Values Are String    .messageBody
    Response Should Contain All Property Values Match Regex    .status    ${status_regex}
    Response Should Contain All Property Values Are String Or Null    .rejectReason
    Response Should Contain All Property Values Are Number    .creditsPerMessage
    Response Should Contain All Property Values Are Number    .numberOfAudiences
    Response Should Contain All Property Values Match Regex    .createdDate    ${last_modified_date_regex}

TC_O2O_00763
    [Documentation]     [API] [SMS] [Get Merchant SMS Message List] Request with ROLE_USER already binds to a Merchant returns 403
    [Tags]      Regression     Medium
    [Setup]    Generate Gateway Header With Scope and Permission    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
    Get All Messages            
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${${FORBIDDEN_CODE}}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/messages
    Response Should Contain Property With Value    message    error.http.403
    [Teardown]    Delete Created Client And User Group