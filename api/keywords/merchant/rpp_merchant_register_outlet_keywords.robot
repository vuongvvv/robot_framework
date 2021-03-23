*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Post Create Outlets And Address Ref Merchant Id
    [Arguments]    ${merchant_id}    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /rpp-merchant/api/v2/merchants/${merchant_id}/outlets    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Change True You Status To In Progress
    [Arguments]    ${merchant_sequence_id}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /rpp-merchant/api/v2/merchants/${merchant_sequence_id}/outlets/ty-status/in-progress    data=${None}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Change True Money Status To In Progress
    [Arguments]    ${merchant_sequence_id}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /rpp-merchant/api/v2/merchants/${merchant_sequence_id}/outlets/tmn-status/in-progress    data=${None}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
