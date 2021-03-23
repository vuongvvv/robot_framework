*** Settings ***
Resource    json_common.robot

*** Variables ***
#LINE ACCESS
${line_access_host}    https://api.line.me
${line_access_session}    LINE_ACCESS_SESSION

*** Keywords ***
Create Line Access Session
    Create Session    ${line_access_session}    ${line_access_host}    verify=true

Post Verify Id Token
    [Arguments]    ${line_authorization_code}    ${line_client_id}    ${line_client_secret}=2784703c7cac7d3e32a9bdfc92ed86a8
    &{data}=    Create Dictionary    grant_type=authorization_code    code=${line_authorization_code}    redirect_uri=https://dev-gateway.weomni-test.com/o2o-qa-automation/auth    client_id=${line_client_id}    client_secret=${line_client_secret}
    &{headers}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${RESP}=    Post Request    ${line_access_session}    /oauth2/v2.1/token    data=${data}    headers=${headers}
    Set Test Variable    ${RESP}

Fetch Line Id Token
    ${line_id_token}=    Get Property Value From Json By Index    .id_token    0
    Set Test Variable    ${LINE_ID_TOKEN}    ${line_id_token}