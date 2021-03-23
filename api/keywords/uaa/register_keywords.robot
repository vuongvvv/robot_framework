*** Settings ***
Resource            ../common/api_common.robot

*** Variables ***
${activate_path}                    /activate
${register_path}                    /uaa/api/register

*** Keywords ***
Send OTP
    [Arguments]                     ${user_phone}
    ${RESP}=                        Get Request             ${GATEWAY_SESSION}                   ${register_path}/otp?mobileNumber=${user_phone}
    Set Test Variable               ${RESP}

Check OTP
    [Arguments]                     ${phone}             ${reference}       ${customer_otp}     ${transaction_id}
    &{headers}=                     Create Dictionary       Content-Type=application/json
    ${data}=                        Set Variable            {"mobileNumber": "${phone}","reference": "${reference}","customerOtp": "${customer_otp}","transactionId": "${transaction_id}"}
    ${RESP}=                        Post Request            ${GATEWAY_SESSION}              ${register_path}${activate_path}           data=${data}       headers=${headers}
    Set Test Variable               ${RESP}

Create Account
    [Arguments]                     ${login}        ${mobile}        ${password}        ${lang}
    &{headers}=                     Create Dictionary               Content-Type=application/json
    ${data}=                        Set Variable                    {"login" : "${login}", "mobile": "${mobile}", "password": "${password}", "langKey": "${lang}"}
    ${RESP}=                        Post Request                    ${GATEWAY_SESSION}              ${register_path}           data=${data}       headers=${headers}
    Set Test Variable               ${RESP}
