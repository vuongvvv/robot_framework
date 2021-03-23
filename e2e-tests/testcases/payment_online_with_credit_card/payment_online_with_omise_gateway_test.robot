*** Settings ***
Documentation    Tests to verify All payment api with OMISE Gateway are works correctly

Resource    ../../../api/resources/init.robot
Resource    ../../../web/resources/init.robot
Resource    ../../../api/resources/testdata/payment/merchant_list.robot
Resource    ../../../api/keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../api/keywords/payment/credit_card_resource/creditcard_charge_by_payment_account_keywords.robot
Resource    ../../../api/keywords/payment/credit_card_resource/creditcard_capture_charge_by_payment_account_keywords.robot
Resource    ../../../api/keywords/payment/credit_card_resource/creditcard_void_by_payment_account_keywords.robot
Resource    ../../../api/keywords/payment/payment_account_resource/saved_creditcards_keywords.robot
Resource    ../../../api/keywords/payment/credit_card_resource/search_specific_detail_merchant_payment_transaction_keywords.robot
Resource    ../../../api/keywords/payment/credit_card_resource/creditcard_refund_by_payment_account_keywords.robot
Resource    ../../../api/keywords/payment_transaction/merchant_payment_resource_keywords.robot
Resource    ../../../web/keywords/payment/credit_card_resource_keywords.robot
Test Setup    Run Keywords    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment    AND    Switch To Non Angular JS Site
Test Teardown     Run Keywords    Delete All Sessions    AND    Switch To Angular JS Site
#Require wepayment client scope: payment.creditCard.charge,payment.creditCard.read,payment.creditCard.capture

*** Variables ***
${external_ref_id_length}    15
${amount}    10100
${store_client_username}    AUTO_QA000
${bff_remark}    TEST BY AUTOMATION
${userDefine1}    AUTOMATION TEST SCRIPT
${userDefine2}    DEFINE BY STORM TEAM
${userDefine3}    VALIDATION: E2E PAYMENT WITH OMISE FLOW
@{3d_sucure_manual_capture_authorized_success}    CREATE_CHARGE    AUTHORIZE
@{3d_sucure_manual_capture_capture_success}    CREATE_CHARGE    AUTHORIZE    CAPTURE
@{3d_sucure_manual_void_success}    CREATE_CHARGE    AUTHORIZE    CAPTURE    VOID
@{3d_sucure_auto_capture_authorized_success}    CREATE_CHARGE    AUTHORIZE_CAPTURE
@{3d_sucure_auto_capture_refund_success}    CREATE_CHARGE    AUTHORIZE_CAPTURE
@{Non3d_sucure_manual_capture_capture_success}    CREATE_CHARGE    CAPTURE

