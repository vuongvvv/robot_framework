*** Settings ***
Resource      ../common/api_common.robot

*** Variables ***
${forgot_password_otp}            /uaa/api/otp?
${forgot_password_verify_otp}     /uaa/api/account/reset-password/init/otp
${set_new_password_otp}           /uaa/api/account/reset-password/finish

*** Keywords ***
Request Forgot OTP
    [Arguments]             ${user_phone}
    ${RESP}=                Get Request        ${GATEWAY_SESSION}        ${forgot_password_otp}mobileNumber=${user_phone}&userExist=true
    Set Test Variable       ${RESP}

Verify Forgot OTP
    [Arguments]                     ${phone}             ${reference}       ${customer_otp}     ${transaction_id}
    &{headers}=                     Create Dictionary    Content-Type=application/json
    ${data}=                        Set Variable         {"mobileNumber": "${phone}","reference": "${reference}","customerOtp": "${customer_otp}","transactionId": "${transaction_id}"}
    ${RESP}=                        Post Request         ${GATEWAY_SESSION}        ${forgot_password_verify_otp}       data=${data}       headers=${headers}
    Set Test Variable               ${RESP}

Set New Password
    [Arguments]                     ${key}              ${password}
    &{headers}=                     Create Dictionary    Content-Type=application/json
    ${data}=                        Set Variable         {"key": "${key}","newPassword": "${password}"}
    ${RESP}=                        Post Request         ${GATEWAY_SESSION}        ${set_new_password_otp}       data=${data}       headers=${headers}
    Set Test Variable               ${RESP}
