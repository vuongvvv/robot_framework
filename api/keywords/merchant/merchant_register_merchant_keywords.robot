*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${merchants_api}    /merchant-v2/api/merchants

*** Keywords ***
Create Merchants Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    Set Suite Variable    &{merchants_header}    &{headers}

Create Invalid Merchants Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9
    Set Suite Variable    &{merchants_header}    &{headers}

Get All Merchants Profile
    Create Merchants Header
    ${RESP}=            Get Request       ${GATEWAY_SESSION}      ${merchants_api}    headers=&{merchants_header}
    Set Test Variable   ${RESP}

Get Merchant Profile By Merchant ID
    [Arguments]    ${merchant_id}
    Create Merchants Header
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${merchants_api}/${merchant_id}    headers=&{merchants_header}
    Set Test Variable    ${RESP}

Create Merchant Profile
    [Arguments]    ${merchant_type}    ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}    ${merchant_status}
    Create Merchants Header
    ${create_merchant_body}=    Set Variable    {"businessDetails": { "type": "${merchant_type}" }, "name": "${merchant_name}", "displayName": { "th":"${merchant_th_display}", "en":"${merchant_en_display}" }, "status": "${merchant_status}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${merchants_api}    data=${create_merchant_body}    headers=${merchants_header}
    Set Suite Variable        ${RESP}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created ID
    ${created_merchant_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_id}
    Set Suite Variable        ${created_merchant_id}

Delete Merchant Profile By Merchant ID
    [Arguments]    ${merchant_id}
    Create Merchants Header
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${merchants_api}/${merchant_id}    headers=&{merchants_header}
    Set Test Variable    ${RESP}

Update Merchant Profile By Merchant ID
    [Arguments]    ${merchant_id}   ${merchant_type}    ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Create Merchants Header
    ${create_merchant_body}=    Set Variable    {"businessDetails": { "type": "${merchant_type}" }, "name": "${merchant_name}", "displayName": { "th":"${merchant_th_display}", "en":"${merchant_en_display}" }, "status": "${merchant_status}"}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${merchants_api}/${merchant_id}    data=${create_merchant_body}      headers=&{merchants_header}
    Set Test Variable    ${RESP}

Create Merchant Profile With Invalid Token
    [Arguments]    ${merchant_type}    ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}    ${merchant_status}
    Create Invalid Merchants Header
    ${create_merchant_body}=    Set Variable    {"businessDetails": { "type": "${merchant_type}" }, "name": "${merchant_name}", "displayName": { "th":"${merchant_th_display}", "en":"${merchant_en_display}" }, "status": "${merchant_status}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${merchants_api}    data=${create_merchant_body}    headers=${merchants_header}
    Set Suite Variable    ${RESP}

Delete Merchant ID With Invalid Token
    [Arguments]    ${merchant_id}
    Create Invalid Merchants Header
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${merchants_api}/${merchant_id}    headers=&{merchants_header}
    Set Test Variable    ${RESP}

Update Merchant ID With Invalid Token
    [Arguments]    ${merchant_id}   ${merchant_type}    ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Create Invalid Merchants Header
    ${create_merchant_body}=    Set Variable    {"businessDetails": { "type": "${merchant_type}" }, "name": "${merchant_name}", "displayName": { "th":"${merchant_th_display}", "en":"${merchant_en_display}" }, "status": "${merchant_status}"}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${merchants_api}/${merchant_id}    data=${create_merchant_body}      headers=&{merchants_header}
    Set Test Variable    ${RESP}

Get All Merchants With Invalid Token
    Create Invalid Merchants Header
    ${RESP}=            Get Request       ${GATEWAY_SESSION}      ${merchants_api}    headers=&{merchants_header}
    Set Test Variable   ${RESP}

Get Merchant ID With Invalid Token
    [Arguments]    ${merchant_id}
    Create Invalid Merchants Header
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${merchants_api}/${merchant_id}    headers=&{merchants_header}
    Set Test Variable    ${RESP}
