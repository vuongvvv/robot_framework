*** Keywords ***
Get Payment By Client Ref Id
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/credit-card/query-activity    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
