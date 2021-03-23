*** Keywords ***    
Get All Mappings
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /mapping/api/mappings    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Resolve Mapping Internal To External
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /mapping/api/reverse-mapping    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Mapping
    [Arguments]    ${data}
    Put Request    ${GATEWAY_SESSION}    /mapping/api/mappings    data=${data}    headers=&{GATEWAY_HEADER}