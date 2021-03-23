*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot

*** Variables ***
${sms_message_url}    /notification/api/sms
*** Keywords ***
Get All SMS Messages
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${sms_message_url}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}

Get SMS Message
    [Arguments]    ${message_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${sms_message_url}/${message_id}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Create SMS Message
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /notification/api/sms    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Prepare test data
Get Message Id
    Get All SMS Messages
    ${message_id_from_list}=    Get Property Value From Json By Index    .id    0
    Set Suite Variable    ${MESSAGE_ID}    ${message_id_from_list}

Generate External Transaction Reference
    [Arguments]    ${length}=${255}
    ${random_string}=    Generate Random String    ${length}
    Set Suite Variable    ${EXTERNAL_TRANSACTION_REFERENCE}    ${random_string}