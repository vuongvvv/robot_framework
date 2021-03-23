*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
Post Get Otp
    [Arguments]    ${mobile}    
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /weshop/api/payments/otp/request-otp    { "mobile": "${mobile}" }    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Post Verify Otp And Charge
    [Arguments]    ${order_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /weshop/api/payments/otp/orders/${order_id}/verify-otp-charge    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Fetch Otp Ref And Authorization Code
    ${OTP_REF}=    Get Property Value From Json By Index    otpRef
    ${AUTHORIZATIN_CODE}=    Get Property Value From Json By Index    authCode
    Set Test Variable    ${OTP_REF}
    Set Test Variable    ${AUTHORIZATIN_CODE}