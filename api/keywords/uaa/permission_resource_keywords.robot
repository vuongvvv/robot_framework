*** Settings ***
Resource      ../common/api_common.robot

*** Keywords ***
Put Update Permission
    [Arguments]    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /uaa/api/permissions    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Permissions
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /uaa/api/permissions    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}

Get Permission
    [Arguments]    ${permission_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /uaa/api/permissions/${permission_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
#Test Data
Get First Existing Permission Information
    Get All Permissions    name.contains=notification.config.refresh
    ${existing_permission_id_list}=    Get Value From Json     ${RESP.json()}    $..id
    ${existing_permission_name_list}=    Get Value From Json     ${RESP.json()}    $..name
    ${existing_permission_description_list}=    Get Value From Json     ${RESP.json()}    $..description
    Set Test Variable    ${EXISTING_PERMISSION_ID}    @{existing_permission_id_list}[0]
    Set Test Variable    ${EXISTING_PERMISSION_NAME}    @{existing_permission_name_list}[0]
    Set Test Variable    ${EXISTING_PERMISSION_DESCRIPTION}    @{existing_permission_description_list}[0]

Revert Permission Name
    Put Update Permission    { "description": "${EXISTING_PERMISSION_DESCRIPTION}", "name": "notification.config.refresh", "id": ${EXISTING_PERMISSION_ID} }
