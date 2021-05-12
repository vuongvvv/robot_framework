*** Keywords ***
Get Tickers
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${BITFINEX_SESSION}    /v2/tickers    params=${params_uri}
    Set Test Variable    ${RESP}