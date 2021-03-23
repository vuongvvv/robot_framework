*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
Post Create Or Update Client Configuration
    [Arguments]    ${client_id}    ${configuration_id}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/clients/${client_id}/configurations/${configuration_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}