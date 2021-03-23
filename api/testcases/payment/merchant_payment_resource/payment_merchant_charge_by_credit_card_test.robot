*** Settings ***
Documentation    Tests to verify 2C2P payment API by credit card
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_creditcard
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.charge

*** Variables ***
${external_ref_id_length}    20
${userDefine1}    active merchant
${userDefine2}    automation_test_script
${userDefine3}    charge transaction
@{validate_amount_empty}    amount must not be empty    amount is invalid.
@{validate_recurring_amount_empty}    recurring.recurringAmount is invalid.    recurring.recurringAmount must not be empty
@{validate_recurring_count_empty}    recurring.recurringCount must not be empty    recurring.recurringCount is invalid.
@{validate_recurring_accum_amount_empty}    recurring.accumulateMaxAmount must not be empty    recurring.accumulateMaxAmount is invalid.

*** Test Cases ***
TC_O2O_16683
    [Documentation]    Not allow to Charge when access client has invalid client scope
    [Tags]    Medium    Regression    UnitTest    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_16684
    [Documentation]    Not allow to Charge when invalid merchant and valid Outlet
    [Tags]    Medium    Regression    UnitTest    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_admin
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message For Invalid Merchant    0000000    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "0000000","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "0000000","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found
    Response Should Not Contain Property    errors..activityId

TC_O2O_16685
    [Documentation]    Not allow to Charge when valid merchant and invalid Outlet
    [Tags]    Medium    Regression    UnitTest    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_admin
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message For Invalid Merchant    ${SCB_MERCHANT_ID}    2431    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "2431","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "2431","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found
    Response Should Not Contain Property    errors..activityId

TC_O2O_16686
    [Documentation]    Not allow to Charge when invalid merchant and Outlet
    [Tags]    Medium    Regression    UnitTest    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_admin
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message For Invalid Merchant    0000000    2431    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "0000000","trueyouOutletId": "2431","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "0000000","trueyouOutletId": "2431","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found
    Response Should Not Contain Property    errors..activityId

TC_O2O_16687
    [Documentation]    Not allow to charge when SCB status =Inactive
    [Tags]    Medium    Regression    Smoke    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_INACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_INACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_INACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_not_active
    Response Should Contain Property With Value    errors..message    Merchant credit card is inactive
    Response Should Not Contain Property    errors..activityId

TC_O2O_16688
    [Documentation]    Not allow to charge when SCB status is empty string or NULL
    [Tags]    Medium    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_NO_STATUS_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_NO_STATUS_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_NO_STATUS_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_not_active
    Response Should Contain Property With Value    errors..message    Merchant credit card is inactive
    Response Should Not Contain Property    errors..activityId

