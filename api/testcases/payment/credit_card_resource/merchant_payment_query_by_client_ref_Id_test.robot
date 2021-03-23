*** Settings ***
Documentation    Tests to verify API for Merchant Payment Query by ClientRefId
Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/payment/credit_card_resource/creditcard_charge_by_payment_account_keywords.robot
Resource    ../../../keywords/payment/credit_card_resource/merchant_payment_query_by_client_ref_id_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
Test Teardown     Delete All Sessions
#Require Wepayment_Client Scope: payment.creditCard.read

*** Variables ***
${client_ref_id}    CHARGE-DUPP0001
${external_ref_id_length}    15
@{error_validate_params}    paymentAccountId must not be empty    clientRefId must not be empty

*** Test Cases ***
TC_O2O_25358
   [Documentation]    [query activity][client_scope] Verify response when app_client scope not found
   [Tags]    Medium    Regression    payment
   [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
   Get Merchant Payment Query By ClientRefId    clientRefId=${client_ref_id}&paymentAccountId=${VALID_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${FORBIDDEN_CODE}
   Response Should Contain Property With Value    type    https://alpha-gateway.weomni-test.com/payment
   Response Should Contain Property With Value    title    payment.internal.forbidden
   Response Should Contain Property With Value    status    ${403}
   Response Should Contain Property With Value    path    /api/v1/credit-card/query-activity
   Response Should Contain Property With Value    message    error.forbidden
   Response Should Contain Property With Value    errors.[0].code    0_access_is_denied
   Response Should Contain Property With Value    errors.[0].message    Access is denied

TC_O2O_25359
   [Documentation]    [query activity][merchant_authorized] Verify response when no merchant authorized
   [Tags]    Medium    Regression    payment
   [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
   Get Merchant Payment Query By ClientRefId    clientRefId=${client_ref_id}&paymentAccountId=${VALID_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${FORBIDDEN_CODE}
   Response Should Contain Property With Value    type    https://alpha-gateway.weomni-test.com/payment
   Response Should Contain Property With Value    title    payment.internal.forbidden
   Response Should Contain Property With Value    status    ${403}
   Response Should Contain Property With Value    path    /api/v1/credit-card/query-activity
   Response Should Contain Property With Value    message    error.forbidden
   Response Should Contain Property With Value    errors.[0].code    0_access_is_denied
   Response Should Contain Property With Value    errors.[0].message    Access is denied

TC_O2O_25362
   [Documentation]    [query activity] Verify response when no clientRefId and paymentAccountId in param
   [Tags]    Medium    Regression    payment
   Get Merchant Payment Query By ClientRefId
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
   Response Should Contain Property With Value    title    Constraint Violation
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/query-activity
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code    0_request_validation
   Response Should Contain Property Value Include In List    errors..message    ${error_validate_params}

TC_O2O_25363
   [Documentation]    [query activity] Verify response when payment account not found
   [Tags]    Medium    Regression    payment
   Get Merchant Payment Query By ClientRefId    clientRefId=${client_ref_id}&paymentAccountId=INVALID
   Response Correct Code    ${NOT_FOUND_CODE}
   Response Should Contain Property With Value    type    https://alpha-gateway.weomni-test.com/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${404}
   Response Should Contain Property With Value    path    /api/v1/credit-card/query-activity
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors.[0].code    0_activity_not_found
   Response Should Contain Property With Value    errors.[0].message    Activity Not Found

TC_O2O_25364
   [Documentation]    [query activity] Verify response when clientRefId not found
   [Tags]    Medium    Regression    payment
   Get Merchant Payment Query By ClientRefId    clientRefId=INVALID&paymentAccountId=${VALID_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${NOT_FOUND_CODE}
   Response Should Contain Property With Value    type    https://alpha-gateway.weomni-test.com/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${404}
   Response Should Contain Property With Value    path    /api/v1/credit-card/query-activity
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors.[0].code    0_activity_not_found
   Response Should Contain Property With Value    errors.[0].message    Activity Not Found

TC_O2O_25365
   [Documentation]    [query activity] Verify response when clientRefId and payment account didn't match
   [Tags]    Medium    Regression    payment
   Get Merchant Payment Query By ClientRefId    clientRefId=${client_ref_id}&paymentAccountId=${PID_FOR_ACCESS_CONTROL}
   Response Correct Code    ${NOT_FOUND_CODE}
   Response Should Contain Property With Value    type    https://alpha-gateway.weomni-test.com/payment
   Response Should Contain Property With Value    title    Internal Bad Request
   Response Should Contain Property With Value    status    ${404}
   Response Should Contain Property With Value    path    /api/v1/credit-card/query-activity
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors.[0].code    0_activity_not_found
   Response Should Contain Property With Value    errors.[0].message    Activity Not Found

TC_O2O_25366
   [Documentation]    [query activity] Verify response when query with charge fail transaction case no installment
   [Tags]    Medium    Regression    payment
   #Preparations step: START
   Generate Transaction Reference    ${external_ref_id_length}
   Generate Omise Payment Token    ${insufficient_fund_visa_card}
   Prepare Encryption Message Before Charge With Omise Gateway
   ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"returnUrl": null,"amount": 100000,"currency": "${TH_CURRENCY}"
   Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Fetch Property From Response    .errors..activityId    ACTIVITY_ID
   #EPreparations step: END
   Get Merchant Payment Query By ClientRefId    clientRefId=PREPARE-${TRANSACTION_REFERENCE}&paymentAccountId=${VALID_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
   Response Should Contain Property With Value    clientRefId    PREPARE-${TRANSACTION_REFERENCE}
   Response Should Contain Property With Value    amount    100000
   Response Should Contain Property With Value    currency    THB
   Response Should Contain Property With Value    status    FAIL
   Response Should Contain Property With Value    statusDescription    insufficient_fund:insufficient funds in the account or the card has reached the credit limit
   Response Should Contain Property With Null Value    userDefine1
   Response Should Contain Property With Null Value    userDefine2
   Response Should Contain Property With Null Value    userDefine3
   Response Should Contain Property With String Value    createdDate
   Response Should Contain Property With String Value    lastModifiedDate
   Response Should Contain Property With String Value    transaction.transactionId
   Response Should Contain Property With Value    transaction.status    FAIL
   Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
   Response Should Contain Property With Value    transaction.gatewayType    OMISE
   Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
   Response Should Contain Property With String Value    transaction.createdDate
   Response Should Contain Property With String Value    transaction.lastModifiedDate
   Response Should Contain Property With Null Value    wpCardId
   Response Should Contain Property With Null Value    recurringSequenceNo
   Response Should Contain Property With Value    activityReference..activityId    ${ACTIVITY_ID}
   Response Should Contain Property With Value    activityReference..clientRefId    PREPARE-${TRANSACTION_REFERENCE}
   Response Should Contain Property With Value    activityReference..amount    100000
   Response Should Contain Property With Value    activityReference..currency    THB
   Response Should Contain Property With Value    activityReference..action    CHARGE
   Response Should Contain Property With Value    activityReference..status    FAIL
   Response Should Contain Property With Value    activityReference..statusDescription    insufficient_fund:insufficient funds in the account or the card has reached the credit limit
   Response Should Contain Property With Null Value    activityReference..userDefine1
   Response Should Contain Property With Null Value    activityReference..userDefine2
   Response Should Contain Property With Null Value    activityReference..userDefine3
   Response Should Contain Property With String Value    activityReference..createdDate
   Response Should Contain Property With String Value    activityReference..lastModifiedDate

TC_O2O_25367
   [Documentation]    [query activity] Verify response when query with charge transaction with installment plan
   [Tags]    Medium    Regression    Smoke    payment
   #Preparations step: START
   Generate Transaction Reference    ${external_ref_id_length}
   Post Encrypt Message With KMS For Omise
   ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "3900000","currency": "${TH_CURRENCY}","installment": {"period": "10","interestType": "MERCHANT","providerName":"KTC"}}
   Post Payment Charge With Credit Card By Payment Account
   ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "3900000","currency": "${TH_CURRENCY}","installment": {"period": "10","interestType": "MERCHANT","providerName":"KTC"},"userDefine1": "PREPARE TEST DATA BY AUTOMATE SCRIPT","userDefine2": "GENERATE BY QA-STORM TEAM","userDefine3": "NOTE"}
   Response Correct Code    ${SUCCESS_CODE}
   Fetch Property From Response    .activityId    ACTIVITY_ID
   #EPreparations step: END
   Get Merchant Payment Query By ClientRefId    clientRefId=PREPARE-${TRANSACTION_REFERENCE}&paymentAccountId=${VALID_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
   Response Should Contain Property With Value    clientRefId    PREPARE-${TRANSACTION_REFERENCE}
   Response Should Contain Property With Value    amount    3900000
   Response Should Contain Property With Value    currency    THB
   Response Should Contain Property With Value    status    SUCCESS
   Response Should Contain Property With Value    statusDescription    SUCCESS
   Response Should Contain Property With Value    userDefine1    PREPARE TEST DATA BY AUTOMATE SCRIPT
   Response Should Contain Property With Value    userDefine2    GENERATE BY QA-STORM TEAM
   Response Should Contain Property With Value    userDefine3    NOTE
   Response Should Contain Property With String Value    createdDate
   Response Should Contain Property With String Value    lastModifiedDate
   Response Should Contain Property With String Value    transaction.transactionId
   Response Should Contain Property With Value    transaction.status    PENDING
   Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
   Response Should Contain Property With Value    transaction.gatewayType    OMISE
   Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
   Response Should Contain Property With String Value    transaction.createdDate
   Response Should Contain Property With String Value    transaction.lastModifiedDate
   Response Should Contain Property With Null Value    wpCardId
   Response Should Contain Property With Null Value    recurringSequenceNo
   Response Should Contain Property With Value    installment.period    ${10}
   Response Should Contain Property With Value    installment.interestType    MERCHANT
   Response Should Contain Property With Value    installment.providerName    KTC
   Response Should Contain Property With Value    activityReference..activityId    ${ACTIVITY_ID}
   Response Should Contain Property With Value    activityReference..clientRefId    PREPARE-${TRANSACTION_REFERENCE}
   Response Should Contain Property With Value    activityReference..amount    3900000
   Response Should Contain Property With Value    activityReference..currency    THB
   Response Should Contain Property With Value    activityReference..action    CREATE_CHARGE
   Response Should Contain Property With Value    activityReference..status    SUCCESS
   Response Should Contain Property With Value    activityReference..statusDescription    SUCCESS
   Response Should Contain Property With Value    activityReference..userDefine1    PREPARE TEST DATA BY AUTOMATE SCRIPT
   Response Should Contain Property With Value    activityReference..userDefine2    GENERATE BY QA-STORM TEAM
   Response Should Contain Property With Value    activityReference..userDefine3    NOTE
   Response Should Contain Property With String Value    activityReference..createdDate
   Response Should Contain Property With String Value    activityReference..lastModifiedDate

TC_O2O_25368
   [Documentation]    [query activity] Verify response when query with charge success transaction case no installment
   [Tags]    Medium    Regression    Smoke    payment
   #Preparations step: START
   Generate Transaction Reference    ${external_ref_id_length}
   Generate Omise Payment Token    ${omise_valid_visa_card}
   Prepare Encryption Message Before Charge With Omise Gateway
   ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"returnUrl": null,"amount": 100000,"currency": "${TH_CURRENCY}"
   Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
   Response Correct Code    ${SUCCESS_CODE}
   #EPreparations step: END
   Get Merchant Payment Query By ClientRefId    clientRefId=PREPARE-${TRANSACTION_REFERENCE}&paymentAccountId=${VALID_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    status    SUCCESS
   Response Should Contain Property With Value    statusDescription    SUCCESS
   Response Should Contain Property With Value    transaction.gatewayType    OMISE
   Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
   Response Should Contain Property With Value    activityReference..action    CHARGE
   Response Should Contain Property With Value    activityReference..status    SUCCESS
   Response Should Contain Property With Value    activityReference..statusDescription    SUCCESS
