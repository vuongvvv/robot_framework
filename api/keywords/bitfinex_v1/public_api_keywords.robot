*** Keywords ***
Get Ticker
    [Arguments]    ${ticker}
    ${RESP}=    Get Request    ${BITFINEX_SESSION_V1}    /v1/pubticker/${ticker}
    Set Test Variable    ${RESP}
    
Get Symbols
    ${RESP}=    Get Request    ${BITFINEX_SESSION_V1}    /v1/symbols
    Set Test Variable    ${RESP}
    
Get Stats
    [Arguments]    ${symbol}
    ${RESP}=    Get Request    ${BITFINEX_SESSION_V1}    /v1/stats/${symbol}
    Set Test Variable    ${RESP}
    
Get Funding Book
    [Arguments]    ${currency}
    ${RESP}=    Get Request    ${BITFINEX_SESSION_V1}    /v1/lendbook/${currency}
    Set Test Variable    ${RESP}
    
Get Order Book
    [Arguments]    ${symbol}
    ${RESP}=    Get Request    ${BITFINEX_SESSION_V1}    /v1/book/${symbol}
    Set Test Variable    ${RESP}
    
Get Trades
    [Arguments]    ${symbol}
    ${RESP}=    Get Request    ${BITFINEX_SESSION_V1}    /v1/trades/${symbol}
    Set Test Variable    ${RESP}
    
Get Lends
    [Arguments]    ${currency}
    ${RESP}=    Get Request    ${BITFINEX_SESSION_V1}    /v1/lends/${currency}
    Set Test Variable    ${RESP}
    
Get Symbol Detail
    ${RESP}=    Get Request    ${BITFINEX_SESSION_V1}    /v1/symbols_details
    Set Test Variable    ${RESP}