*** Settings ***
Documentation    Tests to verify payment credit card charge by payment account api

Resource    ../../../resources/init.robot
Resource    ../../../../web/resources/init.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/payment/credit_card_resource/creditcard_charge_by_payment_account_keywords.robot
Resource    ../../../keywords/payment/credit_card_resource/search_specific_detail_merchant_payment_transaction_keywords.robot
Resource    ../../../keywords/payment/payment_account_resource/saved_creditcards_keywords.robot
Resource    ../../../../web/keywords/payment/credit_card_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
Test Teardown     Delete All Sessions
#Require Wepayment_Client Scope: payment.creditCard.charge

*** Variables ***
${external_ref_id_length}    15
${amount}    310000
${store_client_username}    REGRESSION_USERNAME_AUTOMATE_TEST
${bff_remark}    TEST BY AUTOMATION, REGRESSION CHARGE API
${userDefine1}    AUTOMATION TEST SCRIPT, REGRESSION CHARGE API
${userDefine2}    DEFINE BY STORM TEAM, REGRESSION CHARGE API
${userDefine3}    VALIDATION: REGRESSION PAYMENT WITH CHARGE API
@{action_create_charge_authorize}    CREATE_CHARGE    AUTHORIZE
@{visa_credit_card_only}    XXXXXXXXXXXX1111
@{visa_and_mastercard_credit_card}    XXXXXXXXXXXX1111    XXXXXXXXXXXX4444
${installment_amount}    300000
${period}    3
${merchant_interestType}    MERCHANT
${customer_interestType}    CUSTOMER
${providerName}    KTC

*** Test Cases ***
TC_O2O_24891
    [Documentation]    [Access_control] not allow to charge when app_client scope not found
    [Tags]    Medium    Regression    UnitTest
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientnoscope
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_26454
    [Documentation]    [Access_control] [wepayment app_client] Not allow to charge when not found app client in wePayment
    [Tags]    Medium    Regression
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_onetime_otp
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.unauthorized
    Response Should Contain Property With Value    status    ${401}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.unauthorized
    Response Should Contain Property With Value    errors..code    0_unauthorized
    Response Should Contain Property With Value    errors..message    unauthorized

TC_O2O_24895
    [Documentation]    [Access_control] Verify response when no merchant authorized case merchant already mapped to other app client
    [Tags]    Medium    Regression    UnitTest
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_no_authority
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_24896
    [Documentation]    [Access_control] Verify response when Omise and Payment account are inactive
    [Tags]    Medium    Regression    UnitTest    Smoke    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_active
    Response Should Contain Property With Value    errors..message    Payment Account is inactive

TC_O2O_24897
    [Documentation]    [Access_control] Verify response when Payment account is inactive
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${INACTIVE_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_active
    Response Should Contain Property With Value    errors..message    Payment Account is inactive

TC_O2O_24898
    [Documentation]    [Access_control] Verify response when Omise account is inactive
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${INACTIVE_OMISE_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_omise_not_active
    Response Should Contain Property With Value    errors..message    Omise Account is inactive

TC_O2O_24899
    [Documentation]    [Access_control] Verify response when Payment account didn't mapped with omise account
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${NO_OMISE_ACCOUNT}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_omise_account_not_found
    Response Should Contain Property With Value    errors..message    Omise Account Not Found

TC_O2O_24900
    [Documentation]    [Access_control] Verify response when Payment account not found
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "INVALID","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_found
    Response Should Contain Property With Value    errors..message    Payment Account Not Found

TC_O2O_24901
    [Documentation]    [3DSecure][manual capture][StoreCard false] Verify response when create transaction success with valid information case storecard is false
    [Tags]    Medium    Regression    UnitTest    Smoke    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Fetch Property From Response    .authorizeUri    OMISE_AUTHORIZE_URI
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Null Value    userDefine1
    Response Should Contain Property With Null Value    userDefine2
    Response Should Contain Property With Null Value    userDefine3
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Value    authorizeUri    ${OMISE_AUTHORIZE_URI}
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24902
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to Duplicate clientRefId
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-DUPP0001","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_duplicate_transaction
    Response Should Contain Property With Value    errors..message    Duplicate External Transaction

TC_O2O_24903
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to omise_payment_token and merchant omise_public_key config unmatch
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}    pkey_test_5kxokftgp5muh55cmwy
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_not_found
    Response Should Contain Property With Value    errors..message    token ${OMISE_PAYMENT_TOKEN} was not found
    Response Should Contain Property With Value    errors..activityId    ${ACTIVITY_ID}

TC_O2O_24904
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to omise_payment_token expire or already used
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption (First time for Omise token charge)
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    #Preparations step: Start Prepare KMS Encryption (Second time for the same Omise token charge)
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}"}
    # Preparations step: END
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","userDefine1": "Verify charge fail due to omise_payment_token expire or already used","userDefine2": "transaction failed","userDefine3": "test by automation"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_used_token
    Response Should Contain Property With Value    errors..message    token was already used
    Response Should Contain Property With Value    errors..activityId    ${ACTIVITY_ID}

