*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot

*** Keywords ***
Get All Messages
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/messages    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Message Item Detail
    [Arguments]    ${message_id} 
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/messages/${message_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Create Message
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /notification/api/messages    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Message Status
    [Arguments]    ${message_id}    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /notification/api/messages/${message_id}/update-status    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Test data preparation
Get Message Id Test Data
    [Arguments]    ${filter}=${EMPTY}
    Get All Messages    ${filter}
    ${TEST_DATA_MESSAGE_ID}=    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${TEST_DATA_MESSAGE_ID}