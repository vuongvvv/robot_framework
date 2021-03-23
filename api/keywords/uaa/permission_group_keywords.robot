*** Settings ***
Resource      ../common/api_common.robot
Resource    ../common/json_common.robot

*** Variables ***
${permission_group_api}    /uaa/api/permission-groups
*** Keywords ***
Get All Permission Groups
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${permission_group_api}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Permission Group
    [Arguments]    ${permission_group_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${permission_group_api}/${permission_group_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Data preparation
Get Permission Group Id
    Get All Permission Groups
    ${TEST_DATA_PERMISSION_GROUP_ID}=    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${TEST_DATA_PERMISSION_GROUP_ID}