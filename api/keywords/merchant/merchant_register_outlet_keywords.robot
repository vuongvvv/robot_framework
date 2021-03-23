*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${outlets_profile}              /merchant-v2/api/merchants/_merchantID/outlets
${outlets_profile_by_id}        /merchant-v2/api/merchants/_merchantID/outlets/_outletID

*** Keywords ***
Create Outlets Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    Set Suite Variable    &{outlets_header}    &{headers}

Create Invalid Outlet Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9
    Set Suite Variable    &{outlets_header}    &{headers}

Get All Outlet Profile
    [Arguments]    ${merchant_id}
    Create Outlets Header
    ${profile_uri}=    Replace String     ${outlets_profile}    _merchantID    ${merchant_id}
    ${RESP}=            Get Request       ${GATEWAY_SESSION}      ${profile_uri}    headers=&{outlets_header}
    Set Test Variable   ${RESP}

Get Outlet Profile By ID
    [Arguments]    ${merchant_id}       ${outlet_id}
    Create Outlets Header
    ${profile_id_uri}=    Replace String         ${outlets_profile_by_id}    _merchantID    ${merchant_id}
    ${profile_uri}=       Replace String         ${profile_id_uri}    _outletID      ${outlet_id}
    ${RESP}=              Get Request            ${GATEWAY_SESSION}      ${profile_uri}    headers=&{outlets_header}
    Set Test Variable   ${RESP}

Delete Outlet Profile By ID
    [Arguments]    ${merchant_id}       ${outlet_id}
    Create Outlets Header
    ${profile_id_uri}=    Replace String          ${outlets_profile_by_id}    _merchantID    ${merchant_id}
    ${profile_uri}=       Replace String          ${profile_id_uri}    _outletID      ${outlet_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${profile_uri}    headers=&{outlets_header}
    Set Test Variable    ${RESP}

Create Outlet Profile
    [Arguments]    ${merchant_id}     ${outlet_headQuarter}    ${outlet_name}    ${outlet_status}
    Create Outlets Header
    ${create_outlet_body}=    Set Variable    {"headQuarter": ${outlet_headQuarter},"name": "${outlet_name}","status": "${outlet_status}"}
    ${profile_uri}=    Replace String     ${outlets_profile}    _merchantID    ${merchant_id}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${profile_uri}    data=${create_outlet_body}    headers=${outlets_header}
    ${response_outlet_id}=  Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${RESP.json()['id']}
    Set Suite Variable        ${response_outlet_id}
    Set Suite Variable    ${RESP}

Update Outlet Profile By Merchant ID
    [Arguments]    ${merchant_id}   ${outlet_id}    ${outlet_headQuarter}    ${outlet_name}    ${outlet_status}
    Create Outlets Header
    ${create_outlet_body}=    Set Variable    {"headQuarter": ${outlet_headQuarter},"name": "${outlet_name}","status": "${outlet_status}"}
    ${profile_id_uri}=    Replace String          ${outlets_profile_by_id}    _merchantID    ${merchant_id}
    ${profile_uri}=       Replace String          ${profile_id_uri}    _outletID      ${outlet_id}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${profile_uri}    data=${create_outlet_body}      headers=&{outlets_header}
    Set Test Variable    ${RESP}

Delete Outlet ID With Invalid Token
    [Arguments]    ${merchant_id}       ${outlet_id}
    Create Invalid Outlet Header
    ${profile_id_uri}=    Replace String          ${outlets_profile_by_id}    _merchantID    ${merchant_id}
    ${profile_uri}=       Replace String          ${profile_id_uri}    _outletID      ${outlet_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${profile_uri}    headers=&{outlets_header}
    Set Test Variable    ${RESP}

Update Outlet ID With Invalid Token
    [Arguments]    ${merchant_id}   ${outlet_id}    ${outlet_headQuarter}    ${outlet_name}    ${outlet_status}
    Create Invalid Outlet Header
    ${create_outlet_body}=    Set Variable    {"headQuarter": ${outlet_headQuarter},"name": "${outlet_name}","status": "${outlet_status}"}
    ${profile_id_uri}=    Replace String          ${outlets_profile_by_id}    _merchantID    ${merchant_id}
    ${profile_uri}=       Replace String          ${profile_id_uri}    _outletID      ${outlet_id}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${profile_uri}    data=${create_outlet_body}      headers=&{outlets_header}
    Set Test Variable    ${RESP}

Create Outlet With Invalid Token
    [Arguments]    ${merchant_id}     ${outlet_headQuarter}    ${outlet_name}    ${outlet_status}
    Create Invalid Outlet Header
    ${create_outlet_body}=    Set Variable    {"headQuarter": ${outlet_headQuarter},"name": "${outlet_name}","status": "${outlet_status}"}
    ${profile_uri}=    Replace String     ${outlets_profile}    _merchantID    ${merchant_id}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${profile_uri}    data=${create_outlet_body}    headers=${outlets_header}
    ${response_outlet_id}=  Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${RESP.json()['id']}
    Set Suite Variable        ${response_outlet_id}
    Set Suite Variable    ${RESP}
