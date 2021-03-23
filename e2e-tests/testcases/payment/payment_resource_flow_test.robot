*** Settings ***
Documentation    Tests to verify All payment online api with OTP verification works correctly

Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/payment/wallet_otp_resource_keywords.robot
Resource    ../../../api/keywords/payment/payment_resource_keywords.robot
Resource    ../../../api/keywords/payment/transaction_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    payment.payment.write,payment.payment.read
Test Teardown     Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${valid_otp_code}    111111
${name}    E2E test payment online
${amount}    102

*** Test Cases ***
TC_O2O_11517
    [Documentation]    [Payment][E2E][P2P] User can create payment ,void and get the transaction status with payment method =Wallet via OTP Verification
    [Tags]    High    Regression    E2E    Sanity    Smoke
    #Step 1-2: Request & Verity Otp Of Truemoney Wallet
    Post Request Otp Of Truemoney Wallet    { "mobile": "${TMN_WALLET_MOBILE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    linkingAgreement    https://www.truemoney.com/terms-conditions/?utm_source=inapp&online_merchant
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet
    Post Verify Otp Of Truemoney Wallet    { "otpCode": "${valid_otp_code}", "otpRef": "${OTP_REF}", "authCode": "${AUTH_CODE}", "mobile": "${TMN_WALLET_MOBILE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Get Access Token of Truemoney Wallet
    #Step 3: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    ${name}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    WALLET
    Response Should Contain Property With Value    status    SUCCESS
    Get Transaction Reference Id
    Get Charge Payment Id
    #Step 4: Post For Payment Cancel And Verify Response
    Post Payment Cancel    { "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "txRefId": "${TRANSACTION_REF_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    txRefId    ${TRANSACTION_REF_ID}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    WALLET
    Response Should Contain Property With Value    status    SUCCESS
    Get Charge Cancel Payment Id
    #Step 5: Get Payment Status By Transaction Reference ID
    Get Payment Query    ${TRANSACTION_REF_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code        success
    Response Should Contain Property With Value    status.message     Success
    Response Should Contain Property With Value    data.payment_id    ${CHARGE_PAYMENT_ID}
    Response Should Contain Property With Value    data.isv_payment_ref     ${TRANSACTION_REF_ID}
    Response Should Contain Property With Value    data.amount        ${${amount}}
    Response Should Contain Property With Value    data.currency      THB
    Response Should Contain Property With Value    data.status        succeeded
    Response Should Contain Property With Value    data.response_code       success
    Response Should Contain Property With Value    data.response_message    Success
    Response Should Contain Property With Value    data.refunded      ${${amount}}
    Response Should Contain Property With String Value    data.created
    Response Should Contain Property With String Value    data.updated
    Response Should Contain Property With Value    data.metadata.description    payment online
    Response Should Contain Property With Value    data.metadata.partner_shop_id    ${BRANCH_ID}
    Response Should Contain Property With String Value    data.metadata.client_id
    Response Should Contain Property With String Value    data.metadata.shop_id
    Response Should Contain Property With String Value    data.metadata.partner_shop_id
    Response Should Contain Property With Value    data.metadata.user_mobile    0000000000
    Response Should Contain Property With String Value    data.metadata.orion_channel
    Response Should Contain Property With String Value    data.metadata.terminal_id
    Response Should Contain Property With String Value    data.metadata.payment_code
    Response Should Contain Property With Value    data.refunds..refund_id    ${CHARGE_CANCEL_PAYMENT_ID}
    Response Should Contain Property With Value    data.refunds..isv_refund_ref    ${TRANSACTION_REF_ID}C
    Response Should Contain Property With Value    data.refunds..amount    ${${amount}}
    Response Should Contain Property With String Value    data.refunds..created
    Response Should Contain Property With Value    data.refunds..status    succeeded
    Response Should Contain Property With Value    data.refunds..response_code    success
    Response Should Contain Property With Value    data.refunds..response_message    Success
