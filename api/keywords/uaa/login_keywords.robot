*** Settings ***
Resource      ../common/api_common.robot

*** Variables ***
${api_uaa}        /uaa
${account_path}   /api/account
${token_path}     /oauth/token

*** Keywords ***
Login Account
    [Arguments]      &{data}
    &{headers}=      Create Dictionary        Content-Type=application/x-www-form-urlencoded    Authorization=${AUTHORIZATION_KEY}
    ${RESP}=         Post Request             ${GATEWAY_SESSION}   ${api_uaa}${token_path}   data=&{data}    headers=${headers}
    Set Test Variable        ${RESP}
    ${RESPONSE_REFRESH_TOKEN}=  Set Variable If	'${RESP}'=='<Response [${SUCCESS_CODE}]>'    ${RESP.json()['refresh_token']}
    ${RESPONSE_ACCESS_TOKEN}=   Set Variable If	'${RESP}'=='<Response [${SUCCESS_CODE}]>'    ${RESP.json()['access_token']}
    Set Test Variable        ${RESPONSE_REFRESH_TOKEN}
    Set Test Variable        ${RESPONSE_ACCESS_TOKEN}

Get Access Token From Refresh Token
    [Arguments]      ${refresh_token}
    &{headers}=      Create Dictionary     Content-Type=application/x-www-form-urlencoded   Authorization=${AUTHORIZATION_KEY}
    ${data}=         Create Dictionary     refresh_token=${refresh_token}     grant_type=refresh_token
    ${RESP}=         Post Request          ${GATEWAY_SESSION}    ${api_uaa}${token_path}       data=${data}      headers=${headers}
    Set Test Variable     ${RESP}

Get Account Information With Access Token
    [Arguments]         ${access_token}
    ${headers}=         Create Dictionary       Authorization=Bearer ${access_token}
    ${RESP}=            Get Request       ${GATEWAY_SESSION}      ${api_uaa}${account_path}    headers=${headers}
    Set Test Variable   ${RESP}

#####BELOW ARE KEYWORDS THAT ARE USING FOR TEMPLATE TESTING
Login With Missing Username Or Password Should Fail
    [Arguments]    &{data}
    Login Account    &{data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    error    invalid_grant
    Response Should Contain Property With Value    error_description    Bad credentials
