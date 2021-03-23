*** Settings ***
Documentation    Tests to verify that getHistory api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification_producer/notification_producer_keywords.robot

# permission: notification.history.read
Test Setup    Run Keywords    Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}    
...    AND    Get History Id
Test Teardown     Delete All Sessions

*** Variables ***
${date_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[.]\\d{3}$
${invalid_history_id}    5cb972b70a99360001d369

*** Test Cases ***
TC_O2O_07195
    [Documentation]    [API][NotificationProducer][getHistory] Request with "notification.history.read" permission returns 200
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    Get History    ${HISTORY_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${HISTORY_ID}
    Response Should Contain All Property Values Are List Of Base64 Strings    contact
    Response Should Contain Property With String Value    transactionReference
    Response Should Contain Property With String Value    remark
    Response Should Contain Property With String Value    sourceType
    Response Should Contain Property With String Value    sourceId
    Response Should Contain Property With String Value    nestedTemplateHistory.action
    Response Should Contain Property With Value    nestedTemplateHistory.type    SMS
    Response Should Contain Property With String Value    nestedTemplateHistory.template
    Response Should Contain Property With String Value    nestedTemplateHistory.senderName
    Response Should Contain Property With String Or Null    createdBy
    Response Should Contain Property Matches Regex    createdDate    ${date_regex}
    Response Should Contain Property With String Or Null    lastModifiedBy
    Response Should Contain Property Matches Regex    lastModifiedDate    ${date_regex}

TC_O2O_07197
    [Documentation]    [API][NotificationProducer][getHistory] Request with "id" does not exist on DB returns 404 without body
    [Tags]    Regression    High    UnitTest
    Get History    ${invalid_history_id}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Be Empty Body