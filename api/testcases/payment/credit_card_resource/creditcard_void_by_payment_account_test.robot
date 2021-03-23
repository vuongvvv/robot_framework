*** Settings ***
Documentation    Tests to verify API for Void From Omise

Resource    ../../../../web/resources/init.robot
Resource    ../../../../web/keywords/payment/credit_card_resource_keywords.robot
Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/payment/credit_card_resource/creditcard_capture_charge_by_payment_account_keywords.robot
Resource    ../../../keywords/payment/credit_card_resource/creditcard_void_by_payment_account_keywords.robot
Test Setup    Run Keywords    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment    AND    Switch To Non Angular JS Site
Test Teardown     Run Keywords    Delete All Sessions    AND    Switch To Angular JS Site
#Require Wepayment_Client Scope: payment.payment.list, payment.creditCard.void

*** Variables ***
${external_ref_id_length}    15
${userDefine1}    AUTOMATION TEST SCRIPT
${userDefine2}    DEFINE BY STORM TEAM
${userDefine3}    VALIDATION: REGRESSION OMISE CREDIT CARD VOID

*** Test Cases ***
TC_O2O_25683
   [Documentation]    [Client][Omise] Allow to void with metadata and userDefine case all information are valid
   [Tags]    Medium    Regression    payment
   Generate Transaction Reference    ${external_ref_id_length}
   Prepare Omise The Charge Transaction Type 3D Secure    ${TRANSACTION_REFERENCE}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}", "userDefine1" : "${userDefine1}", "userDefine2" : "${userDefine2}", "userDefine3" : "${userDefine3}", "metadata": {"BFF-VOID": "VOID-${TRANSACTION_REFERENCE}","BFF-REMARK": "AUTOMATION"} }
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With String Value    activityId
   Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
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
   Response Should Contain Property With Value    transaction.status    VOID
   Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
   Response Should Contain Property With Value    transaction.gatewayType    OMISE
   Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
   Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX4444
   Response Should Contain Property With String Value    transaction.createdDate
   Response Should Contain Property With String Value    transaction.lastModifiedDate
   Response Should Contain Property With Null Value    wpCardId
   Response Should Contain Property With Null Value    recurringSequenceNo

TC_O2O_25684
   [Documentation]    [Client][Omise] Allow to void with userDefine case no metadata and all information are valid
   [Tags]    Medium    Regression    payment
   Generate Transaction Reference    ${external_ref_id_length}
   Prepare Omise The Charge Transaction Type 3D Secure    ${TRANSACTION_REFERENCE}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}", "userDefine1" : "${userDefine1}", "userDefine2" : "${userDefine2}", "userDefine3" : "${userDefine3}"}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With String Value    activityId
   Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
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
   Response Should Contain Property With Value    transaction.status    VOID
   Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
   Response Should Contain Property With Value    transaction.gatewayType    OMISE
   Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
   Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX4444
   Response Should Contain Property With String Value    transaction.createdDate
   Response Should Contain Property With String Value    transaction.lastModifiedDate
   Response Should Contain Property With Null Value    wpCardId
   Response Should Contain Property With Null Value    recurringSequenceNo

TC_O2O_25685
   [Documentation]    [Client][Omise] Allow to void case no metadata and userDefine and all information are valid
   [Tags]    Medium    Regression    payment
   Generate Transaction Reference    ${external_ref_id_length}
   Prepare Omise The Charge Transaction Type 3D Secure    ${TRANSACTION_REFERENCE}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With String Value    activityId
   Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
   Response Should Contain Property With Value    amount    ${amount}
   Response Should Contain Property With Value    currency    ${TH_CURRENCY}
   Response Should Contain Property With Value    status    SUCCESS
   Response Should Contain Property With Value    statusDescription    SUCCESS
   Response Should Contain Property With Null Value    userDefine1
   Response Should Contain Property With Null Value    userDefine2
   Response Should Contain Property With Null Value    userDefine3
   Response Should Contain Property With String Value    createdDate
   Response Should Contain Property With String Value    lastModifiedDate
   Response Should Contain Property With String Value    transaction.transactionId
   Response Should Contain Property With Value    transaction.status    VOID
   Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
   Response Should Contain Property With Value    transaction.gatewayType    OMISE
   Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
   Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX4444
   Response Should Contain Property With String Value    transaction.createdDate
   Response Should Contain Property With String Value    transaction.lastModifiedDate
   Response Should Contain Property With Null Value    wpCardId
   Response Should Contain Property With Null Value    recurringSequenceNo

