*** Settings ***
Documentation    Tests to verify that payment transaction should be injection to elastic search api works correctly

Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/payment_transaction/merchant_payment_resource_keywords.robot
Resource    ../../../api/keywords/payment_transaction/raw_payment_transaction_resource_keywords.robot
Resource    ../../../api/keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../api/keywords/edc_app_service/edc_payment_keywords.robot
Resource    ../../../api/keywords/payment/wallet_otp_resource_keywords.robot
Resource    ../../../api/keywords/payment/payment_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment
Test Teardown     Delete All Sessions
#Require UAA client scope: paymentTx.read,paymentRawTx.create,payment.payment.write

*** Variables ***
${valid_otp_code}    111111
@{transaction_type_list}    CHARGE    CANCEL

*** Test Cases ***
TC_O2O_15159
    [Documentation]    [Consumer] Verify elastic mapping when even type is P2P for success transaction
    [Tags]    Regression    High    Smoke    Sanity    E2E
    #Step1 Create Transaction
    Generate Transaction Reference    20
    Generate Transaction Date With Format    -7 hours    %Y-%m-%dT%H:%M:%S.%fZ
    Post Create Raw Payment Transaction    { "tmnId": "tmn.10000000022", "transactionReference": "${TRANSACTION_REFERENCE}", "customerMobileNumber": "${CUSTOMER_MOBILE}", "transactionDate": "${TRANSACTION_DATE}", "customerThaiIdHash": "7b443f8409f4914057eb44f962", "merchantMobileNumber": "${MERCHANT_MOBILE}", "paymentData": "Automate for verify TrueTouch data sharing (P2P)", "eventType": "P2P", "moneyAmount": 3000, "kycVerifyStatus": true }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body
    #Step2 Verify The Information On Elastic Search
    Get Search Transaction    ${TRANSACTION_REFERENCE}
    Response Should Contain Property With String Value    .transactionDate
    Response Should Contain Property With Value    .amount    ${3000}
    Response Should Contain Property With Null Value    .payee.merchantId
    Response Should Contain Property With Null Value    .payee.outletId
    Response Should Contain Property With Null Value    .payee.terminalId
    Response Should Contain Property With Value    .payee.mobile    ${MERCHANT_MOBILE}
    Response Should Contain Property With Value    .payer.mobile    ${CUSTOMER_MOBILE}
    Response Should Contain Property With Value    .paymentStatus    SUCCESS
    Response Should Contain Property With Null Value    .paymentStatusDescription
    Response Should Contain Property With Null Value    .sourceTransactionId
    Response Should Contain Property With Value    .transactionType    CHARGE
    Response Should Contain Property With Value    .paymentChannel    QR
    Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    QR
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.qrTagId    29

