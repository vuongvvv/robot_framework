*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${endpoint_burn}               /crm-ms-truepoint-api/v1/burn
${endpoint_rollback}           /crm-ms-truepoint-api/v1/rollback


*** Keywords ***
Post Burn Point
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${endpoint_burn}    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Collect Promotion Code
    ${promotion_code}=     Set Variable     ${RESP.json()['data']['moreinfo']['promotion_code']}
    ${void_txref}=    Set Variable    ${ID}
    Set Test Variable    ${PROMOTION_CODE}
    Set Test Variable    ${VOID_TXREF}

Generate ID
    ${Id} =    Get Time    format=epoch
    Set Test Variable    ${ID}

Post Void Burn
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${endpoint_rollback}    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
