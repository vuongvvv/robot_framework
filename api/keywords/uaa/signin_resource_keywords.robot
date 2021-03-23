*** Settings ***
Library    String    
Resource    ../common/string_common.robot
Resource    ../common/json_common.robot

*** Keywords ***
Post Generate Signin Sms Otp
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/signin/sms-otp    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Validate Sms Signin Otp
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/signin/sms-otp/validation    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Fetch Reference And Transaction Id From Egg Digital
    ${TEST_DATA_REFERENCE_ID_FROM_EGG_DIGITAL}=    Get Property Value From Json By Index    reference    0    
    ${TEST_DATA_TRANSACTION_ID_FROM_EGG_DIGITAL}=    Get Property Value From Json By Index    transactionId    0
    Set Test Variable    ${TEST_DATA_REFERENCE_ID_FROM_EGG_DIGITAL}
    Set Test Variable    ${TEST_DATA_TRANSACTION_ID_FROM_EGG_DIGITAL}