TC_O2O_24905
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to amount is over 9 digits
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "1000000000","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    amount length must be less than 10

TC_O2O_24906
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to total amount is string
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "300.00","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    amount is invalid.

TC_O2O_24907
    [Documentation]    [3DSecure][manual capture] allow to charge with amount 100 satang
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "100","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .authorizeUri    OMISE_AUTHORIZE_URI
    Response Should Contain Property With Value    amount    100
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    authorizeUri    ${OMISE_AUTHORIZE_URI}
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24908
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to credit card is unable to charge (error from OMISE)
    [Tags]    Medium    Regression    UnitTest    Smoke
    [Setup]    Run Keywords    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment    AND    Switch To Non Angular JS Site
    [Teardown]    Run Keywords    Delete All Sessions    AND    Switch To Angular JS Site
    #Step1: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${insufficient_fund_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Step2: Send request to Omise for charge with 3D secure and manual capture
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Fetch Property From Response    .authorizeUri    OMISE_AUTHORIZE_URI
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    authorizeUri    ${OMISE_AUTHORIZE_URI}
    #Step3: Open browser and confirm authorized step and get callback message from OMISE
    Confirm Credit Card Authorize    ${OMISE_AUTHORIZE_URI}
    #Step4: Verify the transaction after do the authorized success in OMISE  >> add sleep thead for pending callback process
    Sleep    0.5s
    Get Specific Detail Merchant Payment Transaction    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    status    FAIL
    Response Should Contain Property Value Include In List    activities..action    ${action_create_charge_authorize}
    Response Should Contain Property With Value    activities..status    FAIL
    Response Should Contain Property With Value    activities..statusDescription    insufficient funds in the account or the card has reached the credit limit

TC_O2O_24909
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to credit card is unable to charge (Creating failed 3DS charges)
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${enrollment_fail_jcb_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "100","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_payment_rejected
    Response Should Contain Property With Value    errors..message    payment_rejected:3d secure is requested but card is not enrolled

TC_O2O_24910
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to currency not THB
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "USD"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    currency is invalid.

TC_O2O_24911
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to cardToken is empty or null
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": ""}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "","userDefine1": "Verify charge fail due to cardToken is empty or null","userDefine2": "Not create transaction","userDefine3": "test001"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    cardToken must not be empty

TC_O2O_24912
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to cardToken is invalid
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "invalid"}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "invalid","userDefine1": "Verify charge fail due to cardToken is invalid","userDefine2": "New transaction failed","userDefine3": "test001"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_not_found
    Response Should Contain Property With Value    errors..message    token invalid was not found
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_24913
    [Documentation]    [3DSecure][manual capture] Verify response when create transaction fail due to returnUrl is not html format
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "www.google.com","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    returnUrl must be a valid URL

TC_O2O_24914
    [Documentation]    [3DSecure][manual capture] Not support to charge with installment plan
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName": "${providerName}"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName": "${providerName}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    manualCapture must not be true

