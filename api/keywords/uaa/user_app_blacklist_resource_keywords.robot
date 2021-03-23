*** Settings ***
Resource      ../common/api_common.robot
Resource      ../common/validation_common.robot
Resource    ../common/json_common.robot

*** Variables ***
${user_blacklists}              /uaa/api/user-app-blacklists
${invalid_user_blacklist}       /api/user-app-blacklists

*** Keywords ***
Create Revoke Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    Set Test Variable    &{revoke_token_header}    &{headers}

Create Invalid Revoke Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9
    Set Suite Variable    &{revoke_token_header}    &{headers}

Revoke User And Client Token
    [Arguments]    ${client_id}   ${user_id}
    Create Revoke Header
    ${create_revocation_body}=    Set Variable    {"clientId": ${client_id},"userId": ${user_id}}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${user_blacklists}    data=${create_revocation_body}    headers=${revoke_token_header}
    Set Suite Variable        ${RESP}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created ID
    ${created_revoke_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_id}
    Set Suite Variable        ${created_revoke_id}

Revoke With The Invalid Token
    [Arguments]    ${client_id}   ${user_id}
    Create Invalid Revoke Header
    ${create_user_revoke_body}=    Set Variable    {"clientId": ${client_id},"userId": ${user_id}}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${user_blacklists}    data=${create_user_revoke_body}    headers=${revoke_token_header}
    Set Suite Variable        ${RESP}

Restore Token Revocation
    [Arguments]    ${get_id}
    Create Revoke Header
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${user_blacklists}/${get_id}    headers=${revoke_token_header}
    Set Test Variable    ${RESP}

Get All Blacklist
    ${RESP}=     Get Request             ${GATEWAY_SESSION}         ${user_blacklists}      headers=${GATEWAY_HEADER}
    Set Test Variable               ${RESP}

Get All Blacklist With Invalid Endpoint
    Create Revoke Header
    ${RESP}=     Get Request             ${GATEWAY_SESSION}         ${invalid_user_blacklist}      headers=${revoke_token_header}
    Set Test Variable               ${RESP}

Get All Blacklist With Invalid Token
    Create Invalid Revoke Header
    ${RESP}=     Get Request             ${GATEWAY_SESSION}         ${user_blacklists}      headers=${revoke_token_header}
    Set Test Variable               ${RESP}

Get Blacklist Detail
    [Arguments]    ${blacklist_id}
    Create Revoke Header
    ${RESP}=     Get Request             ${GATEWAY_SESSION}         ${user_blacklists}/${blacklist_id}      headers=${revoke_token_header}
    Set Test Variable               ${RESP}

Get Blacklist Detail With Invalid Endpoint
    [Arguments]    ${blacklist_id}
    Create Revoke Header
    ${RESP}=     Get Request             ${GATEWAY_SESSION}         ${invalid_user_blacklist}/${blacklist_id}      headers=${revoke_token_header}
    Set Test Variable               ${RESP}

Get Blacklist Detail With Invalid Token
    [Arguments]    ${blacklist_id}
    Create Invalid Revoke Header
    ${RESP}=     Get Request             ${GATEWAY_SESSION}         ${user_blacklists}/${blacklist_id}      headers=${revoke_token_header}
    Set Test Variable               ${RESP}

Delete Blacklist
    [Arguments]    ${blacklist_id}
    Create Revoke Header
    ${RESP}=    Delete Request         ${GATEWAY_SESSION}             ${user_blacklists}/${blacklist_id}         headers=${revoke_token_header}
    Set Test Variable    ${RESP}

Delete Blacklist With Invalid Endpoint
    [Arguments]    ${blacklist_id}
    Create Revoke Header
    ${RESP}=    Delete Request         ${GATEWAY_SESSION}             ${invalid_user_blacklist}/${blacklist_id}         headers=${revoke_token_header}
    Set Test Variable    ${RESP}

Delete Blacklist With Invalid Token
    [Arguments]    ${blacklist_id}
    Create Invalid Revoke Header
    ${RESP}=     Delete Request             ${GATEWAY_SESSION}         ${user_blacklists}/${blacklist_id}      headers=${revoke_token_header}
    Set Test Variable               ${RESP}

Check Deleted Blacklist
    [Arguments]    ${property}    ${blacklist_id}
    @{property_values}=    Get Value From Json    ${RESP.json()}    $.${property}
    FOR    ${property_value}    IN    @{property_values}
        Should Not Be Equal    ${property_value}    ${blacklist_id}
    END

Get All User App Blacklists
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${user_blacklists}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get User App Blacklist
    [Arguments]    ${blacklist_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${user_blacklists}/${blacklist_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Create User App Blacklist
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${user_blacklists}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete User App Blacklist
    [Arguments]    ${blacklist_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${user_blacklists}/${blacklist_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update User App Blacklist
    [Arguments]    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${user_blacklists}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Data Preparation
Get Blacklist Id
    Get All User App Blacklists
    ${BLACKLIST_ID}=    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${BLACKLIST_ID}