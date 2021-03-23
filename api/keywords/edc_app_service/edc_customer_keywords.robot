*** Keywords ***
Get Customer Info
    [Arguments]    ${brand_id}    ${outlet_id}    ${terminal_id}    ${acc_type}    ${acc_value}
    ${RESP}=    Get Request    ${RPP_GATEWAY_SESSION}    /edc-app-services/v1/customers?brand_id=${brand_id}&outlet_id=${outlet_id}&terminal_id=${terminal_id}&acc_type=${acc_type}&acc_value=${acc_value}    headers=${RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Get Customer Card
    [Arguments]    ${brand_id}    ${outlet_id}    ${terminal_id}    ${acc_type}    ${acc_value}
    ${RESP}=    Get Request    ${RPP_GATEWAY_SESSION}    /edc-app-services/v1/customers/card?brand_id=${brand_id}&outlet_id=${outlet_id}&terminal_id=${terminal_id}&acc_type=${acc_type}&acc_value=${acc_value}    headers=${RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}