TC_O2O_16689
    [Documentation]    Not allow to charge when SCB_MID is invalid
    [Tags]    Low    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_MID_INVALID}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MID_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MID_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    2_bad_request
    Response Should Contain Property With Value    errors..message    HashValue does not match.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_16690
    [Documentation]    [SCB] Allow to charge success without recurring and installment plan when SCB status is Active and all request info is valid
    [Tags]    Medium    Regression    Smoke    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    ${userDefine1}
    Response Should Contain Property With Value    userDefine2    ${userDefine2}
    Response Should Contain Property With Value    userDefine3    ${userDefine3}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_20874
    [Documentation]    [2C2P] Allow to charge success without recurring and installment plan when 2C2P gateway status is Active and all request info is valid
    [Tags]    Medium    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${2C2P_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD

TC_O2O_21839
    [Documentation]    [SCB, 2C2P] Allow to charge when access client not in allow list (admin role)
    [Tags]    Medium    Regression    Smoke    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_admin
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    ${userDefine1}
    Response Should Contain Property With Value    userDefine2    ${userDefine2}
    Response Should Contain Property With Value    userDefine3    ${userDefine3}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_16695
    [Documentation]    Not allow to charge when clientRefId is duplicate
    [Tags]    Medium    Regression    UnitTest    payment
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "DuplicateCL001","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "DuplicateCL001","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_duplicate_transaction
    Response Should Contain Property With Value    errors..message    Duplicate External Transaction
    Response Should Not Contain Property    errors..activityId

TC_O2O_16696
    [Documentation]    Not allow to charge when credit card information is reject
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${reject_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${reject_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    2_99
    Response Should Contain Property With Value    errors..message    Invalid Expiry Date
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_16697
    [Documentation]    Not allow to charge when credit card information is invalid (unable to decrypt)
    [Tags]    Low    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${undecrypt_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${undecrypt_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    2_99
    Response Should Contain Property With Value    errors..message    The length of 'pan' field does not match.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_16698
    [Documentation]    Not allow to charge when amount is invalid format (xx.xx)
    [Tags]    Low    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "81.12","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "81.12","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    amount is invalid.
    Response Should Not Contain Property    errors..activityId

TC_O2O_16699
    [Documentation]    Not allow to charge when amount is empty
    [Tags]    Low    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property Value Include In List    errors..message    ${validate_amount_empty}
    Response Should Not Contain Property    errors..activityId

TC_O2O_16700
    [Documentation]    Not allow to charge when currency is not THB
    [Tags]    Low    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "CNY","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "CNY","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    currency is invalid.
    Response Should Not Contain Property    errors..activityId

TC_O2O_16701
    [Documentation]    Not allow to charge when currency is null
    [Tags]    Low    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": null,"clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": null,"clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    currency must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_16702
    [Documentation]    Not allow to charge when clientRefId is null
    [Tags]    Low    Regression    UnitTest    payment
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": null,"paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": null,"paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_16703
    [Documentation]     Not allow to charge when clientRefId is empty
    [Tags]    Low    Regression    UnitTest    payment
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_16704
     [Documentation]    Not allow to charge when clientRefId is longer than 50 charactor
     [Tags]    Low    Regression    UnitTest    payment
     Generate Transaction Reference    51
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    clientRefId length must be less than or equal to 50
     Response Should Not Contain Property    errors..activityId

TC_O2O_16705
     [Documentation]    Not allow to charge when clientRefId input html tag
     [Tags]    Low    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}</body>","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}</body>","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    clientRefId The HTML tag are not allowed
     Response Should Not Contain Property    errors..activityId

TC_O2O_16706
     [Documentation]    Not allow to charge when paymentMethod =WALLET
     [Tags]    Low    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "WALLET","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "WALLET","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_payment_not_support
     Response Should Contain Property With Value    errors..message    Not support payment method
     Response Should Not Contain Property    errors..activityId

TC_O2O_16707
     [Documentation]    Not allow to charge when paymentMethod =credit_card
     [Tags]    Low    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "credit_card","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "credit_card","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    paymentMethod is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_16708
     [Documentation]    Not allow to charge when paymentInfo is empty
     [Tags]    Low    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :""}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    paymentInfo must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_16709
     [Documentation]    Not allow to charge when paymentInfo is null
     [Tags]    Low    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :null}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :null,"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    paymentInfo must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_16710
     [Documentation]    Allow to charge when no userDefine1 in request body
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Null Value    userDefine1
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Value    userDefine3    ${userDefine3}

TC_O2O_16711
     [Documentation]    Allow to charge when no userDefine2 in request body
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Value    userDefine1    ${userDefine1}
     Response Should Contain Property With Null Value    userDefine2
     Response Should Contain Property With Value    userDefine3    ${userDefine3}

TC_O2O_16712
     [Documentation]    Allow to charge when no userDefine3 in request body
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Value    userDefine1    ${userDefine1}
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Null Value    userDefine3

TC_O2O_16713
     [Documentation]    Allow to charge when no userDefine1, 2 and 3 in request body
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Null Value    userDefine1
     Response Should Contain Property With Null Value    userDefine2
     Response Should Contain Property With Null Value    userDefine3

TC_O2O_16714
     [Documentation]    Not allow to charge when Trueyou_merchant_id is over 20 charactors
     [Tags]    Low    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "110000000011609189175","trueyouOutletId": "24301","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "110000000011609189175","trueyouOutletId": "24301","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    trueyouMerchantId length must be less than or equal to 20
     Response Should Not Contain Property    errors..activityId

TC_O2O_16715
     [Documentation]    Not allow to charge when Trueyou_outlet_id is over 20 charactors
     [Tags]    Low    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "110000000011609189001","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "110000000011609189001","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    trueyouOutletId length must be less than or equal to 20
     Response Should Not Contain Property    errors..activityId

TC_O2O_17966
     [Documentation]    Not allow to charge when the request body (amount) un-match encrypt message
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "100","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_signature_invalid
     Response Should Contain Property With Value    errors..message    Signature is invalid
     Response Should Not Contain Property    errors..activityId

TC_O2O_17967
     [Documentation]    Not allow to charge when the request body (currency) un-match encrypt message
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "CNY","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_signature_invalid
     Response Should Contain Property With Value    errors..message    Signature is invalid
     Response Should Not Contain Property    errors..activityId

TC_O2O_17968
     [Documentation]    Not allow to charge when the request body (clientRefId) un-match encrypt message
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "RE-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_signature_invalid
     Response Should Contain Property With Value    errors..message    Signature is invalid
     Response Should Not Contain Property    errors..activityId

TC_O2O_17970
     [Documentation]    Not allow to charge when the request body (paymentInfo) un-match encrypt message
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${reject_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_signature_invalid
     Response Should Contain Property With Value    errors..message    Signature is invalid
     Response Should Not Contain Property    errors..activityId

TC_O2O_17971
     [Documentation]    Not allow to charge when the request body (trueyouMerchantId) un-match encrypt message
     [Tags]    Medium    Regression    Smoke    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "1200011","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_signature_cannot_decrypt
     Response Should Contain Property With Value    errors..message    Signature cannot decrypt
     Response Should Not Contain Property    errors..activityId

TC_O2O_17972
     [Documentation]    Not allow to charge when the request body (trueyouOutletId) un-match encrypt message
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "10110","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_signature_cannot_decrypt
     Response Should Contain Property With Value    errors..message    Signature cannot decrypt
     Response Should Not Contain Property    errors..activityId

TC_O2O_17976
     [Documentation]    Not allow to charge when scb_credit_card_merchant_secret_key is invalid
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_SCB_SECRET_INVALID}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_SCB_SECRET_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_SCB_SECRET_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    2_bad_request
     Response Should Contain Property With Value    errors..message    HashValue does not match.
     Response Should Contain Property With String Value    errors..activityId

TC_O2O_17977
    [Documentation]    Not allow to charge when scb_credit_card_merchant_secret_key in CMS is empty
    [Tags]    Medium    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_SCB_SECRET_EMPTY}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_SCB_SECRET_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_SCB_SECRET_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message    Merchant information is incomplete
    Response Should Not Contain Property    errors..activityId

