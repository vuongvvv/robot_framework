*** Settings ***
Resource    ../common/api_common.robot
Resource    wallet_otp_resource_keywords.robot

*** Variables ***
${payment_url}    /payment/api/charge

*** Keywords ***
Post Payment Charge
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${payment_url}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Payment Query
    [Arguments]    ${transaction_reference_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/query?txRefId=${transaction_reference_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Payment Cancel
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${payment_url}/cancel    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Transaction Reference Id
    ${TRANSACTION_REF_ID}=    Get Property Value From Json By Index    .txRefId    0
    Set Test Variable    ${TRANSACTION_REF_ID}

Get Charge Payment Id
    ${CHARGE_PAYMENT_ID}=    Get Property Value From Json By Index    .paymentId    0
    Set Test Variable    ${CHARGE_PAYMENT_ID}

Get Charge Cancel Payment Id
    ${CHARGE_CANCEL_PAYMENT_ID}=    Get Property Value From Json By Index    .paymentId    0
    Set Test Variable    ${CHARGE_CANCEL_PAYMENT_ID}

Request Otp And Verify Otp
    [Arguments]    ${valid_phone_number}    ${valid_otp_code}
    Post Request Otp Of Truemoney Wallet    { "mobile": "${valid_phone_number}" }
    Response Correct Code    ${SUCCESS_CODE}
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet
    Post Verify Otp Of Truemoney Wallet    { "otpCode": "${valid_otp_code}", "otpRef": "${OTP_REF}", "authCode": "${AUTH_CODE}", "mobile": "${valid_phone_number}" }
    Response Correct Code    ${SUCCESS_CODE}
    Get Access Token of Truemoney Wallet

Request Otp By Truecard And Get Reference Information
    [Arguments]    ${valid_truecard}    ${valid_otp_code}
    Post Request Otp Of Truemoney Wallet    { "truecard": "${valid_truecard}","type": "truecard" }
    Response Correct Code    ${SUCCESS_CODE}
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet
