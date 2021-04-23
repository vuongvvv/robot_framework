*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/funding_locators.robot
Resource    ../../../../utility/common/locator_common.robot

*** Keywords ***
Clear Ticker Search On Funding
    Wait Element Is Visible    ${btn_clear_search_tickers_on_funding}
    Click Visible Element    ${btn_clear_search_tickers_on_funding}
    
Access Trading Pair On Funding
    [Arguments]    ${pair}
    ${pair_locator}    Generate Element From Dynamic Locator    ${tbl_cell_ticker_on_funding_by_name}    ${pair}
    Wait Element Is Visible    ${pair_locator}
    Click Visible Element    ${pair_locator}
    
Search Ticker On Funding
    [Arguments]    ${ticker}
    Wait Element Is Visible    ${txt_search_tickers_on_funding}
    Input Text Into Element    ${txt_search_tickers_on_funding}    ${ticker}