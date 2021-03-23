*** Settings ***
Resource    ../common/json_common.robot

*** Variables ***
${bifrost_service}    bifrost

*** Keywords ***
Post Create Proxy
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/proxies    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Put Update Proxy
    [Arguments]    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/proxies    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Get All Proxies
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/proxies    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Get Proxy
    [Arguments]    ${proxy_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/proxies/${proxy_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Proxy
    [Arguments]    ${proxy_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/proxies/${proxy_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Fetch Proxy Id
    ${TEST_DATA_PROXY_ID}=    Get Property Value From Json By Index    id
    Set Test Variable    ${TEST_DATA_PROXY_ID}
    