*** Settings ***
Documentation    Tests to verify that getMerchantByNotificationType api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/merchant_notification_type_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${exist_type_id}    ${1}
${not_exist_type_id}    ${9999}
${not_exist_merchant_id}    5bebff51dc29080001f581ce

*** Test Cases ***
TC_O2O_00841
    [Documentation]     [API] [SMS] [Get Merchant Notification Infor] Verify Get Merchant Notification Infor api with valid params return data match with "notification.merchant_notification_type" table
    [Tags]      Regression     High    Smoke
    Get Merchant By Notification Type    ${exist_type_id}    ${EXIST_O2O_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    typeId    ${exist_type_id}
    Response Should Contain Property With Value    merchantId    ${EXIST_O2O_MERCHANT_ID}
    
TC_O2O_00842
    [Documentation]     [API] [SMS] [Get Merchant Notification Infor] Verify Get Merchant Notification Infor api with MERCHANT ID does not exist on "notification.merchant_notification_type" table returns MERCHANT_NOT_EXISTS
    [Tags]      Regression     Medium    UnitTest
    Get Merchant By Notification Type    ${exist_type_id}    ${not_exist_merchant_id}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    entityName    merchantId
    Response Should Contain Property With Value    errorKey    MERCHANT_NOT_EXISTS
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    fail validate case merchant id not exist
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    message    error.MERCHANT_NOT_EXISTS
    Response Should Contain Property With Value    params    merchantId
    
TC_O2O_00843
    [Documentation]     [API] [SMS] [Get Merchant Notification Infor] Verify Get Merchant Notification Infor api with NOTIFICATION TYPE does not exist on "notification.merchant_notification_type" table returns NOTIFICATION_TYPE_NOT_EXISTS
    [Tags]      Regression     Medium
    Get Merchant By Notification Type    ${not_exist_type_id}    ${EXIST_MERCHANT_ID}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    errorKey    NOT_FOUND
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Merchant or notification type is not found.
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    message    error.NOT_FOUND
    Response Should Contain Property With Empty Value    params
    
TC_O2O_00844
    [Documentation]     [API] [SMS] [Get Merchant Notification Infor] Request with ROLE_USER does not bind with queried merchant returns 403
    [Tags]      Regression     Medium
    [Setup]    Prepare Test Date For Notification    ${ROLE_USER}
    Clean Notification Test Data
    Generate Gateway Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
    Get Merchant By Notification Type    ${exist_type_id}    ${EXIST_MERCHANT_ID}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    entityName    merchantId
    Response Should Contain Property With Value    errorKey    permissiondenied
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Permission Denied
    Response Should Contain Property With Value    status    ${${FORBIDDEN_CODE}}
    Response Should Contain Property With Value    message    error.permissiondenied
    Response Should Contain Property With Value    params    merchantId
    [Teardown]    NONE

TC_O2O_00845
    [Documentation]     [API] [SMS] [Get Merchant Notification Infor] Request with ROLE_USER binds to merchant returns success
    [Tags]      Regression     High
    [Setup]    Prepare Test Date For Notification    ${ROLE_USER}
    Generate Gateway Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
    Get Merchant By Notification Type    ${exist_type_id}    ${EXIST_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    typeId    ${exist_type_id}
    Response Should Contain Property With Value    merchantId    ${EXIST_MERCHANT_ID}

TC_O2O_00846
    [Documentation]     [API] [SMS] [Get Merchant Notification Infor] Request with ROLE_USER does not bind to any merchant returns 403
    [Tags]      Regression     Medium
    [Setup]    Prepare Test Date For Notification    ${ROLE_USER}
    Clean Notification Test Data
    Generate Gateway Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}        
    Get Merchant By Notification Type    ${exist_type_id}    ${EXIST_MERCHANT_ID}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    entityName    merchantId
    Response Should Contain Property With Value    errorKey    permissiondenied
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Permission Denied
    Response Should Contain Property With Value    status    ${${FORBIDDEN_CODE}}
    Response Should Contain Property With Value    message    error.permissiondenied
    Response Should Contain Property With Value    params    merchantId
    [Teardown]    NONE