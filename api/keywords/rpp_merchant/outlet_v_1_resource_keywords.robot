*** Keywords ***
Get Search Outlet V1 By Id
    [Arguments]    ${outlet_id}    ${fields}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /rpp-merchant/api/outlets?id=${outlet_id}    params=${fields}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Search Outlet V1 By Merchant Name
    [Arguments]    ${merchant_name}    ${fields}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /rpp-merchant/api/outlets?outletNameEn=${merchant_name}    params=${fields}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
