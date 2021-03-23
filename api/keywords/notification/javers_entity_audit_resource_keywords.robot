*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Get Audited Entities
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/audits/entity/all    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Changes
    [Arguments]    ${entity_type}    ${limit}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/audits/entity/changes    params=entityType=${entity_type}&limit=${limit}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Prev Version
    [Arguments]    ${commit_version}    ${entity_id}    ${entity_type}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/audits/entity/changes/version/previous    params=commitVersion=${commit_version}&entityId=${entity_id}&entityType=${entity_type}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Histories
    [Arguments]    ${change_property}    ${entity_id}    ${entity_type}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/audits/entity/histories    params=changeProperty=${change_property}&entityId=${entity_id}&entityType=${entity_type}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}