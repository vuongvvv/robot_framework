*** Keywords ***
# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1080328340/GET+Terminal+Outlet+Merchant+By+tmnTerminalId
Get Search
    [Arguments]     ${params_uri}=${EMPTY}
    ${RESP}=      Get Request     ${GATEWAY_SESSION}    /rpp-merchant/api/v2/terminals    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}