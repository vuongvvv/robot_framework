*** Keywords ***
Get Count Members
    [Arguments]    ${merchant_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /membership/api/merchants/${merchant_id}/members/count    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}