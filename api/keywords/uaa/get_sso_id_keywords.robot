*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/gateway_common.robot

*** Variables ***
${get_sso_id_api}    /uaa/api/account/social-user-connection?providerId

*** Keywords ***
Get SSO ID From UAA With Access Token
    [Documentation]    Get the SSO ID with provider id as trueid, facebook,.... with the invalid access token
    [Arguments]    ${access_token}    ${provider_id}
    Create Gateway Session
    &{GATEWAY_HEADER}=    Create Dictionary    authorization=Bearer ${access_token}    Content-Type=application/json
    ${get_sso_id}=    Catenate    SEPARATOR==    ${get_sso_id_api}    ${provider_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${get_sso_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}