TC_O2O_24915
    [Documentation]    [3DSecure][manual capture][StoreCard true] Verify response when create transaction success with valid information case storecard is true
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Remove Existing Saved Credit Cards Before Executing Test    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": true,"clientUsername": "${store_client_username}","email": "payment.automation@ascendcorp.com","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    wpCardId
    Fetch Property From Response    .wpCardId    WP_CARD_ID
    #Verify save credit card by clientUsername
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    cards..wpCardId    ${WP_CARD_ID}
    Response Should Contain Property With Value    cards..pan    XXXXXXXXXXXX1111

TC_O2O_24916
    [Documentation]    [3DSecure][manual capture][StoreCard true] Not allow to charge when remember flag is true and clientUsername is empty
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": true,"clientUsername": "","email": "payment.automation@ascendcorp.com","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientUsername must not be empty

TC_O2O_24917
    [Documentation]    [3DSecure][manual capture][StoreCard true] Allow to charge when remember flag is true and email is null
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Remove Existing Saved Credit Cards Before Executing Test    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": true,"clientUsername": "${store_client_username}","email": null,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    wpCardId
    Fetch Property From Response    .wpCardId    WP_CARD_ID
    #Verify save credit card by clientUsername
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    cards..wpCardId    ${WP_CARD_ID}
    Response Should Contain Property With Value    cards..pan    XXXXXXXXXXXX1111

TC_O2O_24918
    [Documentation]    [3DSecure][manual capture][StoreCard true] Not allow to charge when remember flag is true and email is empty
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": true,"clientUsername": "${store_client_username}","email": "","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    email is invalid.

TC_O2O_24919
    [Documentation]    [3DSecure][manual capture][wpCardId] Allow to charge with valid wpCardId
    [Tags]    Medium    Regression    UnitTest    Smoke    payment
    #Preparations step: Start Prepare KMS Encryption
    Prepare Wpcard Id    ${omise_valid_visa_card}
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","wpCardId": "${WP_CARD_ID}","clientUsername": "PREPARE_AUTOMATE","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"}
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","wpCardId": "${WP_CARD_ID}","clientUsername": "PREPARE_AUTOMATE","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    ${userDefine1}
    Response Should Contain Property With Value    userDefine2    ${userDefine2}
    Response Should Contain Property With Value    userDefine3    ${userDefine3}
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    authorizeUri
    Response Should Contain Property With Value    wpCardId    ${WP_CARD_ID}
    #Verify save credit card by clientUsername
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}     PREPARE_AUTOMATE
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    cards..wpCardId    ${WP_CARD_ID}
    Response Should Contain Property With Value    cards..pan    XXXXXXXXXXXX1111

TC_O2O_24920
    [Documentation]    [3DSecure][manual capture][wpCardId] Verify response when charge with invalid wpCardId
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}-WP","manualCapture": true,"rememberCard": false,"clientUsername": "PREPARE_AUTOMATE","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","wpCardId": "WP_CARD_ID"}
    #Preparations step: End
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}-WP","manualCapture": true,"rememberCard": false,"clientUsername": "PREPARE_AUTOMATE","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","wpCardId": "WP_CARD_ID"}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_wp_card_id_not_found
    Response Should Contain Property With Value    errors..message    WePayment Card ID Not Found

TC_O2O_24921
    [Documentation]    [3DSecure][manual capture][wpCardId] Verify response when charge with valid wpCardId but invalid clientUsername
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Prepare Wpcard Id
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}-WP","manualCapture": true,"clientUsername": "INVALID","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","wpCardId": "${WP_CARD_ID}"}
    #Preparations step: End
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}-WP","manualCapture": true,"clientUsername": "INVALID","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","wpCardId": "${WP_CARD_ID}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_wp_card_id_no_authority
    Response Should Contain Property With Value    errors..message    No authority for wpCardId

TC_O2O_24923
    [Documentation]    [3DSecure][auto capture][StoreCard false] Allow to charge when input valid information case storecard is false
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
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
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With String Value    authorizeUri
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24924
    [Documentation]    [3DSecure][auto capture] Verify response when clientRefId is duplicate
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-3DS-AUTO-DUPP0001","manualCapture": false,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_duplicate_transaction
    Response Should Contain Property With Value    errors..message    Duplicate External Transaction