TC_O2O_15160
    [Documentation]    [Consumer] Verify elastic mapping when even type is P2M for success transaction
    [Tags]    Regression    High    Smoke    Sanity    E2E
    #Step1 Create Transaction
    Generate Transaction Reference    20
    Generate Transaction Date With Format    -7 hours    %Y-%m-%dT%H:%M:%S.%fZ
    Post Create Raw Payment Transaction    {"moneyAmount": 50100,"application": "payment","eventType": "P2M","paymentData": "Automate for verify TrueTouch data sharing (P2M)","merchantMobileNumber": null,"customerMobileNumber": "${CUSTOMER_MOBILE}","customerThaiIdHash": "456","transactionDate": "${TRANSACTION_DATE}","transactionDateTime": "${TRANSACTION_DATE}","transactionReference": "${TRANSACTION_REFERENCE}","trueCard": "cardNumber","merchant": {"tmnMerchantId": "","tmnOutletId": "","tmnTerminalId": "${TMN_TERMINAL_ID}"}}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body
    #Step2 Verify The Information On Elastic Search
    Get Search Transaction    ${TRANSACTION_REFERENCE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionDate
    Response Should Contain Property With Value    .amount    ${50100}
    Response Should Contain Property With String Value    .payee.merchantId
    Response Should Contain Property With String Value    .payee.outletId
    Response Should Contain Property With String Value   .payee.terminalId
    Response Should Contain Property With Null Value    .payee.mobile
    Response Should Contain Property With Value    .payer.mobile    ${CUSTOMER_MOBILE}
    Response Should Contain Property With Value    .paymentStatus    SUCCESS
    Response Should Contain Property With Null Value    .paymentStatusDescription
    Response Should Contain Property With Null Value    .sourceTransactionId
    Response Should Contain Property With Value    .transactionType    CHARGE
    Response Should Contain Property With Value    .paymentChannel    QR
    Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    QR
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.qrTagId    39

TC_O2O_15161
     [Documentation]    [Consumer] Verify elastic mapping when even type is OTHER (payment online - WALLET) for success transaction
     [Tags]    Regression    High    Smoke    Sanity   E2E
     #Step 1-2: Request & Verity Otp Of Truemoney Wallet
     Post Request Otp Of Truemoney Wallet    { "mobile": "${TMN_WALLET_MOBILE}" }
     Response Correct Code    ${SUCCESS_CODE}
     Get Otp Reference Of Truemoney Wallet
     Get Authorized Code Of Truemoney Wallet
     Post Verify Otp Of Truemoney Wallet    { "otpCode": "${valid_otp_code}", "otpRef": "${OTP_REF}", "authCode": "${AUTH_CODE}", "mobile": "${TMN_WALLET_MOBILE}" }
     Response Correct Code    ${SUCCESS_CODE}
     Get Access Token of Truemoney Wallet
     #Step 3: Post For Create Payment And Verify Response
     Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "5100", "channel": "POS", "currency": "${TH_CURRENCY}", "description": "Verify elastic mapping for payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "automation", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    paymentMethod    WALLET
     Response Should Contain Property With Value    status    SUCCESS
     Get Transaction Reference Id
     # Step 4: Verify The Information On Elastic Search After Charge Success.
     Get Search Transaction    ${TRANSACTION_REF_ID}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    .transactionDate
     Response Should Contain Property With Value    .amount    ${5100}
     Response Should Contain Property With Value    .payee.merchantId    ${BRAND_ID}
     Response Should Contain Property With Value    .payee.outletId    ${BRANCH_ID}
     Response Should Contain Property With Value    .payee.terminalId    ${TERMINAL_ID}
     Response Should Contain Property With Null Value    .payee.mobile
     Response Should Contain Property With Value    .payer.mobile    ${TMN_WALLET_MOBILE}
     Response Should Contain Property With Value    .paymentStatus    SUCCESS
     Response Should Contain Property With Empty Value    .paymentStatusDescription
     Response Should Contain Property With Null Value    .sourceTransactionId
     Response Should Contain Property With Value    .transactionType    CHARGE
     Response Should Contain Property With Value    .paymentChannel    POS
     Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    AUTH_CODE
     Response Should Not Contain Property    .paymentMethod.digitalWallet.qrTagId
     # Step 5: Send Charge cancel with OTP Success
     Post Payment Cancel    { "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "txRefId": "${TRANSACTION_REF_ID}" }
     Response Correct Code    ${SUCCESS_CODE}
     # Step 6: Verify The Information On Elastic Search After Charge Cancel Success.
     Get Search Transaction After Cancel Transaction Success    ${TRANSACTION_REF_ID}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    .transactionDate
     Response Should Contain Property With Value    .amount    ${5100}
     Response Should Contain Property With Value    .payee.merchantId    ${BRAND_ID}
     Response Should Contain Property With Value    .payee.outletId    ${BRANCH_ID}
     Response Should Contain Property With Value    .payee.terminalId    ${TERMINAL_ID}
     Response Should Contain Property With Null Value    .payee.mobile
     Response Should Contain Property With Value    .payer.mobile    ${TMN_WALLET_MOBILE}
     Response Should Contain Property With Value    .paymentStatus    SUCCESS
     Response Should Contain Property With Empty Value    .paymentStatusDescription
     Response Should Contain Property With Value    .sourceTransactionId    ${TRANSACTION_REF_ID}C
     Response Should Contain All Property Values Include In List    .transactionType    ${transaction_type_list}
     Response Should Contain Property With Value    .paymentChannel    POS
     Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    AUTH_CODE
     Response Should Not Contain Property    .paymentMethod.digitalWallet.qrTagId

TC_O2O_15162
     [Documentation]    [Consumer] Verify elastic mapping when even type is OTHER (payment online - TRUECARD) for success transaction
     [Tags]    Regression    High    Smoke    Sanity    E2E
     # Step 1: Request OTP Of Truemoney Wallet (truecard)
     Post Request Otp Of Truecard    { "truecard": "${TRUE_DIGITAL_CARD}" }
     Response Correct Code    ${SUCCESS_CODE}
     Get Otp Reference Of Truecard
     Get Authorized Code Of Truecard
     Get Mobile Number Of Truecard
     # Step 2: Verify OTP and Charge Success
     Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "5010", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "E2E Automation to verify elastic search", "transaction_channel": "EDC_ANDROID" }
     Response Correct Code    ${SUCCESS_CODE}
     Get True Card Transaction Reference Id
     Get Trace Id Of Charge By Truecard
     # Step 3: Verify The Information On Elastic Search After Charge Success.
     Get Search Transaction    ${TRUE_CARD_TX_REF}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    .transactionDate
     Response Should Contain Property With Value    .amount    ${5010}
     Response Should Contain Property With Value    .payee.merchantId    ${BRAND_ID}
     Response Should Contain Property With Value    .payee.outletId    ${BRANCH_ID}
     Response Should Contain Property With Value    .payee.terminalId    ${TERMINAL_ID}
     Response Should Contain Property With Null Value    .payee.mobile
     Response Should Contain Property With Value    .payer.mobile    ${TRUE_CARD_MOBILE_NO}
     Response Should Contain Property With Value    .paymentStatus    SUCCESS
     Response Should Contain Property With Empty Value    .paymentStatusDescription
     Response Should Contain Property With Null Value    .sourceTransactionId
     Response Should Contain Property With Value    .transactionType    CHARGE
     Response Should Contain Property With Value    .paymentChannel    EDC
     Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    TRUECARD
     Response Should Not Contain Property    .paymentMethod.digitalWallet.qrTagId
     # Step 4: Send Charge cancel Success
     Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
     Response Correct Code    ${SUCCESS_CODE}
     # Step 5: Verify The Information On Elastic Search After Charge Cancel Success.
     Get Search Transaction After Cancel Transaction Success    ${TRUE_CARD_TX_REF}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    .transactionDate
     Response Should Contain Property With Value    .amount    ${5010}
     Response Should Contain Property With Value    .payee.merchantId    ${BRAND_ID}
     Response Should Contain Property With Value    .payee.outletId    ${BRANCH_ID}
     Response Should Contain Property With Value    .payee.terminalId    ${TERMINAL_ID}
     Response Should Contain Property With Null Value    .payee.mobile
     Response Should Contain Property With Value    .payer.mobile    ${TRUE_CARD_MOBILE_NO}
     Response Should Contain Property With Value    .paymentStatus    SUCCESS
     Response Should Contain Property With Empty Value    .paymentStatusDescription
     Response Should Contain Property With Value    .sourceTransactionId    ${TRUE_CARD_TX_REF}C
     Response Should Contain All Property Values Include In List    .transactionType    ${transaction_type_list}
     Response Should Contain Property With Value    .paymentChannel    EDC
     Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
     Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    TRUECARD
     Response Should Not Contain Property    .paymentMethod.digitalWallet.qrTagId
