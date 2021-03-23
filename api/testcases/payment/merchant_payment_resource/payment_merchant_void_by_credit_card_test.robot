*** Settings ***
Documentation    Tests to verify 2C2P VOID API by credit card
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_creditcard
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.void

*** Variables ***
${maximum_random_txref}    10

*** Test Cases ***
TC_O2O_17209
    [Documentation]    Not allow to void when access has invalid client scope
    [Tags]    Low    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_admin
    Prepare The Charge Transaction
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","userDefine1": "regression void","userDefine2": "automation script","userDefine3": "note"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/void
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_17212
     [Documentation]    Not allow to void when invalid charge transaction_id
     [Tags]    Low    Regression    payment
     Generate Transaction Reference    ${maximum_random_txref}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"invalid_transaction_id","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
     Post Payment Void By Credit Card    invalid_transaction_id     {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","userDefine1": "regression void","userDefine2": "automation script","userDefine3": "note"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/invalid_transaction_id/void
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_transaction_not_found
     Response Should Contain Property With Value    errors..message    Transaction Not Found

TC_O2O_17213
    [Documentation]    Allow to void when valid charge_transaction_id and all information is valid
    [Tags]    Medium    Regression    Smoke    payment
    Prepare The Charge Transaction
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","userDefine1": "regression void","userDefine2": "automation script","userDefine3": "note"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    1400
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    regression void
    Response Should Contain Property With Value    userDefine2    automation script
    Response Should Contain Property With Value    userDefine3    note
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    VOID
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_17214
     [Documentation]    Not allow to void when clientRefId is dupplicate in the same merchant and outlet
     [Tags]    Medium    Regression    Smoke    payment
     Prepare The Charge Transaction
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "DuplicateCL001"}
     Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "DuplicateCL001","userDefine1": "regression void","userDefine2": "automation script","userDefine3": "note"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/void
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_duplicate_transaction
     Response Should Contain Property With Value    errors..message    Duplicate External Transaction

TC_O2O_17216
     [Documentation]    Not allow to void when the transaction already void
     [Tags]    Medium    Regression    payment
     Prepare The Charge Transaction
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID1-${TRANSACTION_REFERENCE}"}
     Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "VOID1-${TRANSACTION_REFERENCE}","userDefine1": "regression void","userDefine2": "automation script","userDefine3": "note"}
     Response Correct Code    ${SUCCESS_CODE}
     Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID2-${TRANSACTION_REFERENCE}"}
     Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "VOID2-${TRANSACTION_REFERENCE}","userDefine1": "regression void","userDefine2": "automation script","userDefine3": "note"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Internal Bad Request
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/void
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_transaction_already_void
     Response Should Contain Property With Value    errors..message    Transaction is already void

TC_O2O_17225
      [Documentation]    Not allow to VOID when input HTML tag in userDefine 1
      [Tags]    Low    Regression    payment
      Prepare The Charge Transaction
      Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
      Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","userDefine1": "pentest </div>","userDefine2": "automation script","userDefine3": "note"}
      Response Correct Code    ${BAD_REQUEST_CODE}
      Response Should Contain Property With Value    type    ${API_HOST}/payment
      Response Should Contain Property With Value    title    Method argument not valid
      Response Should Contain Property With Value    status    ${400}
      Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/void
      Response Should Contain Property With Value    message    error.validation
      Response Should Contain Property With Value    errors..code    0_request_validation
      Response Should Contain Property With Value    errors..message    userDefine1 The HTML tag are not allowed

TC_O2O_17226
      [Documentation]    Not allow to VOID when input HTML tag in userDefine 2
      [Tags]    Low    Regression    payment
      Prepare The Charge Transaction
      Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
      Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","userDefine1": "automation script","userDefine2": "pentest </div>","userDefine3": "note"}
      Response Correct Code    ${BAD_REQUEST_CODE}
      Response Should Contain Property With Value    type    ${API_HOST}/payment
      Response Should Contain Property With Value    title    Method argument not valid
      Response Should Contain Property With Value    status    ${400}
      Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/void
      Response Should Contain Property With Value    message    error.validation
      Response Should Contain Property With Value    errors..code    0_request_validation
      Response Should Contain Property With Value    errors..message    userDefine2 The HTML tag are not allowed

TC_O2O_17227
      [Documentation]    Not allow to VOID when input HTML tag in userDefine 3
      [Tags]    Low    Regression    payment
      Prepare The Charge Transaction
      Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
      Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","userDefine1": "automation script","userDefine2": "automation script","userDefine3": "pentest </div>"}
      Response Correct Code    ${BAD_REQUEST_CODE}
      Response Should Contain Property With Value    type    ${API_HOST}/payment
      Response Should Contain Property With Value    title    Method argument not valid
      Response Should Contain Property With Value    status    ${400}
      Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/void
      Response Should Contain Property With Value    message    error.validation
      Response Should Contain Property With Value    errors..code    0_request_validation
      Response Should Contain Property With Value    errors..message    userDefine3 The HTML tag are not allowed
