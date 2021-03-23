*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/gateway_common.robot
Resource    ../uaa/uaa_db_keywords.robot

*** Variables ***
${api_merchant}       /merchant-v2
${api_user_merchant}  /api/user-merchants
${api_auto_binding}   /api/link-trueyou

*** Keywords ***
Create Binding Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    Set Suite Variable    &{binding_header}    &{headers}

Submit Unbind Request
    [Arguments]    ${trueyou_mid}
    Create Binding Header
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${api_merchant}${api_user_merchant}/${trueyou_mid}    headers=${binding_header}
    Set Suite Variable    ${RESP}

Submit Auto Binding Request
    [Arguments]    ${mid}
    Create Binding Header
    ${request_data}=    Set Variable    {"mid": "${mid}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${api_merchant}${api_auto_binding}    data=${request_data}    headers=${binding_header}
    Set Suite Variable    ${RESP}

Unbind Merchant Account
    Submit Unbind Request    ${valid_trueyou_mid}

Bound Merchant Account
    Submit Auto Binding Request        ${valid_mid}
