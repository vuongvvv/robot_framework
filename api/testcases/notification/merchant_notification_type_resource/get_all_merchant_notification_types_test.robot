*** Settings ***
Documentation    Tests to verify that getAllMerchantNotificationTypes api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/merchant_notification_type_resource_keywords.robot

# permission_name=notification.registration.approve,merchant.merchant.actAsAdmin
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${exist_type_id}    ${1}
${not_exist_type_id}    ${999}
${not_exist_merchant_id}    ${999}
${invalid_status}    INVALIDSTATUS

*** Test Cases ***
TC_O2O_01218
    [Documentation]     [notification][getAllMerchantNotificationTypes] Verify Get All Merchants SMS Registration api with fields=merchant will return valid response and merchant information.
    [Tags]      Regression     High    Smoke    ASCO2O-20849
    Get All Merchant Notification Types    ${exist_type_id}    fields=merchant
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .typeId    ${exist_type_id}
    Response Should Contain All Property Values Are String    .merchant..name

TC_O2O_00745
    [Documentation]     [API] [SMS] [Get All Merchants SMS Registration] Verify Get All Merchants SMS Registration api with SMS Type will return valid response and match with "notification.merchant_notification_type" table
    [Tags]      Regression     High    Smoke
    Get All Merchant Notification Types    ${exist_type_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .typeId    ${exist_type_id}

TC_O2O_00747
    [Documentation]     [API] [SMS] [Get All Merchants SMS Registration] Verify Get All Merchants SMS Registration api with only Type param will return all Merchant registration
    [Tags]      Regression     High
    Get All Merchant Notification Types    ${exist_type_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .typeId    ${exist_type_id}

TC_O2O_00748
    [Documentation]     [API] [SMS] [Get All Merchants SMS Registration] APPROVED, REQUESTED, REJECTED, or CANCELED status filter will return data match with "notification.merchant_notification_type" table
    [Tags]      Regression     High
    [Template]    Get All Merchant Notification Types With Filter
    ${exist_type_id}    status    in    APPROVED
    ${exist_type_id}    status    in    REQUESTED
    ${exist_type_id}    status    in    REJECTED
    ${exist_type_id}    status    in    CANCELED

TC_O2O_01036
    [Documentation]     [API] [SMS] [Get All Merchants SMS Registration] Status filter with multiple filters will return data match with "notification.merchant_notification_type" table
    [Tags]      Regression     Medium
    Get All Merchant Notification Types    ${exist_type_id}    status.in=APPROVED&status.in=CANCELED
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .typeId    ${exist_type_id}
    Response Should Contain All Property Values Include In List    .status    ['APPROVED', 'CANCELED']

TC_O2O_00750
    [Documentation]     [API] [SMS] [Get All Merchants SMS Registration] Verify Get All Merchants SMS Registration api with non exist TYPE ID will return NOTIFICATION_TYPE_NOT_EXISTS
    [Tags]      Regression     Medium
    Get All Merchant Notification Types    ${not_exist_type_id}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    entityName    entity_name
    Response Should Contain Property With Value    errorKey    NOTIFICATION_TYPE_NOT_EXISTS
    Response Should Contain Property With Value    title    fail notification not found
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    message    error.NOTIFICATION_TYPE_NOT_EXISTS
    Response Should Contain Property With Value    params    entity_name

TC_O2O_00751
    [Documentation]     [API] [SMS] [Get All Merchants SMS Registration] Verify Get All Merchants SMS Registration api with empty STATUS or MERCHANT ID returns 200 with empty body
    [Tags]      Regression     High
    [Template]    Get All Merchant Notification Types With Empty Filter
    ${exist_type_id}    status.in=
    ${exist_type_id}    merchantId.equals=

TC_O2O_00752
    [Documentation]     [API] [SMS] [Get All Merchants SMS Registration] Verify Get All Merchants SMS Registration api with STATUS is not in the status list returns 400
    [Tags]      Regression     Medium
    Get All Merchant Notification Types    ${exist_type_id}    status.in=${invalid_status}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/types/${exist_type_id}/merchants
    Response Should Contain Property With Value    violations..field    status.in
    Response Should Contain Property With Value    violations..message    Failed to convert property value of type 'java.lang.String' to required type 'java.util.List' for property 'status.in'; nested exception is org.springframework.core.convert.ConversionFailedException: Failed to convert from type [java.lang.String] to type [com.ascend.o2o.notification.domain.enumeration.MerchantStatus] for value 'INVALIDSTATUS'; nested exception is java.lang.IllegalArgumentException: No enum constant com.ascend.o2o.notification.domain.enumeration.MerchantStatus.INVALIDSTATUS
    Response Should Contain Property With Value    message    Error occur during the request

TC_O2O_00753
    [Documentation]     [API] [SMS] [Get All Merchants SMS Registration] Verify Get All Merchants SMS Registration api with not exist MERCHANT ID will return success without results
    [Tags]      Regression     Medium
    Get All Merchant Notification Types    ${exist_type_id}    merchantId.equals=${not_exist_merchant_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty

TC_O2O_00754
    [Documentation]     [API] [SMS] [Get All Merchants SMS Registration] Verify Get All Merchants SMS Registration api can only be accessed by ROLE_ADMIN
    [Tags]      Regression     Medium
    Get All Merchant Notification Types    ${exist_type_id}
    Response Correct Code    ${SUCCESS_CODE}    
    Response Should Contain All Property Values Equal To Value    .typeId    ${exist_type_id}