TC_O2O_20867
     [Documentation]    [SCB] Not allow to charge when SCB_MID is empty
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_MID_EMPTY}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MID_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MID_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
     Response Should Contain Property With Value    errors..message    Merchant information is incomplete
     Response Should Not Contain Property    errors..activityId

TC_O2O_20869
     [Documentation]    [SCB] Not allow to charge when Scb_credit_card_ascend_rate is empty
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_ASC_RATE_EMPTY}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_ASC_RATE_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_ASC_RATE_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
     Response Should Contain Property With Value    errors..message    Merchant information is incomplete
     Response Should Not Contain Property    errors..activityId

TC_O2O_20870
     [Documentation]    [SCB] Not allow to charge when Scb_credit_card_merchant_rate is empty
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_MERCHANT_RATE_EMPTY}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_RATE_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_RATE_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
     Response Should Contain Property With Value    errors..message    Merchant information is incomplete
     Response Should Not Contain Property    errors..activityId

TC_O2O_20879
     [Documentation]    Not allow to charge when Credit_card_gateway is empty
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${NA_MERCHANT_ID}    ${NA_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${NA_MERCHANT_ID}","trueyouOutletId": "${NA_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${NA_MERCHANT_ID}","trueyouOutletId": "${NA_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
     Response Should Contain Property With Value    errors..message    Merchant information is incomplete
     Response Should Not Contain Property    errors..activityId

TC_O2O_20880
     [Documentation]    [2C2P] Not allow to charge when Gateway_2c2p_credit_card_merchant_secret_key is empty
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_MERCHANT_SECRET_KEY_EMPTY}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_MERCHANT_SECRET_KEY_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_MERCHANT_SECRET_KEY_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
     Response Should Contain Property With Value    errors..message    Merchant information is incomplete
     Response Should Not Contain Property    errors..activityId

TC_O2O_20881
     [Documentation]    [2C2P] Not allow to charge when Gateway_2c2p_credit_card_merchant_secret_key is invalid
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_MERCHANT_SECRET_KEY_INVALID}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_MERCHANT_SECRET_KEY_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_MERCHANT_SECRET_KEY_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    2_bad_request
     Response Should Contain Property With Value    errors..message    HashValue does not match.
     Response Should Contain Property With String Value    errors..activityId

TC_O2O_20882
     [Documentation]    [2C2P] Not allow to charge when Gateway_2c2p_credit_card_mid is empty
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_MERCHANT_SECRET_MID_EMPTY}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_MERCHANT_SECRET_MID_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_MERCHANT_SECRET_MID_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
     Response Should Contain Property With Value    errors..message    Merchant information is incomplete
     Response Should Not Contain Property    errors..activityId

