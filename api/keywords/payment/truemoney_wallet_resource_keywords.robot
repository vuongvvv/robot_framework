*** Settings ***
Resource    ../common/api_common.robot
Resource    ../payment/wallet_otp_resource_keywords.robot

*** Variables ***
${valid_otp_code}    111111
${external_ref_id_length}    14
${amount}    45001
${invalid_auth_id}    94f15cc80fc34f059a14f7b7a4ff8e88
${invalid_payment_code}    10046781318533
@{validate_amount_empty}    amount must not be empty    amount Amount is invalid.

*** Keywords ***
Post Request Otp From Truemoney Wallet
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/truemoney/request/otp    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Verify Otp From Truemoney Wallet
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/truemoney/verify/otp    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Charge With Truemoney Wallet
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/truemoney/payments    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Refund With Truemoney Wallet
    [Arguments]    ${transaction_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/truemoney/payments/${transaction_id}/refund    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post TrueMoney Request Get Balance
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/truemoney/wallets/balance    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Truemoney Wallet List
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/truemoney/wallets    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Truemoney Wallet List
    [Arguments]    ${auth_id}    ${data}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /payment/api/v1/truemoney/wallets/${auth_id}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Request Otp From Truemoney Wallet And Get Reference Information
    [Arguments]    ${trueyou_merchant}=${WALLET_MERCHANT_ID}    ${trueyou_outlet}=${WALLET_ACTIVE_OUTLET}
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${trueyou_merchant}","trueyouOutletId": "${trueyou_outlet}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet

Prepare Paymentcode For Charge Activity
    [Arguments]    ${trueyou_merchant}=${WALLET_MERCHANT_ID}    ${trueyou_outlet}=${WALLET_ACTIVE_OUTLET}
    Post Request Otp From Truemoney Wallet And Get Reference Information    ${trueyou_merchant}    ${trueyou_outlet}
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${trueyou_merchant}","trueyouOutletId": "${trueyou_outlet}","clientUsername": "AUTO_PREPARE","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Get PaymentCode From Truemoney

Prepare Auth Id For Charge Activity
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "AUTO_PREPARE","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Get Auth Id From Truemoney

Prepare The Charge Transaction For Refund
    Prepare Paymentcode For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "CHARGE-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "PREPARE CHARGE TRANSACTION STEP"}
    Response Correct Code    ${SUCCESS_CODE}
    Get Payment Charge Transaction Id

Get PaymentCode From Truemoney
    ${PAYMENT_CODE}=    Get Property Value From Json By Index    .paymentCode    0
    Set Test Variable    ${PAYMENT_CODE}

Get Accesstoken From Truemoney
    ${TMN_ACCESS_TOKEN}=    Get Property Value From Json By Index    .accessToken    0
    Set Test Variable    ${TMN_ACCESS_TOKEN}

Get Auth Id From Truemoney
    ${AUTH_ID}=    Get Property Value From Json By Index    .authId    0
    Set Test Variable    ${AUTH_ID}

Get Payment Charge Transaction Id
    ${TRANSACTION_ID}=    Get Property Value From Json By Index    .transaction.transactionId    0
    Set Test Variable    ${TRANSACTION_ID}
