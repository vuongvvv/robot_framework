*** Settings ***
Documentation    Tests to verify that registerMerchantNotificationType api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/merchant_notification_type_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${sender_name}    AutoTestSN
${not_exist_type_id}    ${9999}
${not_exist_merchant_id}    5b4f06ec30a579000198df80

*** Test Cases ***
TC_O2O_00725
    [Documentation]    [API] [SMS] [SMS Marketing Campaign registration] Verify SMS Marketing Campaign registration api with not exist TYPE will return NOTIFICATION_TYPE_NOT_EXISTS
    [Tags]    Regression    Medium    SmokeExclude    ASCO2O-7957
    Post Register Merchant Notification Type    ${not_exist_type_id}    { "merchantId": "${not_exist_merchant_id}", "senderName": "${sender_name}" }
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property Matches Regex    errorKey    MERCHANT_NOT_EXISTS
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    message    error.MERCHANT_NOT_EXISTS
    Response Should Contain Property With Value    params    merchantId