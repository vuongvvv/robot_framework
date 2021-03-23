*** Settings ***
Documentation    Tests to verify 2C2P payment API Query transaction list by merchant or admin scope
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
Test Teardown    Delete All Sessions
#Require Client Scope: payment.payment.list
#Note! What the difference for 3 Clients
# 1. robotautomationclientpayment_creditcard >> (merchant role) have scope = payment.payment.list in UAA
# 2. robotautomationclientpayment_admin >> (admin role) no scope = payment.payment.list in UAA and wePayment Access Control
# 3. robotautomationclient_wepayment >> (merchant role) have scope = payment.payment.list in wePayment Access Control

*** Variables ***
@{validate_query_merchant_format}    trueyouMerchantId.equals is required    trueyouMerchantId.in is not supported
@{validate_query_payment_acc_format}    paymentAccountId.equals is required    paymentAccountId.in is not supported
@{validate_query_outlet_format}    trueyouOutletId.equals is required    trueyouOutletId.in is not supported

*** Test Cases ***
TC_O2O_17239
    [Documentation]    [TrueYouMerchant][SCB] Verify response WHEN query but not found valid Scope
    [Tags]    Low    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientnoscope
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_17240
    [Documentation]    [TrueYouMerchant][SCB] Verify response WHEN access_client no permission for merchant and outlet
    [Tags]    Medium    Regression    UnitTest    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_no_authority
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${SCB_MERCHANT_ID} outlet: ${SCB_ACTIVE_OUTLET}

