*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot

*** Variables ***
${notification_producer_get_all_histories_url}    /notificationproducer/api/histories
${notification_producer_get_all_templates_url}    /notificationproducer/api/templates
${merchant_template_url}    /notificationproducer/api/merchant/templates
*** Keywords ***
Get All Histories
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${notification_producer_get_all_histories_url}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get History
    [Arguments]    ${history_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${notification_producer_get_all_histories_url}/${history_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Templates
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${notification_producer_get_all_templates_url}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Template
    [Arguments]    ${template_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${notification_producer_get_all_templates_url}/${template_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Create Merchant Template
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${merchant_template_url}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Merchant Template
    [Arguments]    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${merchant_template_url}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Template Status
    [Arguments]    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${notification_producer_get_all_templates_url}/status    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Prepare test data
Get History Id
    Get All Histories
    ${history_id_from_list}=    Get Property Value From Json By Index    .id    1
    Set Suite Variable    ${HISTORY_ID}    ${history_id_from_list}

Get Template Id
    [Arguments]    ${filter}=${EMPTY}
    Get All Templates    ${filter}&status.equals=ACTIVE
    ${template_response_api_status}    Run Keyword And Return Status    Response Should Be Empty
    Run Keyword If    ${template_response_api_status}==${True}    Get All Templates    ${filter}
    ${TEST_DATA_TEMPLATE_ID}=    Get Property Value From Json By Index    .id    0
    ${TEST_DATA_TEMPLATE_SENDERNAME}=    Get Property Value From Json By Index    .senderName    0
    ${TEST_DATA_TEMPLATE_TEMPLATE}=    Get Property Value From Json By Index    .template    0
    Set Suite Variable    ${TEST_DATA_TEMPLATE_ID}
    Set Suite Variable    ${TEST_DATA_TEMPLATE_SENDERNAME}
    Set Suite Variable    ${TEST_DATA_TEMPLATE_TEMPLATE}