TC_O2O_24925
    [Documentation]    [3DSecure][auto capture] Verify response when create transaction fail due to credit card is unable to charge (Error from Omise)
    [Tags]    Medium    Regression    UnitTest    Smoke
    [Setup]    Run Keywords    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment    AND    Switch To Non Angular JS Site
    [Teardown]    Run Keywords    Delete All Sessions    AND    Switch To Angular JS Site
    #Step1: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${insufficient_fund_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    #Step2: Send request to Omise for charge with 3D secure and manual capture
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Fetch Property From Response    .authorizeUri    OMISE_AUTHORIZE_URI
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    authorizeUri    ${OMISE_AUTHORIZE_URI}
    #Step3: Open browser and confirm authorized step and get callback message from OMISE
    Confirm Credit Card Authorize    ${OMISE_AUTHORIZE_URI}
    #Step4: Verify the transaction after do the authorized success in OMISE  >> add sleep thead for pending callback process
    Sleep    0.5s
    Get Specific Detail Merchant Payment Transaction    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    status    FAIL
    Response Should Contain Property Value Include In List    activities..action    ${action_create_charge_authorize}
    Response Should Contain Property With Value    activities..status    FAIL
    Response Should Contain Property With Value    activities..statusDescription    insufficient funds in the account or the card has reached the credit limit

TC_O2O_24926
    [Documentation]    [3DSecure][auto capture] Verify response when create transaction fail due to credit card is unable to charge (Creating failed 3DS charges)
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${enrollment_fail_jcb_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "100","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_payment_rejected
    Response Should Contain Property With Value    errors..message    payment_rejected:3d secure is requested but card is not enrolled

TC_O2O_24927
    [Documentation]    [3DSecure][auto capture]Verify response when create transaction fail due to omise_payment_token expire or already used
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption (First time for Omise token charge)
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    #Preparations step: Start Prepare KMS Encryption (Second time for the same Omise token charge)
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}"}
    # Preparations step: END
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","userDefine1": "Verify charge fail due to omise_payment_token expire or already used","userDefine2": "transaction failed","userDefine3": "test by automation"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_used_token
    Response Should Contain Property With Value    errors..message    token was already used
    Response Should Contain Property With Value    errors..activityId    ${ACTIVITY_ID}

TC_O2O_24928
    [Documentation]    [3DSecure][auto capture][StoreCard true] Verify response when create transaction success with valid information case storecard is true
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Remove Existing Saved Credit Cards Before Executing Test    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": true,"clientUsername": "${store_client_username}","email": "payment.automation@ascendcorp.com","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    wpCardId
    Fetch Property From Response    .wpCardId    WP_CARD_ID
    #Verify save credit card by clientUsername
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    cards..wpCardId    ${WP_CARD_ID}
    Response Should Contain Property With Value    cards..pan    XXXXXXXXXXXX1111

TC_O2O_24929
    [Documentation]    [3DSecure][auto capture][wpCardId] allow to create new wpCardId with the same card and clientUsername
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": true,"clientUsername": "${store_client_username}","email": "payment.automation@ascendcorp.com","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    wpCardId
    #Verify save credit card by clientUsername
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    cards..wpCardId
    Response Should Contain Property Value Include In List    cards..pan    ${visa_credit_card_only}

TC_O2O_24930
    [Documentation]    [3DSecure][auto capture][wpCardId] allow to create new wpCardId with the same card and diference clientUsername
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Remove Existing Saved Credit Cards Before Executing Test    ${VALID_PAYMENT_ACCOUNT_ID}    REGRESSION_USERNAME_AUTOMATE_TEST_2
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": true,"clientUsername": "REGRESSION_USERNAME_AUTOMATE_TEST_2","email": "payment.automation@ascendcorp.com","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    wpCardId
    Fetch Property From Response    .wpCardId    WP_CARD_ID
    #Verify save credit card by clientUsername = REGRESSION_USERNAME_AUTOMATE_TEST
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    cards..wpCardId
    Response Should Contain Property Value Include In List    cards..pan    ${visa_credit_card_only}
    #Verify save credit card by clientUsername = REGRESSION_USERNAME_AUTOMATE_TEST_2
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    REGRESSION_USERNAME_AUTOMATE_TEST_2
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    cards..wpCardId    ${WP_CARD_ID}
    Response Should Contain Property With Value    cards..pan    XXXXXXXXXXXX1111

