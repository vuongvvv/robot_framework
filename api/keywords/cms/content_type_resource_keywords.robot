*** Keywords ***
Get All Content Types
    [Arguments]    ${project_id}    ${param_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /cms/api/projects/${project_id}/content-types    params=${param_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Get Content Type
    [Arguments]    ${project_id}    ${content_type_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /cms/api/projects/${project_id}/content-types/${content_type_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Put Update Content Type
    [Arguments]    ${project_id}    ${data}
    ${RESP}    Post Request    ${GATEWAY_SESSION}    /cms/api/projects/${project_id}/content-types    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}