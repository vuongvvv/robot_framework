*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Post Request Otp Of Truemoney Wallet
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/wallet/otp    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Verify Otp Of Truemoney Wallet
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/wallet/otp/verify    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Otp Reference Of Truemoney Wallet
    ${OTP_REF}=    Get Property Value From Json By Index    .otpRef    0
    Set Test Variable    ${OTP_REF}

Get Authorized Code Of Truemoney Wallet
    ${AUTH_CODE}=    Get Property Value From Json By Index    .authCode    0
    Set Test Variable    ${AUTH_CODE}

Get Access Token of Truemoney Wallet
    ${TMN_TOKEN}=    Get Property Value From Json By Index    .accessToken    0
    Set Test Variable    ${TMN_TOKEN}
