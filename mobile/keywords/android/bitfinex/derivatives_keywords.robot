*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/derivatives_locators.robot
Resource    ../../../../utility/common/locator_common.robot
Resource    ../../common/mobile_common.robot

*** Keywords ***
Clear Ticker Search On Derivatives
    Wait Element Is Visible    ${btn_clear_search_tickers_on_derivatives}
    Click Visible Element    ${btn_clear_search_tickers_on_derivatives}
    
Access Trading Pair On Derivatives
    [Arguments]    ${pair}
    ${pair_locator}    Generate Element From Dynamic Locator    ${tbl_cell_ticker_on_derivatives_by_name}    ${pair}
    Wait Element Is Visible    ${pair_locator}
    Click Visible Element    ${pair_locator}
    
Search Ticker On Derivatives
    [Arguments]    ${ticker}
    Wait Element Is Visible    ${txt_search_tickers_on_derivatives}
    Input Text Into Element    ${txt_search_tickers_on_derivatives}    ${ticker}