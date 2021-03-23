*** Settings ***
Documentation    Tests to verify that getSMSMessage api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/sms_message_resource_keywords.robot

# scope: sms.read
Suite Setup    Run Keywords    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
...    AND    Get Message Id
Suite Teardown     Delete All Sessions

*** Variables ***
${date_regex}    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z
@{message_status_list}    COMPLETED    SENDING    FAILED
${eleven_numbers_regex}    \\d{11}
@{audience_status_list}    DELIVERED    PENDING    FAILED    EXPIRED

*** Test Cases ***
TC_O2O_07244
    [Documentation]    [Notification][getSMSMessage] Request with "sms.read" scope returns 200
    [Tags]    Regression    High    Smoke    UnitTest
    Get SMS Message    ${MESSAGE_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdBy
    Response Should Contain Property Matches Regex    createdDate    ${date_regex}
    Response Should Contain Property With String Value    lastModifiedBy
    Response Should Contain Property Matches Regex    lastModifiedDate    ${date_regex}
    Response Should Contain Property With Value    id    ${MESSAGE_ID}
    Response Should Contain Property With String Value    senderName
    Response Should Contain Property With String Value    messageBody
    Response Should Contain Property With String Value    externalTransactionReference
    Response Should Contain Property With String Value    createdByClient
    Response Should Contain Property With String Value    createdByUser
    Response Should Contain Property With String Value    jobId
    Response Should Contain Property Value Include In List    status    ${message_status_list}
    Response Should Contain Property With String Or Null    remark
    Response Should Contain Property With Number String    creditsPerMessage
    Response Should Contain Property With Null Value    audiences

TC_O2O_07246
    [Documentation]    [Notification][getSMSMessage] Request with fields=audiences returns 200 with audiences information
    [Tags]    Regression    High    Smoke    UnitTest
    Get SMS Message    ${MESSAGE_ID}    fields=audiences
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdBy
    Response Should Contain Property Matches Regex    createdDate    ${date_regex}
    Response Should Contain Property With String Value    lastModifiedBy
    Response Should Contain Property Matches Regex    lastModifiedDate    ${date_regex}
    Response Should Contain Property With Value    id    ${MESSAGE_ID}
    Response Should Contain Property With String Value    senderName
    Response Should Contain Property With String Value    messageBody
    Response Should Contain Property With String Value    externalTransactionReference
    Response Should Contain Property With String Value    createdByClient
    Response Should Contain Property With String Value    createdByUser
    Response Should Contain Property With String Value    jobId
    Response Should Contain Property Value Include In List    status    ${message_status_list}
    Response Should Contain Property With String Or Null    remark
    Response Should Contain Property With Number String    creditsPerMessage
    Response Should Contain Property With String Value    audiences..createdBy
    Response Should Contain All Property Values Are String    audiences..createdBy
    Response Should Contain Property Matches Regex    audiences..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    audiences..lastModifiedBy
    Response Should Contain Property Matches Regex    audiences..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are Number    audiences..id
    Response Should Contain Property With List Matches Regex    audiences..contact    ${eleven_numbers_regex}
    Response Should Contain All Property Values Are String    audiences..transactionId
    Response Should Contain Property Value Include In List    audiences..status    ${audience_status_list}
    Response Should Contain All Property Values Are String Or Null    audiences..remark
    Response Should Contain All Property Values Are Null    audiences..message
    
TC_O2O_07245
    [Documentation]    [Notification][getSMSMessage] Request without "sms.read" scope returns 403
    [Tags]    Regression    High    Smoke    UnitTest
    [Setup]    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}    client_id_and_secret=robotautomationclientnoscope
    Get SMS Message    1
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    scope    sms.read
    Response Should Contain Property With Value    error_description    Insufficient scope for this resource
    Response Should Contain Property With Value    error    insufficient_scope