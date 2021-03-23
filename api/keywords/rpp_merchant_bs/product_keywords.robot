*** Variables ***
${check_product_endpoint}      /merchant-bs-api/v1/merchant/checkproduct

*** Keywords ***
Get Api Check Product
    [Arguments]     ${param}
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    ${check_product_endpoint}    params=&{param}    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}