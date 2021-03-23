*** Keywords ***
Post Is Authorized
    [Arguments]    ${project_id}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/authorize    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Wait Until Cashbin Rules Created
    Sleep    3s