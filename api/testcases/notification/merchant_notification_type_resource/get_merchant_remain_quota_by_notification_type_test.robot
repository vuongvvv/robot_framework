*** Settings ***
Documentation    Tests to verify that getMerchantRemainQuotaByNotificationType api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/merchant_notification_type_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${1}

*** Test Cases ***
TC_O2O_00708
    [Documentation]     [API] [SMS] [Get Mechant Remaining Quota Limit] Request with valid typeId and merchantId returns data match with "notification.merchant_notification_type" table
    [Tags]      Regression     High    Smoke
    Get Merchant Remain Quota By Notification Type    ${type_id}    ${EXIST_O2O_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number String    id
    Response Should Contain Property With Value    typeId    ${type_id}
    Response Should Contain Property With Value    merchantId    ${EXIST_O2O_MERCHANT_ID}
    Response Should Contain Property With Number String    quotaRemaining