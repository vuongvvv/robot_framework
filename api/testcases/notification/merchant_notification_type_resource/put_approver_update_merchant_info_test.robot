*** Settings ***
Documentation    Tests to verify that approverUpdateMerchantInfo api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/merchant_notification_type_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${1}
${not_exist_merchant_id}    5b4f06ec30a578000198df80e

*** Test Cases ***
TC_O2O_01640
    [Documentation]    [API] [SMS] [approverUpdateMerchantInfo] MERCHANT ID does not exist on "notification.merchant_notification_type" table returns MERCHANT_NOT_EXISTS
    [Tags]    Regression    High    SmokeExclude    ASCO2O-10739
    Put Approver Update Merchant Info    ${type_id}    ${not_exist_merchant_id}    { "quotaLimit": 22, "senderName": "123", "status": "REJECTED", "statusMessage": "123" }
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    entityName    merchantId
    Response Should Contain Property With Value    errorKey    MERCHANT_NOT_EXISTS
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    fail validate case merchant id not exist
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    message    error.MERCHANT_NOT_EXISTS
    Response Should Contain Property With Value    params    merchantId