TC_O2O_22024
    [Documentation]    [TrueYouMerchant][2C2P] Verify response WHEN access_client no permission for merchant and outlet
    [Tags]    Medium    Regression    UnitTest    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_no_authority
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${2C2P_MERCHANT_ID}&trueyouOutletId.equals=${2C2P_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${2C2P_MERCHANT_ID} outlet: ${2C2P_ACTIVE_OUTLET}

TC_O2O_17242
    [Documentation]    [TrueYouMerchant][SCB] Verify response WHEN merchant has permission for merchant and outlet
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionId
    Response Should Contain All Property Values Are String Or Empty List    .paymentAccountId
    Response Should Contain Property With Value    .'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    .'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With Null Value    .'trueyouTerminalId'
    Response Should Contain Property With Value    .gatewayType    2C2P
    Response Should Contain Property With String Value    .pan
    Response Should Contain Property With String Value    .status
    Response Should Contain Property With String Value    .eci
    Response Should Contain Property With String Value    .approvalCode
    Response Should Contain Property With String Value    .paymentScheme
    Response Should Contain Property With String Value    .paymentProcess
    Response Should Contain Property With String Value    .amount
    Response Should Contain Property With Value    .paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    .createdDate
    Response Should Contain Property With String Value    .lastModifiedDate

TC_O2O_22025
    [Documentation]    [TrueYouMerchant][2C2P] Verify response WHEN merchant has permission for merchant and outlet
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${2C2P_MERCHANT_ID}&trueyouOutletId.equals=${2C2P_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionId
    Response Should Contain All Property Values Are String Or Empty List    .paymentAccountId
    Response Should Contain Property With Value    .'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
    Response Should Contain Property With Value    .'trueyouOutletId'    ${2C2P_ACTIVE_OUTLET}
    Response Should Contain Property With Null Value    .'trueyouTerminalId'
    Response Should Contain Property With Value    .gatewayType    2C2P
    Response Should Contain Property With String Value    .pan
    Response Should Contain Property With String Value    .status
    Response Should Contain Property With String Value    .eci
    Response Should Contain Property With String Value    .approvalCode
    Response Should Contain Property With String Value    .paymentScheme
    Response Should Contain Property With String Value    .paymentProcess
    Response Should Contain Property With String Value    .amount
    Response Should Contain Property With Value    .paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    .createdDate
    Response Should Contain Property With String Value    .lastModifiedDate

TC_O2O_17244
    [Documentation]    [TrueYouMerchant][SCB, 2C2P] Verify response WHEN query with invalid merchant
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.equals=10111000010000X
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found

TC_O2O_17245
    [Documentation]    [TrueYouMerchant][SCB, 2C2P] Verify response WHEN query with invalid outlet
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=243X&trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found

TC_O2O_17246
    [Documentation]    [TrueYouMerchant][SCB, 2C2P]  Verify response WHEN query with invalid merchant and outlet
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=243X&trueyouMerchantId.equals=10111000010000X
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found

TC_O2O_17247
    [Documentation]    [TrueYouMerchant] Verify response WHEN access with merchant scope but not send trueyouMerchantId
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouMerchantId.equals is required

TC_O2O_22029
    [Documentation]    [TrueYouMerchant] Verify response WHEN access with merchant scope and send paymentAccountId with trueyouMerchantId
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=${VALID_PAYMENT_ACCOUNT_ID}&trueyouOutletId.equals=${2C2P_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    paymentAccountId and trueyou(MerchantId and OutletId) can't request at the same time

TC_O2O_22030
    [Documentation]    [TrueYouMerchant] Verify response WHEN access with merchant scope and send paymentAccountId with trueyouMerchantId
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=${VALID_PAYMENT_ACCOUNT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    paymentAccountId and trueyou(MerchantId and OutletId) can't request at the same time

TC_O2O_17248
    [Documentation]    [TrueYouMerchant] Verify response WHEN access with merchant scope but not send trueyouOutletId
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouOutletId.equals is required

TC_O2O_17249
    [Documentation]    [TrueYouMerchant] Verify response WHEN access with merchant scope but not send trueyouMerchantId and trueyouOutletId and paymentAccountId
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    paymentAccountId or trueyou(MerchantId and OutletId) is required

TC_O2O_17250
    [Documentation]    [TrueYouMerchant][SCB, 2C2P] Verify response WHEN not found any transaction in valid merchant and outlet
    [Tags]    Medium    Regression    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.equals=${SCB_MERCHANT_ID}&amount.lessThan=0
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty

TC_O2O_17260
    [Documentation]    [TrueYouMerchant][SCB, 2C2P] Not support to search by trueyouMerchantId WHEN function !=equals and access with merchant scope
    [Tags]    Medium    Regression    UnitTest    payment
    #verify full message response
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.in=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property Value Include In List    errors..message    ${validate_query_merchant_format}
    #verify only response code is enought
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.contains=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.specified=true
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.specified=false
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.greaterThan=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.lessThan=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.greaterOrEqualThan=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.lessOrEqualThan=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}

TC_O2O_17262
    [Documentation]    [TrueYouMerchant][SCB, 2C2P] Not support to search by trueyouOutletId WHEN function != equals and access with merchant scope
    [Tags]    Medium    Regression    UnitTest    payment
    #verify full message response
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.in=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property Value Include In List    errors..message    ${validate_query_outlet_format}
    #verify only response code is enought
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.contains=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.specified=true&trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.specified=false&trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.greaterThan=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.lessThan=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.greaterOrEqualThan=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.lessOrEqualThan=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.equals=${SCB_MERCHANT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}

TC_O2O_17265
    [Documentation]    [TrueYouMerchant] Allow to search by pan
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&1pan.equals=530131XXXXXX0390
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .pan    530131XXXXXX0390
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&pan.in=530131XXXXXX0390
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&pan.contains=530131XXXXXX0390
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&pan.specified=true
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&pan.specified=false
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&pan.greaterThan=530131XXXXXX0390
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&pan.lessThan=530131XXXXXX0390
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&pan.greaterOrEqualThan=530131XXXXXX0390
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&pan.lessThanOrEqualThan=530131XXXXXX0390
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_17266
    [Documentation]    [TrueYouMerchant] Allow to search by status
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.equals=SETTLED
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .status    SETTLED
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.in=SETTLED
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.contains=SETTLED
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.specified=true
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.specified=false
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.greaterThan=SETTLED
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.lessThan=SETTLED
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.greaterOrEqualThan=SETTLED
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.lessThanOrEqualThan=SETTLED
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_17267
    [Documentation]    [TrueYouMerchant] Allow to search by eci
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&eci.equals=00
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .eci    00
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&eci.in=00
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&eci.contains=00
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&eci.specified=true
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&eci.specified=false
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&eci.greaterThan=00
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&eci.lessThan=00
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&eci.greaterOrEqualThan=00
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&eci.lessThanOrEqualThan=00
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_17271
    [Documentation]    [TrueYouMerchant] Allow to search by amount
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&amount.equals=220
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .amount    ${220}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&amount.in=220
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&amount.contains=220
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&amount.specified=true
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&amount.specified=false
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&amount.greaterThan=220
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&amount.lessThan=220
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&amount.greaterOrEqualThan=220
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&amount.lessThanOrEqualThan=220
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_17272
    [Documentation]    [TrueYouMerchant] Allow to search by paymentMethod
    [Tags]    Medium    Regression    UnitTest    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&paymentMethod.equals=CREDIT_CARD
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod    CREDIT_CARD
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&paymentMethod.in=WALLET
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod    WALLET
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&paymentMethod.contains=CREDIT_CARD
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&paymentMethod.specified=true
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&paymentMethod.specified=false
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&paymentMethod.greaterThan=CREDIT_CARD
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&paymentMethod.lessThan=CREDIT_CARD
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&paymentMethod.greaterOrEqualThan=CREDIT_CARD
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&paymentMethod.lessThanOrEqualThan=CREDIT_CARD
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_22035
    [Documentation]    [TrueYouMerchant] Allow to search by gatewayType
    [Tags]    Medium    Regression    UnitTest    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Get Payment Transaction List By Merchant Or Admin    gatewayType.equals=2C2P
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .gatewayType    2C2P
    Get Payment Transaction List By Merchant Or Admin    gatewayType.in=2C2P
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .gatewayType    2C2P
    Get Payment Transaction List By Merchant Or Admin    gatewayType.contains=2C2P
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    gatewayType.specified=true
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    gatewayType.specified=false
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    gatewayType.greaterThan=2C2P
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    gatewayType.lessThan=2C2P
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    gatewayType.greaterOrEqualThan=2C2P
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Transaction List By Merchant Or Admin    gatewayType.lessThanOrEqualThan=2C2P
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_22040
    [Documentation]    [TrueYouMerchant][SCB] Allow to query when merchant status is inactive client role is merchant
    [Tags]    Medium    Regression    Smoke    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_INACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    .'trueyouOutletId'    ${SCB_INACTIVE_OUTLET}
    Response Should Contain Property With Value    .gatewayType    2C2P

TC_O2O_22041
    [Documentation]    [TrueYouMerchant][2C2P] Allow to query when merchant status is inactive client role is merchant
    [Tags]    Medium    Regression    payment
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${2C2P_MERCHANT_ID}&trueyouOutletId.equals=${2C2P_INACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionId
    Response Should Contain Property With Value    .'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
    Response Should Contain Property With Value    .'trueyouOutletId'    ${2C2P_INACTIVE_OUTLET}
    Response Should Contain Property With Value    .gatewayType    2C2P

TC_O2O_22042
    [Documentation]    [TrueYouMerchant][SCB] Allow to query when merchant status is inactive client role is admin
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_INACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String Or Empty List    .paymentAccountId
    Response Should Contain Property With Value    .'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    .'trueyouOutletId'    ${SCB_INACTIVE_OUTLET}
    Response Should Contain Property With Value    .gatewayType    2C2P

TC_O2O_22043
    [Documentation]    [TrueYouMerchant][2C2P] Allow to query when merchant status is inactive client role is admin
    [Tags]    Medium    Regression    Smoke    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${2C2P_MERCHANT_ID}&trueyouOutletId.equals=${2C2P_INACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String Or Empty List    .paymentAccountId
    Response Should Contain Property With Value    .'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
    Response Should Contain Property With Value    .'trueyouOutletId'    ${2C2P_INACTIVE_OUTLET}
    Response Should Contain Property With Value    .gatewayType    2C2P

TC_O2O_24138
    [Documentation]    [TrueYouMerchant][2C2P][QUERY] Verify mask pan creditcard in response after search merchant payment transaction
    [Tags]    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${2C2P_MERCHANT_ID}&trueyouOutletId.equals=${2C2P_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String Or Empty List    .paymentAccountId
    Response Should Contain Property With Value    .'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
    Response Should Contain Property With Value    .'trueyouOutletId'    ${2C2P_ACTIVE_OUTLET}
    Response Should Contain Property With Value    .gatewayType    2C2P
    Response Should Contain Property With Value    .pan    530131XXXXXX0390

TC_O2O_24140
    [Documentation]    [TrueYouMerchant][TMN][QUERY] No mask pan creditcard in response after search merchant payment transaction
    [Tags]    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${WALLET_MERCHANT_ID}&trueyouOutletId.equals=${WALLET_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String Or Empty List    .paymentAccountId
    Response Should Contain Property With Value    .'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    .'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Contain Property With Value    .gatewayType    TMN
    Response Should Contain Property With Null Value    .pan

TC_O2O_25700
    [Documentation]    [Payment Account] Allow to query by payment account when have wepayment with admin scope
    [Tags]    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=${VALID_PAYMENT_ACCOUNT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain All Property Values Are String Or Empty List    .'trueyouMerchantId'
    Response Should Contain All Property Values Are String Or Empty List    .'trueyouOutletId'
    Response Should Contain Property With Value    .gatewayType    OMISE
    Response Should Contain Property With String Value    .pan
    Response Should Contain Property With String Value    .status
    Response Should Contain Property With String Value    .eci
    Response Should Contain Property With String Value    .approvalCode
    Response Should Contain Property With String Value    .paymentScheme
    Response Should Contain Property With String Value    .paymentProcess
    Response Should Contain Property With String Value    .amount
    Response Should Contain Property With Value    .paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    .createdDate
    Response Should Contain Property With String Value    .lastModifiedDate

TC_O2O_25701
    [Documentation]    [Payment Account] Not allow to query when no valid wepayment client scope case no admin scope
    [Tags]    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientnoscope
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=${VALID_PAYMENT_ACCOUNT_ID}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_25702
    [Documentation]    [Payment Account] Not allow to query when no merchant authorized case no admin scope
    [Tags]    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_no_authority
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=${VALID_PAYMENT_ACCOUNT_ID}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_25703
    [Documentation]    [Payment Account] Not allow to query when payment account not found
    [Tags]    Regression    payment
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=pid_0x0slml
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_found
    Response Should Contain Property With Value    errors..message    Payment Account Not Found

TC_O2O_25704
    [Documentation]    [Payment Account] Allow to query when payment account is Inactive
    [Tags]    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=${INACTIVE_PAYMENT_ACCOUNT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25705
    [Documentation]    [Payment Account] Allow to query when omise account is Inactive
    [Tags]    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=${INACTIVE_OMISE_ACCOUNT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25706
    [Documentation]    [Payment Account] Allow to search by pan
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=${VALID_PAYMENT_ACCOUNT_ID}&1pan.equals=XXXXXXXXXXXX1111
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .pan    XXXXXXXXXXXX1111

TC_O2O_25707
    [Documentation]    [Payment Account] Not allow to query with TrueYouMerchant and Payment Account
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.contains=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.equals=${SCB_MERCHANT_ID}&paymentAccountId.equals=${VALID_PAYMENT_ACCOUNT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    paymentAccountId and trueyou(MerchantId and OutletId) can't request at the same time

TC_O2O_25712
    [Documentation]    [TrueYouMerchant] Can access all merchant when have admin role query with valid merchant and outlet
    [Tags]    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Get Payment Transaction List By Merchant Or Admin    trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&trueyouMerchantId.in=${SCB_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    .'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With Value    .gatewayType    2C2P

TC_O2O_25713
    [Documentation]    [TrueYouMerchant] Allow to search without any require param when access with admin scope
    [Tags]    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Get Payment Transaction List By Merchant Or Admin
    Response Correct Code    ${SUCCESS_CODE}
