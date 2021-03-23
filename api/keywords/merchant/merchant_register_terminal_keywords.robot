*** Settings ***
Resource    ../common/api_common.robot
Library    Collections

*** Variables ***
${api_merchant}    /merchant-v2
${api_create_terminal}    /api/merchants/_merchantId/outlets/_outletId/terminals
${api_update_terminal}    /api/merchants/_merchantId/outlets/_outletId/terminals/_terminalId
${api_delete_terminal}    /api/merchants/_merchantId/outlets/_outletId/terminals/_terminalId
${api_get_all_terminals}    /api/merchants/_merchantId/outlets/_outletId/terminals
${api_get_terminal}    /api/merchants/_merchantId/outlets/_outletId/terminals/_terminalId

## TEMP VARIABLES - THESE SHOULD BE REMOVED ONCE THE MERCHANT/OUTLET KEYWORDS ARE DONE
${api_create_merchant}    /api/merchants
${api_create_outlet}    /api/merchants/_merchantId/outlets

*** Keywords
## COMMON KEYWORDS FOR CRUD TERMINALS
Create Merchant Register Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    Set Suite Variable    &{merchant_register_header}    &{headers}

Set Non-Existing Terminal ID
    ${non_existing_terminal}=    Get Time
    Set Test Variable    ${non_existing_terminal}

Create Terminal
    [Arguments]    ${merchant_id}    ${outlet_id}    ${terminal_status}
    Create Merchant Register Header
    ${create_terminal_uri}=    Replace String    ${api_create_terminal}    _merchantId    ${merchant_id}
    ${create_terminal_uri}=    Replace String    ${create_terminal_uri}    _outletId     ${outlet_id}
    ${create_terminal_body}=    Set Variable    {"status":"${terminal_status}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${api_merchant}${create_terminal_uri}    data=${create_terminal_body}    headers=${merchant_register_header}
    Set Suite Variable   ${RESP}

Update Terminal
    [Arguments]    ${merchant_id}    ${outlet_id}    ${terminal_id}    ${terminal_status}
    Create Merchant Register Header
    ${update_terminal_uri}=    Replace String    ${api_update_terminal}    _merchantId    ${merchant_id}
    ${update_terminal_uri}=    Replace String    ${update_terminal_uri}    _outletId     ${outlet_id}
    ${update_terminal_uri}=    Replace String    ${update_terminal_uri}    _terminalId    ${terminal_id}
    ${update_terminal_body}=    Set Variable    {"status":"${terminal_status}"}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${api_merchant}${update_terminal_uri}    data=${update_terminal_body}    headers=${merchant_register_header}
    Set Test Variable    ${RESP}

Delete Terminal
    [Arguments]    ${merchant_id}    ${outlet_id}    ${terminal_id}
    Create Merchant Register Header
    ${delete_terminal_uri}=    Replace String    ${api_delete_terminal}    _merchantId    ${merchant_id}
    ${delete_terminal_uri}=    Replace String    ${delete_terminal_uri}    _outletId     ${outlet_id}
    ${delete_terminal_uri}=    Replace String    ${delete_terminal_uri}    _terminalId    ${terminal_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${api_merchant}${delete_terminal_uri}    headers=${merchant_register_header}
    Set Test Variable    ${RESP}

Get All Terminals
    [Arguments]    ${merchant_id}    ${outlet_id}
    Create Merchant Register Header
    ${get_all_terminals_uri}=    Replace String    ${api_get_all_terminals}    _merchantId    ${merchant_id}
    ${get_all_terminals_uri}=    Replace String    ${get_all_terminals_uri}    _outletId     ${outlet_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${api_merchant}${get_all_terminals_uri}    headers=${merchant_register_header}
    Set Test Variable    ${RESP}

Get Terminal
    [Arguments]    ${merchant_id}    ${outlet_id}    ${terminal_id}
    Create Merchant Register Header
    ${get_terminal_uri}=    Replace String    ${api_get_terminal}    _merchantId    ${merchant_id}
    ${get_terminal_uri}=    Replace String    ${get_terminal_uri}    _outletId     ${outlet_id}
    ${get_terminal_uri}=    Replace String    ${get_terminal_uri}    _terminalId    ${terminal_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${api_merchant}${get_terminal_uri}    headers=${merchant_register_header}
    Set Test Variable    ${RESP}

## KEYWORDS BELOW ARE USING FOR TEMPLATE TESTING
Create Terminal Successfully
    [Arguments]    ${merchant_id}    ${outlet_id}    ${terminal_status}
    Create Terminal    ${merchant_id}    ${outlet_id}    ${terminal_status}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    merchantId    ${merchant_id}
    Response Should Contain Property With Value    outletId    ${outlet_id}
    Response Should Contain Property With Value    status    ${terminal_status}

## TEMP KEYWORDS -- NEED TO BE REPLACED WITH THE ACTUAL KEYWORDS FROM MERCHANT AND OUTLET LEVELS
Create Test Merchant
    Create Merchant Register Header
    ${create_merchant_body}=    Set Variable    {"businessDetails": {"type": "INDIVIDUAL"},"displayName": {"en": "Terminal_EN","th": "เทอมินอลออโตเมท"},"name": "Merchant For Terminal Testing","status": "ACTIVE"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${api_merchant}${api_create_merchant}    data=${create_merchant_body}    headers=${merchant_register_header}
    Set Suite Variable    ${RESP}

Create Test Outlet
    [Arguments]    ${merchant_id}
    Create Merchant Register Header
    ${create_outlet_uri}=    Replace String    ${api_create_outlet}    _merchantId    ${merchant_id}
    ${create_outlet_body}=    Set Variable    {"headQuarter": false,"name": "Outlet For Terminal Testing","status": "ACTIVE"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${api_merchant}${create_outlet_uri}    data=${create_outlet_body}    headers=${merchant_register_header}
    Set Suite Variable    ${RESP}
