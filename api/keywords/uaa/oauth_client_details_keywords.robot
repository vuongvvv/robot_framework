*** Settings ***
Resource      ../common/api_common.robot
Resource    ../common/json_common.robot
*** Variables ***
${uaa_api}    /uaa/api/oauth-client-details

*** Keywords ***
Post Create OAuth Client Details
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${uaa_api}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}

Put Update OAuth Client Details
    [Arguments]    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${uaa_api}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete OAuth Client Details
    [Arguments]    ${client_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${uaa_api}/${client_id}    headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}

Get All OAuth Client Details
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${uaa_api}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}

Get Oauth Client Details
    [Arguments]    ${client_id}
    ${RESP} =    Get Request    ${GATEWAY_SESSION}    ${uaa_api}/${client_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Prepare test data
Create Client
    [Arguments]    ${scope}    ${grant_type}    ${access_token_validity}=300    ${refresh_token_validity}=604800    ${auto_approve}=true
    ${client_secret}=    Get Current Date    time_zone=local    increment=0    result_format=%Y%m%d%H%M%S%f    exclude_millis=False
    Post Create OAuth Client Details    { "clientId": "${TEST_NAME}", "name": "${TEST_NAME}", "clientSecret": "${client_secret}", "scope": "${scope}", "scopeValues": {}, "authorizedGrantTypes": "${grant_type}", "accessTokenValidity": ${access_token_validity}, "refreshTokenValidity": ${refresh_token_validity}, "autoApprove": ${auto_approve} }
    ${client_id}=    Get Value From Json    ${RESP.json()}    $..id
    Set Suite Variable    ${CREATED_AUTOGENERATED_ID_OF_CLIENT_ID}    ${client_id}[0]
    Set Suite Variable    ${CREATED_CLIENT_ID}    ${TEST_NAME}
    Set Suite Variable    ${CREATED_CLIENT_NAME}    ${TEST_NAME}
    Set Suite Variable    ${CREATED_CLIENT_SECRET}    ${client_secret}

Update Client
    [Arguments]    ${scope}    ${grant_type}    ${access_token_validity}=300    ${refresh_token_validity}=604800    ${auto_approve}=true
    ${client_name}=    Set Variable    robot_automation_client
    Get All OAuth Client Details
    ${client_id}=    Get Property Value By Another Property Value    .name    ${client_name}    .id
    Put Update OAuth Client Details    { "id":${client_id}, "clientId": "${client_name}", "name": "${client_name}", "clientSecret": "${client_name}", "scope": "${scope}", "scopeValues": {}, "authorizedGrantTypes": "${grant_type}", "accessTokenValidity": ${access_token_validity}, "refreshTokenValidity": ${refresh_token_validity}, "autoApprove": ${auto_approve} }
    Set Suite Variable    ${CREATED_CLIENT_NAME}    ${client_name}
    Set Suite Variable    ${CREATED_CLIENT_SECRET}    ${client_name}

Reset Production Client
    ${client_name}=    Set Variable    robot_automation_client
    Get All OAuth Client Details
    ${client_id}=    Get Property Value By Another Property Value    .name    ${client_name}    .id
    Put Update OAuth Client Details    { "id":${client_id}, "clientId": "${client_name}", "name": "${client_name}", "clientSecret": "${client_name}", "scope": "DEFAULT", "scopeValues": {}, "authorizedGrantTypes": "password,refresh_token,client_credentials", "accessTokenValidity": 300, "refreshTokenValidity": 604800, "autoApprove": true }

Remove Existing Client
    [Arguments]    ${client_name}
    Get All OAuth Client Details
    ${client_id}=    Get Property Value By Another Property Value    .name    ${client_name}    .id
    Delete OAuth Client Details    ${client_id}