*** Settings ***
Documentation    Tests to verify 2C2P payment API Query by Activity ID
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_creditcard
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.read

*** Variables ***
@{valide_require_field}    clientRefId must not be empty    paymentAccountId or trueyou(MerchantId and OutletId) is required

*** Test Cases ***
TC_O2O_17228
    [Documentation]    Verify response when query with access has invalid client scope
    [Tags]    Low    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY1&trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_17229
    [Documentation]    [SCB] Verify response when query with access has no permission for merchant outlet
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY1&trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${SCB_MERCHANT_ID} outlet: ${SCB_ACTIVE_OUTLET}

TC_O2O_22044
    [Documentation]    [2C2P] Verify response when query with access has no permission for merchant outlet
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY1&trueyouMerchantId=${2C2P_MERCHANT_ID}&trueyouOutletId=${2C2P_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${2C2P_MERCHANT_ID} outlet: ${2C2P_ACTIVE_OUTLET}

TC_O2O_22061
    [Documentation]    [Onetime OTP] Verify response when query with access has no permission for merchant outlet
    [Tags]    Medium    Regression    payment
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY1&trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${WALLET_MERCHANT_ID} outlet: ${WALLET_ACTIVE_OUTLET}

TC_O2O_17231
    [Documentation]    [SCB] Verify response when query with valid information
    [Tags]    Medium    Regression    Smoke    payment
    Prepare The Charge Transaction
    Get Payment By Client Ref Id    clientRefId=${CLIENT_REF_ID}&trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    ${CLIENT_REF_ID}
    Response Should Contain Property With Value    amount    1400
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    automate_script1
    Response Should Contain Property With Value    userDefine2    automate_script2
    Response Should Contain Property With Value    userDefine3    automate_script3
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_22046
    [Documentation]    [2C2P] Verify response when query with valid information
    [Tags]    Medium    Regression    Smoke    payment
    Prepare The Charge Transaction    ${2C2P_MERCHANT_ID}     ${2C2P_ACTIVE_OUTLET}
    Get Payment By Client Ref Id    clientRefId=${CLIENT_REF_ID}&trueyouMerchantId=${2C2P_MERCHANT_ID}&trueyouOutletId=${2C2P_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    ${CLIENT_REF_ID}
    Response Should Contain Property With Value    amount    1400
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    automate_script1
    Response Should Contain Property With Value    userDefine2    automate_script2
    Response Should Contain Property With Value    userDefine3    automate_script3
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${2C2P_ACTIVE_OUTLET}
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_17232
    [Documentation]    Verify response when query without clientRefId
    [Tags]    Medium    Regression    payment
    Get Payment By Client Ref Id    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId must not be empty

TC_O2O_17233
    [Documentation]    Verify response when query without trueyouMerchantId
    [Tags]    Low    Regression    payment
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY1&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouMerchantId must not be empty

TC_O2O_17234
    [Documentation]    Verify response when query without trueyouOutletId
    [Tags]    Low    Regression    payment
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY1&trueyouMerchantId=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouOutletId must not be empty

TC_O2O_17235
    [Documentation]    Verify response when query without clientRefId, trueyouOutletId and trueyouMerchantId and payment account id
    [Tags]    Medium    Regression    payment
    Get Payment By Client Ref Id
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property Value Include In List    errors..message    ${valide_require_field}

TC_O2O_17236
    [Documentation]    Verify response when clientRefId not match with merchant and outlet
    [Tags]    Medium    Regression    payment
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY11&trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_activity_not_found
    Response Should Contain Property With Value    errors..message    Activity Not Found

TC_O2O_17237
    [Documentation]    Verify response when invalid merchant and outlet
    [Tags]    Medium    Regression    payment
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY1&trueyouMerchantId=1111111&trueyouOutletId=11111
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_activity_not_found
    Response Should Contain Property With Value    errors..message    Activity Not Found

TC_O2O_19293
    [Documentation]    [Onetime OTP] Verify response when query status with valid information and payment_method is wallet
    [Tags]    Medium    Regression    Smoke    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_onetime_otp
    Get Payment By Client Ref Id    clientRefId=1TOTP-DUPP0001&trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    1TOTP-DUPP0001
    Response Should Contain Property With Value    amount    45001
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REGRESSION TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19296
    [Documentation]    [Onetime OTP] Verify response when query status with invalid trueyouMerchantId
    [Tags]    Medium    Regression    payment
    Get Payment By Client Ref Id    clientRefId=1TOTP-DUPP0001&trueyouMerchantId=1111111&trueyouOutletId=${WALLET_ACTIVE_OUTLET}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_activity_not_found
    Response Should Contain Property With Value    errors..message    Activity Not Found

TC_O2O_19297
    [Documentation]    [Onetime OTP] Verify response when query status with invalid trueyouOutletId
    [Tags]    Medium    Regression    payment
    Get Payment By Client Ref Id    clientRefId=1TOTP-DUPP0001&trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=11111
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_activity_not_found
    Response Should Contain Property With Value    errors..message    Activity Not Found

TC_O2O_19298
    [Documentation]    [Onetime OTP] Verify response when query status with invalid clientRefId
    [Tags]    Medium    Regression    payment
    Get Payment By Client Ref Id    clientRefId=3TOTP-DUPP0001&trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/transactions/query-activity
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_activity_not_found
    Response Should Contain Property With Value    errors..message    Activity Not Found

TC_O2O_22058
    [Documentation]    [SCB] Allow to query when Scb_credit_card_status is INACTIVE
    [Tags]    Medium    Regression    Smoke    payment
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY&trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_INACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_INACTIVE_OUTLET}
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.gatewayType    2C2P

TC_O2O_22059
    [Documentation]    [2C2P] Allow to query when Gateway_2c2p_credit_card_status is INACTIVE
    [Tags]    Medium    Regression    Smoke    payment
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY&trueyouMerchantId=${2C2P_MERCHANT_ID}&trueyouOutletId=${2C2P_INACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${2C2P_INACTIVE_OUTLET}
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.gatewayType    2C2P

TC_O2O_22060
    [Documentation]    [Onetime OTP] Allow to query when TMN ONETIME OTP FLAG is DISABLE
    [Tags]    Medium    Regression    Smoke    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_onetime_otp
    Get Payment By Client Ref Id    clientRefId=AUTOMATION-QUERY&trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With Value    transaction.gatewayType    TMN
