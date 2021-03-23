*** Settings ***
Library    String    
Resource    ../common/string_common.robot

*** Keywords ***
Post Create Sms Otp Configuration
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/configurations/sms-otp    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Sms Otp Configuration
    [Arguments]    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /uaa/api/configurations/sms-otp    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Data preparation
Fetch Configuration Id From Response Body
    ${TEST_DATA_CONFIGURATION_ID}=    json_common.Get Property Value From Json By Index    .id    0
    BuiltIn.Set Test Variable    ${TEST_DATA_CONFIGURATION_ID}

Set Non Existing Line Signin Configuration
    ${NON_EXISTING_CONFIGURATION_ID}=    Random Unique String By Epoch Datetime
    Set Test Variable    ${NON_EXISTING_CONFIGURATION_ID}

Generate Random Line Channel Id
    ${RANDOM_CHANNEL_ID}=    Get Random Strings    10    [NUMBERS]
    Set Test Variable    ${RANDOM_CHANNEL_ID}

Post Create Line Signin Configuration
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/configurations/line-signin    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Line Signin Configuration
    [Arguments]    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /uaa/api/configurations/line-signin    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}