TC_O2O_20883
     [Documentation]    [2C2P] Not allow to charge when Gateway_2c2p_credit_card_mid is invalid
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_MERCHANT_SECRET_MID_INVALID}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_MERCHANT_SECRET_MID_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_MERCHANT_SECRET_MID_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    2_bad_request
     Response Should Contain Property With Value    errors..message    HashValue does not match.
     Response Should Contain Property With String Value    errors..activityId

TC_O2O_20884
     [Documentation]    [2C2P] Not allow to charge when Gateway_2c2p_credit_card_status is inactive
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_INACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_INACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_INACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_not_active
     Response Should Contain Property With Value    errors..message    Merchant credit card is inactive
     Response Should Not Contain Property    errors..activityId

TC_O2O_20885
     [Documentation]    [2C2P] Not allow to charge when Gateway_2c2p_credit_card_status is Empty
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_NO_STATUS_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_NO_STATUS_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_NO_STATUS_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_not_active
     Response Should Contain Property With Value    errors..message    Merchant credit card is inactive
     Response Should Not Contain Property    errors..activityId

TC_O2O_17978
     [Documentation]    Not allow to charge when O2o_credit_card_public_key in CMS is invalid
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_O2O_PUBLICKEY_INVALID}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_O2O_PUBLICKEY_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_O2O_PUBLICKEY_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_signature_cannot_decrypt
     Response Should Contain Property With Value    errors..message    Signature cannot decrypt
     Response Should Not Contain Property    errors..activityId

TC_O2O_17980
     [Documentation]    Not allow to charge when O2o_credit_card_cipher_private_key in CMS is invalid
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_O2O_CIPHER_INVALID}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_O2O_CIPHER_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_O2O_CIPHER_INVALID}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_signature_cannot_decrypt
     Response Should Contain Property With Value    errors..message    Signature cannot decrypt
     Response Should Not Contain Property    errors..activityId

TC_O2O_17981
     [Documentation]    Not allow to charge when Scb_credit_card_merchant_name in CMS is empty
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_MERCHANT_NAME_EMPTY}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_NAME_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_NAME_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
     Response Should Contain Property With Value    errors..message    Merchant information is incomplete
     Response Should Not Contain Property    errors..activityId

TC_O2O_18215
     [Documentation]    Verify charge response when merchant name more than 50 charactor.
     [Tags]    Medium    Regression    Smoke    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_MERCHANT_NAME_EXTRA_LONG}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_NAME_EXTRA_LONG}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_NAME_EXTRA_LONG}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_name_length_over_limit
     Response Should Contain Property With Value    errors..message    Merchant name length must be less than 50
     Response Should Not Contain Property    errors..activityId

TC_O2O_18216
     [Documentation]    [SCB] Not allow to charge when merchant name is empty
     [Tags]    Medium    Regression    Smoke    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_MERCHANT_NAME_EMPTY}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_NAME_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_NAME_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
     Response Should Contain Property With Value    errors..message    Merchant information is incomplete
     Response Should Not Contain Property    errors..activityId

