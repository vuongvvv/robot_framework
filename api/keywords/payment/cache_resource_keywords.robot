*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Delete Clear Merchant Cache
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    /payment/api/cache/merchant    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Clear Outlet Cache
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    /payment/api/cache/outlet    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}