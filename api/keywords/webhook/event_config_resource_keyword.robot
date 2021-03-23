*** Keywords ***
Get All Even Configs
    [Arguments]    ${project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /webhook/api/projects/${project_id}/event-configs    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Even Configs By Id
    [Arguments]    ${project_id}    ${id}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /webhook/api/projects/${project_id}/event-configs/${id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Fetch Webhook Config Id
    ${config_id}=    Get Property Value From Json By Index    .id
    Set Suite Variable    ${WEBHOOK_CONFIG_ID}    ${config_id}