TC_O2O_22865
     [Documentation]    [2C2P] Allow to charge when merchant name is empty
     [Tags]    Medium    Regression    Smoke    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_OUTLET_MERCHANT_NAME_EMPTY}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_OUTLET_MERCHANT_NAME_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_OUTLET_MERCHANT_NAME_EMPTY}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    activityId
     Response Should Contain Property With Value    clientRefId    ${TRANSACTION_REFERENCE}
     Response Should Contain Property With Value    amount    ${amount}
     Response Should Contain Property With Value    currency    ${TH_CURRENCY}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Value    userDefine1    ${userDefine1}
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Value    userDefine3    ${userDefine3}
     Response Should Contain Property With String Value    createdDate
     Response Should Contain Property With String Value    lastModifiedDate
     Response Should Contain Property With String Value    transaction.transactionId
     Response Should Contain Property With Value    transaction.status    APPROVE
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${2C2P_OUTLET_MERCHANT_NAME_EMPTY}
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_18217
     [Documentation]    Verify charge response when merchant name has special charactors
     [Tags]    Medium    Regression    Smoke    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_OUTLET_MERCHANT_NAME_SPECIAL_CHAR}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_NAME_SPECIAL_CHAR}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_OUTLET_MERCHANT_NAME_SPECIAL_CHAR}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    activityId
     Response Should Contain Property With Value    clientRefId    ${TRANSACTION_REFERENCE}
     Response Should Contain Property With Value    amount    ${amount}
     Response Should Contain Property With Value    currency    ${TH_CURRENCY}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Value    userDefine1    ${userDefine1}
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Value    userDefine3    ${userDefine3}
     Response Should Contain Property With String Value    createdDate
     Response Should Contain Property With String Value    lastModifiedDate
     Response Should Contain Property With String Value    transaction.transactionId
     Response Should Contain Property With Value    transaction.status    APPROVE
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_OUTLET_MERCHANT_NAME_SPECIAL_CHAR}
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_18724
     [Documentation]    [SCB] Allow to charge with recurring type=INTERVAL
     [Tags]    Medium    Regression    Smoke    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    activityId
     Response Should Contain Property With Value    clientRefId    RECURRING-${TRANSACTION_REFERENCE}
     Response Should Contain Property With Value    amount    ${amount}
     Response Should Contain Property With Value    currency    ${TH_CURRENCY}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Value    userDefine1    ${userDefine1}
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Value    userDefine3    ${userDefine3}
     Response Should Contain Property With String Value    createdDate
     Response Should Contain Property With String Value    lastModifiedDate
     Response Should Contain Property With String Value    transaction.transactionId
     Response Should Contain Property With Value    transaction.status    APPROVE
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.recurringRefId
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Value    recurring.type    INTERVAL
     Response Should Contain Property With Value    recurring.interval.recurringInterval    10
     Response Should Contain Property With Value    recurring.interval.chargeNextDate    ${DESIRED_DATE}
     Response Should Not Contain Property    recurring.fixDate.chargeOnDate
     Response Should Contain Property With Value    recurring.recurringAmount    ${amount}
     Response Should Contain Property With Value    recurring.recurringCount    0
     Response Should Contain Property With Value    recurring.accumulateMaxAmount    ${amount}
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_20875
     [Documentation]    [2C2P] Allow to charge success with recurring type=INTERVAL
     [Tags]    Medium    Regression    Smoke    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${2C2P_ACTIVE_OUTLET}
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.recurringRefId
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Value    recurring.type    INTERVAL
     Response Should Contain Property With Value    recurring.interval.recurringInterval    10
     Response Should Contain Property With Value    recurring.interval.chargeNextDate    ${DESIRED_DATE}
     Response Should Not Contain Property    recurring.fixDate.chargeOnDate
     Response Should Contain Property With Value    recurring.recurringAmount    ${amount}
     Response Should Contain Property With Value    recurring.recurringCount    0
     Response Should Contain Property With Value    recurring.accumulateMaxAmount    ${amount}
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_18725
     [Documentation]    [SCB] Allow to charge with recurring type=FIXDATE
     [Tags]    Medium    Regression    Smoke    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    activityId
     Response Should Contain Property With Value    clientRefId    RECURRING-${TRANSACTION_REFERENCE}
     Response Should Contain Property With Value    amount    ${amount}
     Response Should Contain Property With Value    currency    ${TH_CURRENCY}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Value    userDefine1    ${userDefine1}
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Value    userDefine3    ${userDefine3}
     Response Should Contain Property With String Value    createdDate
     Response Should Contain Property With String Value    lastModifiedDate
     Response Should Contain Property With String Value    transaction.transactionId
     Response Should Contain Property With Value    transaction.status    APPROVE
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.recurringRefId
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Value    recurring.type    FIXDATE
     Response Should Not Contain Property    recurring.interval.recurringInterval
     Response Should Not Contain Property    recurring.interval.chargeNextDate
     Response Should Contain Property With Value    recurring.fixDate.chargeOnDate    ${DESIRED_DATE}
     Response Should Contain Property With Value    recurring.recurringAmount    ${amount}
     Response Should Contain Property With Value    recurring.recurringCount    0
     Response Should Contain Property With Value    recurring.accumulateMaxAmount    ${amount}
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_20876
     [Documentation]    [2C2P] Allow to charge success with recurring type=FIXDATE
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m    1 day
     Prepare The Encrypt Message With Recurring Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${2C2P_ACTIVE_OUTLET}
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.recurringRefId
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Value    recurring.type    FIXDATE
     Response Should Not Contain Property    recurring.interval.recurringInterval
     Response Should Not Contain Property    recurring.interval.chargeNextDate
     Response Should Contain Property With Value    recurring.fixDate.chargeOnDate    ${DESIRED_DATE}
     Response Should Contain Property With Value    recurring.recurringAmount    ${amount}
     Response Should Contain Property With Value    recurring.recurringCount    0
     Response Should Contain Property With Value    recurring.accumulateMaxAmount    ${amount}
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_18727
     [Documentation]    Not allow to charge when recurring type=INTERVAL and interval.recurringInterval is empty
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": "","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": "","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.interval.recurringInterval must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18728
     [Documentation]    Not allow to charge when recurring type=INTERVAL and interval.recurringInterval is null
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": null,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": null,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.interval.recurringInterval must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18729
     [Documentation]    Not allow to charge when recurring type=INTERVAL and interval.recurringInterval not in (1-365)
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 0,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 0,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    2_99
     Response Should Contain Property With Value    errors..message    Invalid Recurring Interval.
     Response Should Contain Property With String Value    errors..activityId

