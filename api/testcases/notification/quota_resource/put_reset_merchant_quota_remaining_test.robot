*** Settings ***
Documentation    Tests to verify that resetMerchantQuotaRemaining api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/quota_resource_keywords.robot

# scope: batch_processor
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${1}
${not_exist_type_id}    ${9999999}
*** Test Cases ***
TC_O2O_04054
    [Documentation]    [Notification][resetMerchantQuotaRemaining] User with "batch_processor" scope can access resetMerchantQuotaRemaining API
    [Tags]    Regression    Medium    Smoke
    Put Reset Merchant Quota Remaining    ${type_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    typeName    SMS_Marketing
    Response Should Contain Property With Number String    affected_row

TC_O2O_07652
    [Documentation]     [Notification][resetMerchantQuotaRemaining] User without "batch_processor" scope request resetMerchantQuotaRemaining API returns 403
    [Tags]      Regression     Medium    Smoke
    [Setup]    Generate Gateway Header With Scope and Permission    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
    Put Reset Merchant Quota Remaining    ${not_exist_type_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    scope    batch_processor
    Response Should Contain Property With Value    error_description    Insufficient scope for this resource
    Response Should Contain Property With Value    error    insufficient_scope