TC_O2O_24931
    [Documentation]    [3DSecure][auto capture][wpCardId] allow to create new wpCardId with the difference card and same clientUsername
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_master_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": true,"clientUsername": "${store_client_username}","email": "payment.automation@ascendcorp.com","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    wpCardId
    #Verify save credit card by clientUsername
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    cards..wpCardId
    Response Should Contain Property Value Include In List    cards..pan    ${visa_and_mastercard_credit_card}

TC_O2O_24932
    [Documentation]    [3DSecure][auto capture][Installment] Verify response when create transaction success with valid information case interestType =MERCHANT
    [Tags]    Medium    Regression    UnitTest    payment
    # Step1: Send request to charge with 3DSecure and Auto capture and Installment plan to Omise
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName":"${providerName}"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName":"${providerName}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    authorizeUri
    Response Should Contain Property With Value    installment.period    ${${period}}
    Response Should Contain Property With Value    installment.interestType    ${merchant_interestType}
    Response Should Contain Property With Value    installment.providerName    ${providerName}
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24933
    [Documentation]    [3DSecure][auto capture][Installment] Verify response when create transaction success with valid information case interestType =CUSTOMER
    [Tags]    Medium    Regression    payment
    # Step1: Send request to charge with 3DSecure and Auto capture and Installment plan to Omise
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "${customer_interestType}","providerName":"${providerName}"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "${customer_interestType}","providerName":"${providerName}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    authorizeUri
    Response Should Contain Property With Value    installment.period    ${${period}}
    Response Should Contain Property With Value    installment.interestType    ${customer_interestType}
    Response Should Contain Property With Value    installment.providerName    ${providerName}
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24934
    [Documentation]    [3DSecure][auto capture][Installment] Verify response when amount less than 2000.00 THB
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "199900","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName":"${providerName}"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "199900","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName":"${providerName}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_invalid_installment_minimum_amount
    Response Should Contain Property With Value    errors..message    Minimum installment amount should more than or equal 200000