TC_O2O_18730
     [Documentation]    Not allow to charge when recurring type=INTERVAL and interval.recurringInterval is string
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": -10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": -10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    External Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.externalService
     Response Should Contain Property With Value    errors..code    2_99
     Response Should Contain Property With Value    errors..message    Invalid Recurring Interval.
     Response Should Contain Property With String Value    errors..activityId

TC_O2O_18731
     [Documentation]    Not allow to charge when recurring type=INTERVAL and interval.chargeNextDate is empty
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": ""},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": ""},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.interval.chargeNextDate must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18732
     [Documentation]    Not allow to charge when recurring type=INTERVAL and interval.chargeNextDate is null
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": null},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": null},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.interval.chargeNextDate must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18733
     [Documentation]    Not allow to charge when recurring type=INTERVAL and interval.chargeNextDate is invalid format
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval" : {"recurringInterval": "10","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval" : {"recurringInterval": "10","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "CHARGE WITH RECURRING","userDefine2": "chargeNextDate invalid format","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.interval.chargeNextDate is invalid
     Response Should Not Contain Property    errors..activityId

TC_O2O_18734
     [Documentation]    Allow to charge when recurring type=INTERVAL and interval.chargeNextDate is passed date
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    -1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval" : {"recurringInterval": "10","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval" : {"recurringInterval": "10","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "CHARGE WITH RECURRING","userDefine2": "chargeNextDate is pass date","userDefine3": "${userDefine3}"
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.recurringRefId
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Value    recurring.type    INTERVAL
     Response Should Contain Property With Value    recurring.interval.recurringInterval    10
     Response Should Contain Property With Value    recurring.interval.chargeNextDate    ${DESIRED_DATE}
     Response Should Not Contain Property    recurring.fixDate.chargeOnDate
     Response Should Contain Property With Value    recurring.recurringAmount    ${amount}
     Response Should Contain Property With Value    recurring.recurringCount    0
     Response Should Contain Property With Value    recurring.accumulateMaxAmount    ${amount}
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_18735
     [Documentation]    Not allow to charge when recurring type=INTERVAL and no value interval section
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.interval.chargeNextDate must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18736
     [Documentation]    Not allow to charge when recurring type=FIXDATE and fixDate.chargeOnDate is empty
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": ""},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": ""},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.fixDate.chargeOnDate must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18737
     [Documentation]    Not allow to charge when recurring type=FIXDATE and fixDate.chargeOnDate is null
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": null},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": null},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.fixDate.chargeOnDate must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18738
     [Documentation]    Not allow to charge when recurring type=FIXDATE and fixDate.chargeOnDate is invalid format
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.fixDate.chargeOnDate is invalid
     Response Should Not Contain Property    errors..activityId

