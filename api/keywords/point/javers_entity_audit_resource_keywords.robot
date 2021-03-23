*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot

*** Keywords ***
Get Audited Entities
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /point/api/audits/entity/all    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Changes
    [Arguments]    ${entity_type}    ${limit}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /point/api/audits/entity/changes    params=entityType=${entity_type}&limit=${limit}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Prev Version
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /point/api/audits/entity/changes/version/previous    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Histories
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /point/api/audits/entity/histories    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Test data preparation
Prepare Entity Id
    [Arguments]    ${entity_type}
    Get Changes    ${entity_type}    10
    ${ENTITY_ID}=    Get Property Value From Json By Index    .entityId    0
    Set Test Variable    ${ENTITY_ID}