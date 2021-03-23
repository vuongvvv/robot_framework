*** Variables ***
${check_dopa_endpoint}         /merchant-bs-api/v1/merchant/dopa

*** Keywords ***
Post Api Check Merchant Dopa
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${check_dopa_endpoint}    data=${request_data}    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}