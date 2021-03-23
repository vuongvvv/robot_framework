*** Settings ***
Documentation    Tests to verify payment credit card reverse charge by payment account api

Resource    ../../../resources/init.robot
Resource    ../../../../web/resources/init.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/payment/payment_account_resource/wepayment_account_management_keywords.robot
Resource    ../../../keywords/payment/credit_card_resource/creditcard_reverse_charge_by_payment_account_keywords.robot
Resource    ../../../keywords/payment/credit_card_resource/creditcard_charge_by_payment_account_keywords.robot
Resource    ../../../keywords/payment/credit_card_resource/creditcard_capture_charge_by_payment_account_keywords.robot
Resource    ../../../keywords/payment/payment_account_resource/saved_creditcards_keywords.robot
Resource    ../../../../web/keywords/payment/credit_card_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
Test Teardown     Delete All Sessions
#Require Wepayment_Client Scope: payment.payment.list, payment.creditCard.reverse

*** Variables ***
${external_ref_id_length}    15
${amount}    10100
${store_client_username}    REGRESSION_USERNAME_AUTOMATE_TEST

*** Test Cases ***
OMISE_CAPTURE_PREPARE_TEST_DATA
    [Documentation]    Prepare charge transaction before run execution
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    #1. Update active flag for payment account_id = ${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID} // ${INACTIVE_PAYMENT_ACCOUNT_ID} // ${INACTIVE_OMISE_ACCOUNT_ID}
    Put Update Payment Account    ${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00513","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-INACTIVE-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Put Update Omise Account    ${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}    {"additionalRate": "1.8999234","additionalRateDesc": "Create By Automation","categoryId": "${CATEGORY_ID}","enabled": true,"topUpRate": "1"}
    Put Update Payment Account    ${INACTIVE_PAYMENT_ACCOUNT_ID}    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00511","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-INACTIVE-001","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Put Update Omise Account    ${INACTIVE_OMISE_ACCOUNT_ID}    {"additionalRate": "1.8999234","additionalRateDesc": "Create By Automation","categoryId": "${CATEGORY_ID}","enabled": true,"topUpRate": "1"}
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
    #2. Create charge transaction and status = authorize payment account_id = ${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_master_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "100050","currency": "${TH_CURRENCY}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transaction.status    AUTHORIZED
    #3. Create charge transaction and status = authorize payment account_id = ${INACTIVE_PAYMENT_ACCOUNT_ID}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_master_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${INACTIVE_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "100050","currency": "${TH_CURRENCY}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transaction.status    AUTHORIZED
    #4. Create charge transaction and status = authorize payment account_id = ${INACTIVE_OMISE_ACCOUNT_ID}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_master_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${INACTIVE_OMISE_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "100050","currency": "${TH_CURRENCY}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transaction.status    AUTHORIZED
    #5. Rollback payment account active status
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
    Put Update Payment Account    ${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00513","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-INACTIVE-003","enabled":false,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Put Update Omise Account    ${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}    {"additionalRate": "1.8999234","additionalRateDesc": "Create By Automation","categoryId": "${CATEGORY_ID}","enabled": false,"topUpRate": "1"}
    Put Update Payment Account    ${INACTIVE_PAYMENT_ACCOUNT_ID}    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00511","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-INACTIVE-001","enabled":false,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Put Update Omise Account    ${INACTIVE_OMISE_ACCOUNT_ID}    {"additionalRate": "1.8999234","additionalRateDesc": "Create By Automation","categoryId": "${CATEGORY_ID}","enabled": false,"topUpRate": "1"}
    #Preparations step end

TC_O2O_24970
    [Documentation]    [Access_control][app_client][reverse] Verify response when app_client not found
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    AUTHORIZED
    # Step 2: Send request to do the manual reverse in OMISE
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_onetime_otp
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.unauthorized
    Response Should Contain Property With Value    status    ${401}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.unauthorized
    Response Should Contain Property With Value    errors..code    0_unauthorized
    Response Should Contain Property With Value    errors..message    unauthorized

TC_O2O_24971
    [Documentation]    [Access_control][merchant authorized][reverse] Verify response when no merchant authorized case merchant din't mapped to request client
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    AUTHORIZED
    # Step 2: Send request to do the manual reverse in OMISE
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_no_authority
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_24972
    [Documentation]    [Access_control][reverse] Verify response when Omise and Payment account are inactive
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    AUTHORIZED    ${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}
    # Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_active
    Response Should Contain Property With Value    errors..message    Payment Account is inactive

TC_O2O_24973
    [Documentation]    [Access_control][reverse] Verify response when Payment account is inactive
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    AUTHORIZED    ${INACTIVE_PAYMENT_ACCOUNT_ID}
    # Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_active
    Response Should Contain Property With Value    errors..message    Payment Account is inactive

TC_O2O_24974
    [Documentation]    [Access_control][reverse] Verify response when Omise account is inactive
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    AUTHORIZED    ${INACTIVE_OMISE_ACCOUNT_ID}
    # Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_omise_not_active
    Response Should Contain Property With Value    errors..message    Omise Account is inactive

TC_O2O_24975
    [Documentation]    [Access_control][reverse] Verify response when transaction_id not found
    [Tags]    Medium    Regression    payment
    Post Payment Reverse Charge    txrn_id_not_found
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/txrn_id_not_found/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_found
    Response Should Contain Property With Value    errors..message    Transaction Not Found

TC_O2O_24977
    [Documentation]    [reverse] verify response when transaction status is pending
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    PENDING    ${VALID_PAYMENT_ACCOUNT_ID}
    # Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_reverse
    Response Should Contain Property With Value    errors..message    PENDING - Transaction is not allowed to reverse

TC_O2O_24978
    [Documentation]    [reverse] verify response when transaction status is fail
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    FAIL    ${VALID_PAYMENT_ACCOUNT_ID}
    # Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_reverse
    Response Should Contain Property With Value    errors..message    FAIL - Transaction is not allowed to reverse

TC_O2O_24979
    [Documentation]    [reverse] verify response when transaction status is reverse
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    REVERSED    ${VALID_PAYMENT_ACCOUNT_ID}
    # Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_reverse
    Response Should Contain Property With Value    errors..message    REVERSED - Transaction is not allowed to reverse

TC_O2O_24980
    [Documentation]    [reverse] verify response when transaction status is settled
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    SETTLED    ${VALID_PAYMENT_ACCOUNT_ID}
    # Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_reverse
    Response Should Contain Property With Value    errors..message    SETTLED - Transaction is not allowed to reverse

TC_O2O_24981
    [Documentation]    [reverse] verify response when transaction status is void
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    VOID    ${VALID_PAYMENT_ACCOUNT_ID}
    # Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_reverse
    Response Should Contain Property With Value    errors..message    VOID - Transaction is not allowed to reverse

TC_O2O_24982
    [Documentation]    [reverse] verify response when transaction status is refund
    [Tags]    Medium    Regression    payment
    # Step 1: Find charge transaction whose pending capture//reverse step
    Search Payment Transaction By Status    REFUND    ${VALID_PAYMENT_ACCOUNT_ID}
    # Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/credit-card/transactions/${TRANSACTION_ID}/reverse
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_reverse
    Response Should Contain Property With Value    errors..message    REFUND - Transaction is not allowed to reverse

TC_O2O_24984
    [Documentation]    [3DSecure][Manual Capture][reverse] verify response when transaction status is authorized and omise transaction didn't expired
    [Tags]    Medium    Regression    payment
    [Setup]    Run Keywords    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment    AND    Switch To Non Angular JS Site
    [Teardown]    Run Keywords    Delete All Sessions    AND    Switch To Angular JS Site
    #Preparations step: Start Prepare KMS Encryption
    Remove Existing Saved Credit Cards Before Executing Test    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_master_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": true,"clientUsername": "${store_client_username}","email": "payment.automation@ascendcorp.com","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Fetch Property From Response    .authorizeUri    OMISE_AUTHORIZE_URI
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    authorizeUri    ${OMISE_AUTHORIZE_URI}
    Confirm Credit Card Authorize    ${OMISE_AUTHORIZE_URI}
    #Preparations step: END
    #Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REVERSE_PREPARE-${TRANSACTION_REFERENCE}
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
    Response Should Contain Property With Value    transaction.status    REVERSED
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX4444
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24985
    [Documentation]    [Non 3DSecure][Manual Capture][reverse] verify response when transaction status is authorized and omise transaction didn't expired
    [Tags]    Medium    Regression    Smoke    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_master_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    #Preparations step: END
    #Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REVERSE_PREPARE-${TRANSACTION_REFERENCE}
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
    Response Should Contain Property With Value    transaction.status    REVERSED
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX4444
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_24986
    [Documentation]    [Non 3DSecure][Manual Capture][reverse] verify response when payment with credit card whose 3D secure fail
    [Tags]    Medium    Regression    payment
    #Preparations step: Start Prepare KMS Encryption
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${enrollment_fail_jcb_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    #Preparations step: END
    #Step 2: Send request to do the manual reverse in OMISE
    Post Payment Reverse Charge    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REVERSE_PREPARE-${TRANSACTION_REFERENCE}
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
    Response Should Contain Property With Value    transaction.status    REVERSED
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX0002
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
