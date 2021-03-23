*** Settings ***
Documentation    [TrueDigitalCard: On][P2P] User can create payment void and get the
...              transaction status with payment method =Wallet and TRUECARD via OTP Verification
Resource        ../../../resources/init.robot
Resource        ../../../keywords/payment/wallet_otp_resource_keywords.robot
Resource        ../../../keywords/payment/payment_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.write,payment.payment.read

*** Variable ***
${otp_code}   111111
${amount}   100
${name}   automate test payment online

*** Test Case ***
TC_O2O_12950
    [Documentation]   [TrueDigitalCard: On][P2P] User can create payment void and get the transaction status
    ...               with payment method = Wallet via OTP Verification
    [Tags]    High    Regression    Sanity    Smoke    E2E    payment
    Post Request Otp Of Truemoney Wallet   { "mobile": "${TMN_WALLET_MOBILE}","type": "mobile"}
    Response Correct Code    ${SUCCESS_CODE}
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet
    Post Verify Otp Of Truemoney Wallet    { "otpCode": "${otp_code}", "otpRef": "${OTP_REF}", "authCode": "${AUTH_CODE}", "mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    expiresIn       3600
    Get Access Token of Truemoney Wallet
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "${TH_CURRENCY}", "description": "${name}", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name       ${name}
    Response Should Contain Property With Value    mobile     ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount     ${amount}
    Response Should Contain Property With Value    currency   thb
    Response Should Contain Property With Value    paymentMethod     WALLET
    Response Should Contain Property With Value    status              SUCCESS
    Get Transaction Reference Id
    Post Payment Cancel    { "txRefId": "${TRANSACTION_REF_ID}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    txRefId      ${TRANSACTION_REF_ID}
    Response Should Contain Property With Value    amount       ${amount}
    Response Should Contain Property With Value    currency     thb
    Response Should Contain Property With Value    paymentMethod   WALLET
    Response Should Contain Property With Value    status          SUCCESS
    Get Payment Query   ${TRANSACTION_REF_ID}
    Response Should Contain Property With Value    status.code     success
    Response Should Contain Property With Value    status.message  Success
    Response Should Contain Property With Value    data.merchant   ${TMN_MERCHANT_ID}
    Response Should Contain Property With Value    data.amount     ${${amount}}
    Response Should Contain Property With Value    data.currency   ${TH_CURRENCY}
    Response Should Contain Property With Value    data.status     succeeded
    Response Should Contain Property With Value    data.response_code   success
    Response Should Contain Property With Value    data.response_message  Success
    Response Should Contain Property With String Value    data.payment_id
    Response Should Contain Property With Value    data.isv_payment_ref    ${TRANSACTION_REF_ID}
    Response Should Contain Property With String Value    data.isv
    Response Should Contain Property With String Value    data.customer
    Response Should Contain Property With Value    data.refunded     ${${amount}}
    Response Should Contain Property With String Value    data.created
    Response Should Contain Property With String Value    data.updated
    Response Should Contain Property With String Value    data.metadata.partner_shop_name
    Response Should Contain Property With Value    data.metadata.description    ${name}
    Response Should Contain Property With String Value    data.metadata.client_id
    Response Should Contain Property With String Value    data.metadata.shop_id
    Response Should Contain Property With String Value    data.metadata.partner_shop_id
    Response Should Contain Property With Value    data.metadata.user_mobile     0000000000
    Response Should Contain Property With String Value    data.metadata.orion_channel
    Response Should Contain Property With String Value    data.metadata.terminal_id
    Response Should Contain Property With String Value    data.metadata.payment_code
    Response Should Contain Property With String Value    .refunds..refund_id
    Response Should Contain Property With Value    .refunds..isv_refund_ref    ${TRANSACTION_REF_ID}C
    Response Should Contain Property With Value    .refunds..amount  ${${amount}}
    Response Should Contain Property With String Value    .refunds..created
    Response Should Contain Property With Value    .refunds..status   succeeded
    Response Should Contain Property With Value    .refunds..response_code   success
    Response Should Contain Property With Value    .refunds..response_message  Success

TC_O2O_12951
    [Documentation]   [TrueDigitalCard: On][P2P] User can create payment void and get the transaction status
    ...               with payment method = TRUECARD via OTP Verification"
    [Tags]    High    Regression    Sanity    Smoke    E2E    payment
    Post Request Otp Of Truemoney Wallet   { "truecard": "${TRUE_DIGITAL_CARD}","type": "truecard"}
    Response Correct Code    ${SUCCESS_CODE}
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "${TH_CURRENCY}", "description": "${name}", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name       ${name}
    Response Should Contain Property With Value    mobile     ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount     ${amount}
    Response Should Contain Property With Value    currency   thb
    Response Should Contain Property With Value    paymentMethod       TRUECARD
    Response Should Contain Property With Value    status              SUCCESS
    Get Transaction Reference Id
    Post Payment Cancel    { "txRefId": "${TRANSACTION_REF_ID}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    txRefId      ${TRANSACTION_REF_ID}
    Response Should Contain Property With Value    amount       ${amount}
    Response Should Contain Property With Value    currency     thb
    Response Should Contain Property With Value    paymentMethod   TRUECARD
    Response Should Contain Property With Value    status          SUCCESS
    Get Payment Query   ${TRANSACTION_REF_ID}
    Response Should Contain Property With Value    status.code     success
    Response Should Contain Property With Value    status.message  Success
    Response Should Contain Property With Value    data.merchant   ${TMN_MERCHANT_ID}
    Response Should Contain Property With Value    data.amount     ${${amount}}
    Response Should Contain Property With Value    data.currency   ${TH_CURRENCY}
    Response Should Contain Property With Value    data.status     succeeded
    Response Should Contain Property With Value    data.response_code   success
    Response Should Contain Property With Value    data.response_message  Success
    Response Should Contain Property With String Value    data.payment_id
    Response Should Contain Property With Value    data.isv_payment_ref    ${TRANSACTION_REF_ID}
    Response Should Contain Property With String Value    data.isv
    Response Should Contain Property With String Value    data.customer
    Response Should Contain Property With Value    data.refunded     ${${amount}}
    Response Should Contain Property With String Value    data.created
    Response Should Contain Property With String Value    data.updated
    Response Should Contain Property With String Value    data.metadata.partner_shop_name
    Response Should Contain Property With Value    data.metadata.description    ${name}
    Response Should Contain Property With String Value    data.metadata.client_id
    Response Should Contain Property With String Value    data.metadata.shop_id
    Response Should Contain Property With String Value    data.metadata.partner_shop_id
    Response Should Contain Property With Value    data.metadata.user_mobile     0000000000
    Response Should Contain Property With String Value    data.metadata.orion_channel
    Response Should Contain Property With String Value    data.metadata.terminal_id
    Response Should Contain Property With String Value    data.metadata.payment_code
    Response Should Contain Property With String Value    .refunds..refund_id
    Response Should Contain Property With Value    .refunds..isv_refund_ref    ${TRANSACTION_REF_ID}C
    Response Should Contain Property With Value    .refunds..amount  ${${amount}}
    Response Should Contain Property With String Value    .refunds..created
    Response Should Contain Property With Value    .refunds..status   succeeded
    Response Should Contain Property With Value    .refunds..response_code   success
    Response Should Contain Property With Value    .refunds..response_message  Success
