*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${api_merchant}         /merchant-v2
${api_view_profile}     /api/merchants/_merchantID/details

*** Keywords ***
Create View Profile Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    Set Test Variable    &{view_profile_header}    &{headers}

Get Merchant Profile By Merchant ID
    [Arguments]    ${merchant_id}
    Create View Profile Header
    ${profile_uri}=    Replace String    ${api_view_profile}    _merchantID    ${merchant_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${api_merchant}${profile_uri}    headers=${view_profile_header}
    Set Test Variable    ${RESP}
