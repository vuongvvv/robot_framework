*** Settings ***
Resource      ../../../api/keywords/common/rpp_gateway_common.robot

*** Variables ***
${merchant_bs_login_endpoint}    /merchant-bs-api/v1/user/login

*** Keywords ***
Post Api Login
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${merchant_bs_login_endpoint}    data=${request_data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Get Accesstoken
    ${accessToken}    Set Variable     ${Resp.json()['data']['accessToken']}
    Set Test Variable    ${accessToken}

Generate Merchant Bs Header
    [Arguments]    ${user_name}    ${password}    ${user_type}=sale
    Create RPP Gateway Header
    Post Api Login    { "username":"${user_name}", "password":"${password}", "user_type":"${user_type}" }
    ${access_token}    Get Property Value From Json By Index    data.accessToken
    &{RPP_GATEWAY_MERCHANT_BS_HEADER}    Create Dictionary    Accesstoken=${access_token}
    Set Suite Variable    &{RPP_GATEWAY_MERCHANT_BS_HEADER}      