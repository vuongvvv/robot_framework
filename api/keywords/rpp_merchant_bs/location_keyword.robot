*** Variables ***
${search_location_endpoint}    /merchant-bs-api/v1/location

*** Keywords ***
Get Api Search Location
    &{param}=     Create Dictionary    latitude=13.7644702    longitude=100.5660648    distance=10
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    ${search_location_endpoint}    params=&{param}    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}