TC_O2O_18739
     [Documentation]    Not allow to charge when recurring type=FIXDATE and no value fixDate section
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.fixDate.chargeOnDate must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18740
     [Documentation]    Not allow to charge when recurring type=FIXDATE and input passed date
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m    -1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    activityId
     Response Should Contain Property With Value    clientRefId    RECURRING-${TRANSACTION_REFERENCE}
     Response Should Contain Property With Value    amount    ${amount}
     Response Should Contain Property With Value    currency    ${TH_CURRENCY}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Value    userDefine1    ${userDefine1}
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Value    userDefine3    ${userDefine3}
     Response Should Contain Property With String Value    createdDate
     Response Should Contain Property With String Value    lastModifiedDate
     Response Should Contain Property With String Value    transaction.transactionId
     Response Should Contain Property With Value    transaction.status    APPROVE
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.recurringRefId
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Value    recurring.type    FIXDATE
     Response Should Not Contain Property    recurring.interval.recurringInterval
     Response Should Not Contain Property    recurring.interval.chargeNextDate
     Response Should Contain Property With Value    recurring.fixDate.chargeOnDate    ${DESIRED_DATE}
     Response Should Contain Property With Value    recurring.recurringAmount    ${amount}
     Response Should Contain Property With Value    recurring.recurringCount    0
     Response Should Contain Property With Value    recurring.accumulateMaxAmount    ${amount}
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_18741
     [Documentation]    Not allow to charge when recurringAmount is empty
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property Value Include In List    errors..message    ${validate_recurring_amount_empty}
     Response Should Not Contain Property    errors..activityId

TC_O2O_18742
     [Documentation]    Not allow to charge when recurringAmount is null
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": null,"recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": null,"recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.recurringAmount must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18743
     [Documentation]    Not allow to charge when recurringAmount is string
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "20.20","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "20.20","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.recurringAmount is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_18744
     [Documentation]    Not allow to charge when recurringCount is empty
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property Value Include In List    errors..message    ${validate_recurring_count_empty}
     Response Should Not Contain Property    errors..activityId

TC_O2O_18745
     [Documentation]    Not allow to charge when recurringCount is null
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": null,"accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": null,"accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.recurringCount must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18746
     [Documentation]    Not allow to charge when recurringCount is string
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "-1","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "-1","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.recurringCount is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_18747
     [Documentation]    Not allow to charge when accumulateMaxAmount is empty
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": ""}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": ""},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property Value Include In List    errors..message    ${validate_recurring_accum_amount_empty}
     Response Should Not Contain Property    errors..activityId

TC_O2O_18748
     [Documentation]    Not allow to charge when accumulateMaxAmount is null
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": null}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": null},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.accumulateMaxAmount must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18749
     [Documentation]    Not allow to charge when accumulateMaxAmount is string
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "-${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "-${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.accumulateMaxAmount is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_18759
     [Documentation]    Not allow to charge when recurring.type is empty
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.type must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18760
     [Documentation]    Not allow to charge when recurring.type is null
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": null,"interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.type must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18761
     [Documentation]    Not allow to charge when recurring.type is not in INTERVAL or FIXDATE
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "IPP","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.type is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_18762
     [Documentation]    recurring.type is not support lower case
     [Tags]    Medium    Regression    Smoke    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "interval","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.type is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_18763
     [Documentation]    Not allow to charge when recurring type=INTERVAL and input interval.chargeNextDate to empty string
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m%y%y    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": ""},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": ""},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.interval.chargeNextDate must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_18764
     [Documentation]    Not allow to charge when recurring type=FIXDATE and input fixDate.chargeOnDate to empty string
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Get Date With Format And Increment    %d%m    1 day
     Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": ""},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
     Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": ""},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    recurring.fixDate.chargeOnDate must not be empty
     Response Should Not Contain Property    errors..activityId

