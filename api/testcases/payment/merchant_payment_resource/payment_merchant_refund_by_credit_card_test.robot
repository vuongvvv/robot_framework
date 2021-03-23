*** Settings ***
Documentation    Tests to verify 2C2P payment API Refund
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.refund

*** Variables ***
${external_ref_id_length}    10
@{validation_html_tag}    userDefine1 The HTML tag are not allowed    userDefine2 The HTML tag are not allowed    userDefine3 The HTML tag are not allowed

*** Test Cases ***
TC_O2O_17277
    [Documentation]    Not allow to Refund when access client with invalid client scope
    [Tags]    Low    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Prepare The Settled Transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": ${FULL_AMOUNT}}
    Post Payment Refund By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": ${FULL_AMOUNT},"userDefine1": "automate script","userDefine2": "refund api","userDefine3": "note!"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_17280
    [Documentation]    Not allow to Refund when invalid transaction_id
    [Tags]    Low    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"trxn_invalid","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 100}
    Post Payment Refund By Credit Card    trxn_invalid    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 100,"userDefine1": "automate script","userDefine2": "refund api","userDefine3": "note!"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/trxn_invalid/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_found
    Response Should Contain Property With Value    errors..message    Transaction Not Found

TC_O2O_17281
    [Documentation]    Allow to refund with full amount
    [Tags]    Medium    Regression    Smoke    payment
    Prepare The Settled Transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": ${FULL_AMOUNT}}
    Post Payment Refund By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": ${FULL_AMOUNT},"userDefine1": "automate script","userDefine2": "refund api","userDefine3": "note!"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REFUND-${TRANSACTION_REFERENCE}
    Response Should Contain All Property Values Are Number    amount
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    automate script
    Response Should Contain Property With Value    userDefine2    refund api
    Response Should Contain Property With Value    userDefine3    note!
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    REFUND
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_17282
    [Documentation]    Allow to refund with partial amount
    [Tags]    Medium    Regression    Smoke    payment
    Prepare The Settled Transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 100}
    Post Payment Refund By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 100}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REFUND-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    100
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Null Value    userDefine1
    Response Should Contain Property With Null Value    userDefine2
    Response Should Contain Property With Null Value    userDefine3
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    REFUND
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_17283
    [Documentation]    Not allow to refund when dupplicate clientRefId
    [Tags]    Medium    Regression    payment
    Prepare The Settled Transaction
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "DuplicateCL001","amount": ${FULL_AMOUNT}}
    Post Payment Refund By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "DuplicateCL001","amount": ${FULL_AMOUNT},"userDefine1": "automate script","userDefine2": "refund api","userDefine3": "note!"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_duplicate_transaction
    Response Should Contain Property With Value    errors..message    Duplicate External Transaction

TC_O2O_17284
    [Documentation]    Not allow to Refund when the transaction already void
    [Tags]    Medium    Regression    payment
    Prepare The Charge Transaction
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","userDefine1": "automate script","userDefine2": "void api","userDefine3": "note!"}
    Response Correct Code    ${SUCCESS_CODE}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 100}
    Post Payment Refund By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 100,"userDefine1": "automate script","userDefine2": "refund api","userDefine3": "note!"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_refund
    Response Should Contain Property With Value    errors..message    VOID - Transaction is not allowed to refund

TC_O2O_17289
    [Documentation]    Not allow to refund when refund amount is overcharge balance
    [Tags]    Medium    Regression    Smoke    payment
    Prepare The Settled Transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 10000000}
    Post Payment Refund By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 10000000,"userDefine1": "automate script","userDefine2": "refund api","userDefine3": "note!"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_over_remaining_amount
    Response Should Contain Property With Value    errors..message    Refund amount is over remaining amount

TC_O2O_17291
    [Documentation]    Not allow to refund when input HTML tag in userDefine 1 2 and 3
    [Tags]    Medium    Regression    payment
    Prepare The Settled Transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": ${FULL_AMOUNT}}
    Post Payment Refund By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": ${FULL_AMOUNT},"userDefine1": "</div>automate script","userDefine2": "</div>refund api","userDefine3": "</div>note!"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property Value Include In List    errors..message    ${validation_html_tag}

TC_O2O_17293
    [Documentation]    Not allow to refund when amout is null
    [Tags]    Low    Regression    payment
    Prepare The Settled Transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": null}
    Post Payment Refund By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": null,"userDefine1": "automate script","userDefine2": "refund api","userDefine3": "note!"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    amount must not be empty

TC_O2O_17294
    [Documentation]    Not allow to refund when amout is invalid format
    [Tags]    Low    Regression    payment
    Prepare The Settled Transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 100.50}
    Post Payment Refund By Credit Card    ${TRANSACTION_ID}    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": 100.50,"userDefine1": "automate script","userDefine2": "refund api","userDefine3": "note!"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    amount is invalid.