TC_O2O_27789
    [Documentation]    [3DSecure][auto capture][Installment] Verify response when input amount less than installment plan minTotalAmount
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "250000","currency": "${TH_CURRENCY}","installment": {"period": "10","interestType": "${merchant_interestType}","providerName":"${providerName}"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "250000","currency": "${TH_CURRENCY}","installment": {"period": "10","interestType": "${merchant_interestType}","providerName":"${providerName}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_invalid_installment_minimum_amount
    Response Should Contain Property With Value    errors..message    Minimum installment amount should more than or equal 300000

TC_O2O_24935
    [Documentation]    [3DSecure][auto capture][Installment] Verify response when input invalid installment period
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "2","interestType": "${merchant_interestType}","providerName":"${providerName}"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "2","interestType": "${merchant_interestType}","providerName":"${providerName}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_invalid_installment_period
    Response Should Contain Property With Value    errors..message    Invalid installment period

TC_O2O_24936
    [Documentation]    [3DSecure][auto capture][Installment] Verify response when input invalid interestType
    [Tags]    Medium    Regression    UnitTest    payment
    #Note API Not allow to input interestType in lowercase
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "merchant","providerName":"${providerName}"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "merchant","providerName":"${providerName}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    installment.interestType is invalid.

TC_O2O_24937
    [Documentation]    [3DSecure][auto capture][Installment] Verify response when input invalid providerName
    [Tags]    Medium    Regression    UnitTest    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName":"OTHER"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "${installment_amount}","currency": "${TH_CURRENCY}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName":"OTHER"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    installment.providerName not supported

TC_O2O_24938
    [Documentation]    [Non3DSecure][manual capture][StoreCard false] Verify response when create transaction success with valid information case storecard is false
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    ${userDefine1}
    Response Should Contain Property With Value    userDefine2    ${userDefine2}
    Response Should Contain Property With Value    userDefine3    ${userDefine3}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    AUTHORIZED
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Not Contain Property    authorizeUri
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24939
    [Documentation]    [Non3DSecure][manual capture] Verify response when create transaction fail due to credit card is unable to charge (Creating failed charges)
    [Tags]    Medium    Regression    payment
    #Step1: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${insufficient_fund_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": null,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Step2: Send request to Omise for charge with Non3DSecure and manual capture
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_insufficient_fund
    Response Should Contain Property With Value    errors..message    insufficient_fund:insufficient funds in the account or the card has reached the credit limit

TC_O2O_24940
    [Documentation]    [Non3DSecure][manual capture] Allow to charge with credit card whose has 3DS fail
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${enrollment_fail_jcb_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transaction.status    AUTHORIZED
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX0002
    Response Should Not Contain Property    authorizeUri
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24941
    [Documentation]    [Non3DSecure][manual capture][StoreCard true] Verify response when create transaction success with valid information case storecard is true
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Remove Existing Saved Credit Cards Before Executing Test    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": true,"clientUsername": "${store_client_username}","email": "payment.automation@ascendcorp.com","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    AUTHORIZED
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    wpCardId
    Fetch Property From Response    .wpCardId    WP_CARD_ID
    #Verify save credit card by clientUsername
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    cards..wpCardId    ${WP_CARD_ID}
    Response Should Contain Property With Value    cards..pan    XXXXXXXXXXXX1111

TC_O2O_24942
    [Documentation]    [Non3DSecure][manual capture] Not support to charge with installment plan
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName": "${providerName}"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName": "${providerName}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    manualCapture must not be true

TC_O2O_24943
    [Documentation]    [Non3DSecure][manual capture][wpCardId] allow to charge with valid wpCardId
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Prepare Wpcard Id
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}-WP","manualCapture": true,"rememberCard": false,"clientUsername": "PREPARE_AUTOMATE","amount": "${amount}","currency": "${TH_CURRENCY}","wpCardId": "${WP_CARD_ID}"}
    #Preparations step: End
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}-WP","manualCapture": true,"rememberCard": false,"clientUsername": "PREPARE_AUTOMATE","amount": "${amount}","currency": "${TH_CURRENCY}","wpCardId": "${WP_CARD_ID}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}-WP
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    ${userDefine1}
    Response Should Contain Property With Value    userDefine2    ${userDefine2}
    Response Should Contain Property With Value    userDefine3    ${userDefine3}
    Response Should Contain Property With Value    transaction.status    AUTHORIZED
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Not Contain Property    authorizeUri
    Response Should Contain Property With Value    wpCardId    ${WP_CARD_ID}

TC_O2O_24944
    [Documentation]    [Non3DSecure][auto capture][StoreCard false] Verify response when create transaction success with valid information case storecard is false
    [Tags]    Medium    Regression    UnitTest    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
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
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Not Contain Property    authorizeUri
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24945
    [Documentation]    [Non3DSecure][auto capture] Verify response when create transaction fail due to credit card is unable to charge (Creating failed charges)
    [Tags]    Medium    Regression    payment
    #Step1: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${insufficient_fund_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"returnUrl": null,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Step2: Send request to Omise for charge with Non3DSecure and manual capture
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_insufficient_fund
    Response Should Contain Property With Value    errors..message    insufficient_fund:insufficient funds in the account or the card has reached the credit limit

