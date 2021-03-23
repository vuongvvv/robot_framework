*** Variables ***
${rpp_config_endpoint}         /crm-ms-config-api/v1/config
${rpp_config_detail_endpoint}  /crm-ms-config-api/v1/config/detail

*** Keywords ***
Get All RPP Config
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    ${rpp_config_endpoint}        headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Get RPP Config Detail
    [Arguments]     ${params}
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    ${rpp_config_detail_endpoint}     params=${params}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Add RPP Config
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${rpp_config_endpoint}    data=${request_data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Update RPP Config
    [Arguments]     ${id}    ${request_data}
    ${RESP}=      Put Request     ${RPP_GATEWAY_SESSION}    ${rpp_config_endpoint}/${id}    data=${request_data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Delete RPP Config
    [Arguments]     ${id}
    ${RESP}=      Delete Request     ${RPP_GATEWAY_SESSION}    ${rpp_config_endpoint}/${id}    headers=&{RPP_GATEWAY_HEADERS}

Get RPP Config Id
    ${RPP_CONFIG_ID}    Set Variable     ${Resp.json()['data']['id']}
    Set Test Variable    ${RPP_CONFIG_ID} 

Create Param to get
    [Arguments]    ${content_type}    ${content_id}    ${key}
    ${params} =    Create Dictionary
    ...  content_type=${content_type}
    ...  content_id=${content_id} 
    ...  key=${key}
    Set Test Variable    ${params} 

Create Params to get
    [Arguments]    ${content_type}    ${content_id}    ${key}    ${configs}
    ${mock_config} =    Create Dictionary
    ...  key_1=${configs}
    ${params} =    Create Dictionary
    ...  content_type=${content_type}
    ...  content_id=${content_id}
    ...  key=${key}
    ...  configs=${mock_config}
    Set Test Variable    ${params} 