TC_O2O_20872
     [Documentation]    [SCB] Allow to charge with installment plan when credit_card_gateway =SCB and interestType =MERCHANT
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Installment Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "MERCHANT"}
     Post Payment Charge By Credit Card With Installment Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "MERCHANT"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    activityId
     Response Should Contain Property With Value    clientRefId    IPP-${TRANSACTION_REFERENCE}
     Response Should Contain Property With Value    amount    500000
     Response Should Contain Property With Value    currency    ${TH_CURRENCY}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Value    userDefine1    ${userDefine1}
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Value    userDefine3    ${userDefine3}
     Response Should Contain Property With String Value    createdDate
     Response Should Contain Property With String Value    lastModifiedDate
     Response Should Contain Property With String Value    transaction.transactionId
     Response Should Contain Property With Value    transaction.status    APPROVE
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
     Response Should Not Contain Property    transaction.'trueyouTerminalId'
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Value    installment.period    ${4}
     Response Should Contain Property With Value    installment.interestType    MERCHANT
     Response Should Contain Property With String Value    installment.ippInterestRate
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_20877
     [Documentation]    [2C2P] Allow to charge with installment plan when credit_card_gateway =2C2P and interestType =MERCHANT
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "MERCHANT"}
     Post Payment Charge By Credit Card With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "MERCHANT"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${2C2P_MERCHANT_ID}
     Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${2C2P_ACTIVE_OUTLET}
     Response Should Not Contain Property    transaction.'trueyouTerminalId'
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
     Response Should Contain Property With String Value    transaction.createdDate
     Response Should Contain Property With String Value    transaction.lastModifiedDate
     Response Should Contain Property With Value    installment.period    ${4}
     Response Should Contain Property With Value    installment.interestType    MERCHANT
     Response Should Contain Property With String Value    installment.ippInterestRate
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_20873
     [Documentation]    [SCB] Allow to charge with installment plan when credit_card_gateway =SCB and interestType =CUSTOMER
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Installment Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "CUSTOMER"}
     Post Payment Charge By Credit Card With Installment Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "CUSTOMER"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    installment.period    ${4}
     Response Should Contain Property With Value    installment.interestType    CUSTOMER
     Response Should Contain Property With String Value    installment.ippInterestRate
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_20878
     [Documentation]    [2C2P] Allow to charge with installment plan when credit_card_gateway =2C2P and interestType =CUSTOMER
     [Tags]    Medium    Regression    UnitTest    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "CUSTOMER"}
     Post Payment Charge By Credit Card With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "CUSTOMER"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    installment.period    ${4}
     Response Should Contain Property With Value    installment.interestType    CUSTOMER
     Response Should Contain Property With String Value    installment.ippInterestRate
     Response Should Contain Property With Null Value    wpCardId

TC_O2O_20890
     [Documentation]    Not allow to charge when interestType =merchant (lower case)
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "merchant"}
     Post Payment Charge By Credit Card With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "merchant"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    installment.interestType is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_20891
     [Documentation]    Not allow to charge when interestType =customer (lower case)
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "customer"}
     Post Payment Charge By Credit Card With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "customer"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    installment.interestType is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_20892
     [Documentation]    Not allow to charge when installment period message unmatch the KMS encrypt message
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "6","interestType": "CUSTOMER"}
     Post Payment Charge By Credit Card With Installment Plan    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    500000    "installment": {"period": "4","interestType": "CUSTOMER"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/charge
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_signature_invalid
     Response Should Contain Property With Value    errors..message    Signature is invalid
     Response Should Not Contain Property    errors..activityId

TC_O2O_22312
     [Documentation]    [SCB] Not save card info when charge with store flag
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","clientUsername" : "AUTOMATE-001","rememberCard" : true,"email" : "QA.AUTOMATE@ascendcorp.com"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","clientUsername" : "AUTOMATE-001","rememberCard" : true,"email" : "QA.AUTOMATE@ascendcorp.com","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Value    transaction.gatewayType    2C2P
     Response Should Contain Property With Null Value    userDefine1
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Value    userDefine3    ${userDefine3}

TC_O2O_22313
     [Documentation]    [2C2P] Not save card info when charge with store flag
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    ${external_ref_id_length}
     Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
     Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    status    SUCCESS
     Response Should Contain Property With Value    statusDescription    SUCCESS
     Response Should Contain Property With Null Value    userDefine1
     Response Should Contain Property With Value    userDefine2    ${userDefine2}
     Response Should Contain Property With Value    userDefine3    ${userDefine3}
