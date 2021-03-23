*** Settings ***
Resource      ../common/api_common.robot
Resource    ../common/json_common.robot
Resource      ../../../web/keywords/common/web_common.robot

*** Variables ***
${social_login_page}            /uaa/api/social/signin/_providerId
${verify_trueid_login}          /uaa/api/social/signin/trueid?code=_loginCode&state=_loginState&mid
${txt_trueid_account}    //input[@id='account']
${txt_trueid_password}    //input[@id='password']
${btn_signin_trueid}    //button[@id='bt_signin']

*** Keywords ***
Load The Login Page
    [Arguments]      ${provider}
    ${update_provider_uri}=    Replace String    ${social_login_page}    _providerId    ${provider}
    ${RESP}=                   Get Request       ${GATEWAY_SESSION}      ${update_provider_uri}
    Set Test Variable          ${RESP}

Login TrueID On Website
    [Arguments]       ${username}       ${password}
    Switch To Non Angular JS Site
    Input Text Into Visible Element    ${txt_trueid_account}    ${username}
    Input Text Into Visible Element    ${txt_trueid_password}    ${password}
    Click Visible Element     ${btn_signin_trueid}

Get Login Code And State
    Sleep  2s     # Hard sleep to wait for the URI loaded successful
    ${token_href}=           Get Location
    ${split_code_state} =    Fetch From Right          ${token_href}             ?code=
    ${CODE_ID} =             Fetch From Left           ${split_code_state}       &state=
    ${STATE_ID} =            Fetch From Right          ${split_code_state}       &state=
    Set Test Variable        ${CODE_ID}
    Set Test Variable        ${STATE_ID}

Login TrueID Account
    [Arguments]             ${auth_key}=${AUTHORIZATION_KEY}    ${login_code}=${code_id}
    ${headers}=             Create Dictionary       Authorization=${auth_key}
    ${trueid_login_uri}=    Replace String          ${verify_trueid_login}      _loginCode            ${login_code}
    ${trueid_login_uri}=    Replace String          ${trueid_login_uri}         _loginState           ${state_id}
    ${RESP}=                Get Request             ${GATEWAY_SESSION}          ${trueid_login_uri}   headers=${headers}
    Set Test Variable       ${RESP}
    ${RESPONSE_REFRESH_TOKEN}=  Set Variable If	'${RESP}'=='<Response [${SUCCESS_CODE}]>'    ${RESP.json()['refresh_token']}
    ${RESPONSE_ACCESS_TOKEN}=   Set Variable If	'${RESP}'=='<Response [${SUCCESS_CODE}]>'    ${RESP.json()['access_token']}
    Set Test Variable        ${RESPONSE_REFRESH_TOKEN}
    Set Test Variable        ${RESPONSE_ACCESS_TOKEN}

Get Access Token From TrueID
    [Arguments]       ${trueid_username}       ${trueid_password}
    Open Browser With Option    ${trueid_login_url}
    Login TrueID On Website      ${trueid_username}       ${trueid_password}
    Get Login Code And State
    Login TrueID Account
    ${ACCESS_TOKEN}=    Get Property Value From Json By Index    .access_token    0
    Set Suite Variable    ${ACCESS_TOKEN}