TC_O2O_24946
    [Documentation]    [Non3DSecure][auto capture] Allow to charge with credit card whose has 3DS fail
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${enrollment_fail_jcb_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX0002
    Response Should Not Contain Property    authorizeUri
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24947
    [Documentation]    [Non3DSecure][auto capture][StoreCard true] Verify response when create transaction success with valid information case storecard is true
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Remove Existing Saved Credit Cards Before Executing Test    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": true,"clientUsername": "${store_client_username}","email": "payment.automation@ascendcorp.com","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    wpCardId
    Fetch Property From Response    .wpCardId    WP_CARD_ID
    #Verify save credit card by clientUsername
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    cards..wpCardId    ${WP_CARD_ID}
    Response Should Contain Property With Value    cards..pan    XXXXXXXXXXXX1111

TC_O2O_24948
    [Documentation]    [Non3DSecure][auto capture][StoreCard true] Verify response when create transaction fail due to payment token already used
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption (First time for Omise token charge)
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    #Preparations step: Start Prepare KMS Encryption (Second time for the same Omise token charge)
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}"}
    # Preparations step: END
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_used_token
    Response Should Contain Property With Value    errors..message    token was already used
    Response Should Contain Property With Value    errors..activityId    ${ACTIVITY_ID}

TC_O2O_24949
    [Documentation]    [Non3DSecure][auto capture][StoreCard true] Verify response when create transaction fail due to credit card is unable to charge (error from Omise)
    [Tags]    Medium    Regression    payment
    #Step1: Start Prepare KMS Encryption
    Remove Existing Saved Credit Cards Before Executing Test    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${insufficient_fund_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": true,"clientUsername":"${store_client_username}","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    #Step2: Send request to Omise for charge with Non3DSecure and manual capture
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    6_insufficient_fund
    Response Should Contain Property With Value    errors..message    insufficient_fund:insufficient funds in the account or the card has reached the credit limit
    #Verify save credit card by should be created
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .wpCardId    WP_CARD_ID
    Response Should Contain Property With Value    cards..wpCardId    ${WP_CARD_ID}
    Response Should Contain Property With Value    cards..pan    XXXXXXXXXXXX0011

TC_O2O_24950
    [Documentation]    [Non3DSecure][auto capture] Not support to charge with installment plan
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName": "${providerName}"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","installment": {"period": "${period}","interestType": "${merchant_interestType}","providerName": "${providerName}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    returnUrl must not be empty

TC_O2O_24951
    [Documentation]    [Non3DSecure][auto capture][wpCardId] allow to charge with valid wpCardId
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Prepare Wpcard Id
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}-WP","manualCapture": false,"clientUsername": "PREPARE_AUTOMATE","amount": "${amount}","currency": "${TH_CURRENCY}","wpCardId": "${WP_CARD_ID}"}
    #Preparations step: End
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}-WP","manualCapture": false,"clientUsername": "PREPARE_AUTOMATE","amount": "${amount}","currency": "${TH_CURRENCY}","wpCardId": "${WP_CARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}-WP
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Not Contain Property    authorizeUri
    Response Should Contain Property With Value    wpCardId    ${WP_CARD_ID}

TC_O2O_25676
    [Documentation]    Allow to charge with userDefine and without metadata case all information are valid
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
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
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Not Contain Property    authorizeUri
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_25677
    [Documentation]    Allow to charge without metadata and userDefine case all information are valid
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
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
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Not Contain Property    authorizeUri
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_25678
    [Documentation]    Allow to charge with metadata but without userDefine case all information are valid
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","metadata":{"BFF-CHARGE": "${TRANSACTION_REFERENCE}","BFF-REMARK": "${bff_remark}"}}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
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
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Not Contain Property    authorizeUri
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_25681
    [Documentation]    Allow to charge with metadata when not found any value inside
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","metadata":{},"userDefine1": "${userDefine1}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    ${userDefine1}
    Response Should Contain Property With Null Value    userDefine2
    Response Should Contain Property With Null Value    userDefine3
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_25682
    [Documentation]    Allow to charge when metadata is null value
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    #Preparations step: END
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","metadata":null,"userDefine2": "${userDefine2}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    CHARGE-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Null Value    userDefine1
    Response Should Contain Property With Value    userDefine2    ${userDefine2}
    Response Should Contain Property With Null Value    userDefine3
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