TC_O2O_25686
   [Documentation]    [Client][Omise] Allow to void with metadata case no userDefine and all information are valid
   [Tags]    Medium    Regression    payment
   # Step 1: Find charge transaction whose Status = APPROVE step
   Search Payment Transaction By Status    APPROVE
   # Step 2: Send request to do the credit card void in OMISE
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}","metadata": {"paymentInfoArray": [{"shop_code": "RF","ref3": "${CHARGE_CLIENT_REF}"}]}}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With String Value    activityId
   Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
   Response Should Contain Property With Value    status    SUCCESS
   Response Should Contain Property With Value    statusDescription    SUCCESS
   Response Should Contain Property With Null Value    userDefine1
   Response Should Contain Property With Null Value    userDefine2
   Response Should Contain Property With Null Value    userDefine3
   Response Should Contain Property With Value    transaction.status    VOID

TC_O2O_25735
   [Documentation]    [client_scope] not allow to void when app_client scope not found
   [Tags]    Medium    Regression    payment
   # Step 1: Find charge transaction whose pending capture step
   Search Payment Transaction By Status    APPROVE
   # Step 2: Send request to do the manual capture in OMISE
   Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${FORBIDDEN_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    payment.internal.forbidden
   Response Should Contain Property With Value    status    ${403}
   Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/void
   Response Should Contain Property With Value    message    error.forbidden
   Response Should Contain Property With Value    errors..code    0_access_is_denied
   Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_25736
   [Documentation]    [merchant authority] not allow to void when no permission for payment account
   [Tags]    Medium    Regression    payment
   # Step 1: Find charge transaction whose pending capture step
   Search Payment Transaction By Status    APPROVE
   # Step 2: Send request to do the manual capture in OMISE
   Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${FORBIDDEN_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    payment.internal.forbidden
   Response Should Contain Property With Value    status    ${403}
   Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/void
   Response Should Contain Property With Value    message    error.forbidden
   Response Should Contain Property With Value    errors..code    0_access_is_denied
   Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_25739
   [Documentation]    not allow to void when transaction not found
   [Tags]    Medium    Regression    payment
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"txrn_id_not_found","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    txrn_id_not_found    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/txrn_id_not_found/void
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code    0_transaction_not_found
   Response Should Contain Property With Value    errors..message    Transaction Not Found

TC_O2O_25744
   [Documentation]    Not allow to void when charge transaction status is FAIL
   [Tags]    Medium    Regression    payment
   # Step 1: Find charge transaction whose pending capture step
   Search Payment Transaction By Status    FAIL
   # Step 2: Send request to do the manual capture in OMISE
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/void
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_void
   Response Should Contain Property With Value    errors..message    FAIL - Transaction is not allowed to void

TC_O2O_25745
   [Documentation]    Not allow to void when charge transaction status is PENDING
   [Tags]    Medium    Regression    payment
   # Step 1: Find charge transaction whose pending capture step
   Search Payment Transaction By Status    PENDING
   # Step 2: Send request to do the manual capture in OMISE
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/void
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_void
   Response Should Contain Property With Value    errors..message    PENDING - Transaction is not allowed to void

TC_O2O_25746
   [Documentation]    Not allow to void when charge transaction status is AUTHORIZED
   [Tags]    Medium    Regression    payment
   # Step 1: Find charge transaction whose pending capture step
   Search Payment Transaction By Status    AUTHORIZED
   # Step 2: Send request to do the manual capture in OMISE
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/void
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_void
   Response Should Contain Property With Value    errors..message    AUTHORIZED - Transaction is not allowed to void

TC_O2O_25747
   [Documentation]    Not allow to void when charge transaction status is SETTLED
   [Tags]    Medium    Regression    payment
   # Step 1: Find charge transaction whose pending capture step
   Search Payment Transaction By Status    SETTLED
   # Step 2: Send request to do the manual capture in OMISE
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/void
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_void
   Response Should Contain Property With Value    errors..message    SETTLED - Transaction is not allowed to void

TC_O2O_25748
   [Documentation]    Not allow to void when charge transaction status is VOID
   [Tags]    Medium    Regression    payment
   # Step 1: Find charge transaction whose pending capture step
   Search Payment Transaction By Status    VOID
   # Step 2: Send request to do the manual capture in OMISE
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/void
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code    0_transaction_already_void
   Response Should Contain Property With Value    errors..message    Transaction is already void

TC_O2O_25749
   [Documentation]    Not allow to void when charge transaction status is REFUND
   [Tags]    Medium    Regression    payment
   # Step 1: Find charge transaction whose pending capture step
   Search Payment Transaction By Status    REFUND
   # Step 2: Send request to do the manual capture in OMISE
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Post Payment Void By Payment Account    ${TRANSACTION_ID}    { "clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/void
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_void
   Response Should Contain Property With Value    errors..message    REFUND - Transaction is not allowed to void