*** Test Cases ***
TC_O2O_25711
    [Documentation]    [3D Secure][manual capture] User can do the charge and void successful case not remember card
    [Tags]    High    Regression    E2E    Sanity    Payment
    #Step1: Send request to charge with 3DSecure and Manual capture to Omise
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","metadata": {"BFF-CHARGE": "E2E-${TRANSACTION_REFERENCE}","BFF-REMARK": "${bff_remark}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Fetch Property From Response    .authorizeUri    OMISE_AUTHORIZE_URI
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Contain Property With Value    authorizeUri    ${OMISE_AUTHORIZE_URI}
    #Step2: Open browser and confirm authorized from omise response (authorizeUri)
    Confirm Credit Card Authorize    ${OMISE_AUTHORIZE_URI}
    # Step3: Verify the transaction after do the authorized success in OMISE >> add sleep thead for pending callback process
    Sleep    0.5s
    Get Specific Detail Merchant Payment Transaction    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    status    AUTHORIZED
    Response Should Contain Property Value Include In List    activities..action    ${3d_sucure_manual_capture_authorized_success}
    # Step4: Send request to do the manual capture in OMISE
    Post Payment Capture Charge    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    CAPTURE_E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    authorizeUri    ${OMISE_AUTHORIZE_URI}
    # Step5: Verify the transaction after do the manual capture success in OMISE >> add sleep thead for pending callback process
    Sleep    0.5s
    Get Specific Detail Merchant Payment Transaction    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    status    APPROVE
    Response Should Contain Property Value Include In List    activities..action    ${3d_sucure_manual_capture_capture_success}
    # Step6: Send request to do the void transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Payment Account    ${TRANSACTION_ID}
    ...    {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","metadata": {"BFF-VOID": "VOID-${TRANSACTION_REFERENCE}","BFF-TESTCASE": "${bff_remark}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    transaction.status    VOID
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    # Step7: Verify the transaction after do the void success in OMISE  >> add sleep thead for pending callback process
    Sleep    0.5s
    Get Specific Detail Merchant Payment Transaction    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    status    VOID
    Response Should Contain Property Value Include In List    activities..action    ${3d_sucure_manual_void_success}
    # Step8. Verify Transaction in Elastic search Should Not Sync
    Verify Elastic Search Transaction Should Not Sync    source_transaction_id:${TRANSACTION_ID}

TC_O2O_25752
    [Documentation]    [3D Secure][auto capture] User can do the charge and void successful case remember new card
    [Tags]    High    Regression    E2E    Sanity    Payment
    Remove Existing Saved Credit Cards Before Executing Test    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    #Step1: Send request to charge with 3DSecure and Auto capture to Omise
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": true,"clientUsername": "${store_client_username}","email": "payment.automation@ascendcorp.com","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": true,"clientUsername": "${store_client_username}","email": "payment.automation@ascendcorp.com","returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Fetch Property From Response    .authorizeUri    OMISE_AUTHORIZE_URI
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    authorizeUri    ${OMISE_AUTHORIZE_URI}
    Response Should Contain Property With String Value    wpCardId
    Fetch Property From Response    .wpCardId    WP_CARD_ID
    #Step2: Open browser and confirm authorized from omise response (authorizeUri)
    Confirm Credit Card Authorize    ${OMISE_AUTHORIZE_URI}
    # Step3: Verify the transaction after do the authorized success in OMISE  >> add sleep thead for pending callback process
    Sleep    0.5s
    Get Specific Detail Merchant Payment Transaction    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    status    APPROVE
    Response Should Contain Property Value Include In List    activities..action    ${3d_sucure_auto_capture_authorized_success}
    # Step4: Verify save credit card by clientUsername
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    cards..wpCardId    ${WP_CARD_ID}
    Response Should Contain Property With Value    cards..pan    XXXXXXXXXXXX1111
    # Step5: Send request to do the void transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Payment Account    ${TRANSACTION_ID}
    ...    {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","metadata": {"BFF-VOID": "VOID-${TRANSACTION_REFERENCE}","BFF-TESTCASE": "${bff_remark}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    VOID
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    # Step6: Delete save creit card
    Delete Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${WP_CARD_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body
    # Step6.1: Verify save credit after remove
    Get Saved Credit Cards    ${VALID_PAYMENT_ACCOUNT_ID}    ${store_client_username}
    Response Should Contain Property With Empty Value    cards
    # Step7. Verify Transaction in Elastic search Should Not Sync
    Verify Elastic Search Transaction Should Not Sync    source_transaction_id:${TRANSACTION_ID}

TC_O2O_25753
    [Documentation]    [3D Secure][auto capture][Installment] User can do the charge and refund successful
    [Tags]    High    Regression    E2E    Sanity    Payment
    # Step1: Send request to charge with 3DSecure and Auto capture and Installment plan to Omise
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "300000","currency": "${TH_CURRENCY}","installment" : {"period" : "10","interestType" : "MERCHANT","providerName" : "KTC"}}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": false,"returnUrl": "${returnUrl}","amount": "300000","currency": "${TH_CURRENCY}","installment" : {"period" : "10","interestType" : "MERCHANT","providerName" : "KTC"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Fetch Property From Response    .authorizeUri    OMISE_AUTHORIZE_URI
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    PENDING
    Response Should Contain Property With Value    authorizeUri    ${OMISE_AUTHORIZE_URI}
    # Step2: Open browser and confirm installment from omise response (authorizeUri)
    Select Credit Card Installment Confirm Option    Success
    # Step3: Verify the transaction do the authorize success in OMISE >> add sleep thead for waiting api callback process
    Sleep    0.5s
    Get Specific Detail Merchant Payment Transaction    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    status    SETTLED
    Response Should Contain Property With Value    gatewayType    OMISE
    Response Should Contain Property Value Include In List    activities..action    ${3d_sucure_auto_capture_authorized_success}
    # Step4: Not allow to do the void transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Payment Account    ${TRANSACTION_ID}
    ...    {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","metadata": {"BFF-VOID": "VOID-${TRANSACTION_REFERENCE}","BFF-TESTCASE": "${bff_remark}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..code    0_transaction_not_allow_to_void
    Response Should Contain Property With Value    errors..message    SETTLED - Transaction is not allowed to void
    # Step5: Allow to do the refund successful
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": "300000"}
    Post Payment Refund By Payment Account    ${TRANSACTION_ID}
    ...    {"clientRefId": "REFUND-${TRANSACTION_REFERENCE}","amount": "300000","metadata": {"BFF-REFUND": "REFUND-${TRANSACTION_REFERENCE}","BFF-TESTCASE": "${bff_remark}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REFUND-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    REFUND
    Response Should Contain Property With Value    transaction.paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    # Step6. Verify Transaction in Elastic search Should Not Sync
    Verify Elastic Search Transaction Should Not Sync    source_transaction_id:${TRANSACTION_ID}

TC_O2O_25754
    [Documentation]    [Non3D Secure][manual capture]User can do the charge and void successful
    [Tags]    High    Regression    E2E    Sanity    Payment
    #Step1: Send request to charge with Non-3DSecure and manual capture to Omise
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": true,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","metadata": {"BFF-CHARGE": "E2E-${TRANSACTION_REFERENCE}","BFF-REMARK": "${bff_remark}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Response Should Contain Property With Value    transaction.status    AUTHORIZED
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Not Contain Property    authorizeUri
    # Step2: Send request to do the manual capture in OMISE
    Post Payment Capture Charge    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    CAPTURE_E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Not Contain Property    authorizeUri
    # Step3: Verify the transaction after do the manual capture success in OMISE >> add sleep thead for pending callback process
    Sleep    0.5s
    Get Specific Detail Merchant Payment Transaction    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    status    APPROVE
    Response Should Contain Property Value Include In List    activities..action    ${Non3d_sucure_manual_capture_capture_success}
    # Step4: Send request to do the void transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Payment Account    ${TRANSACTION_ID}
    ...    {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","metadata": {"BFF-VOID": "VOID-${TRANSACTION_REFERENCE}","BFF-TESTCASE": "${bff_remark}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    transaction.status    VOID
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    # Step5. Verify Transaction in Elastic search Should Not Sync
    Verify Elastic Search Transaction Should Not Sync    source_transaction_id:${TRANSACTION_ID}

TC_O2O_25755
    [Documentation]    [Non3D Secure][auto capture]User can do the charge and void successful
    [Tags]    High    Regression    E2E    Sanity    Payment
    #Step1: Send request to charge with Non-3DSecure and auto capture to Omise
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${omise_valid_visa_card}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Post Payment Charge With Credit Card By Payment Account
    ...    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": false,"amount": "${amount}","currency": "${TH_CURRENCY}","cardToken": "${OMISE_PAYMENT_TOKEN}","metadata": {"BFF-CHARGE": "E2E-${TRANSACTION_REFERENCE}","BFF-REMARK": "${bff_remark}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With Value    transaction.pan    XXXXXXXXXXXX1111
    Response Should Not Contain Property    authorizeUri
    # Step2: Verify the transaction after do the manual capture success in OMISE
    Sleep    0.5s
    Get Specific Detail Merchant Payment Transaction    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    status    APPROVE
    Response Should Contain Property With Value    activities..action    CHARGE
    # Step4: Send request to do the void transaction
    Generate Transaction Reference    ${external_ref_id_length}
    Post Encrypt Message With KMS
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Payment Account    ${TRANSACTION_ID}
    ...    {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","metadata": {"BFF-VOID": "VOID-${TRANSACTION_REFERENCE}","BFF-TESTCASE": "${bff_remark}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    transaction.status    VOID
    Response Should Contain Property With Value    transaction.gatewayType    OMISE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    # Step5. Verify Transaction in Elastic search Should Not Sync
    Verify Elastic Search Transaction Should Not Sync    source_transaction_id:${TRANSACTION_ID}
