*** Settings ***

Resource    ../../../mobile/resources/init.robot
Resource    ../../../mobile/keywords/bitfinex/common_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/trading_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/trading_pair_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/derivatives_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/derivatives_pair_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/funding_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/funding_pair_keywords.robot

Test Setup    Open Apps    Bitfinex
Test Teardown    Close Test Application
*** Variables ***
${expected_chart_loading_time}    5s

*** Test Cases ***
order_form_test
    [Documentation]    order_form_test
    [Tags]     E2E
    Search Ticker    BTCUSD
    Access Trading Pair    BTCUSD
    Scroll Down To Order Form
    Select Order Type    Market
    Verify Max Sell Buy Buttons
    Create Market Order    0.00009    buy
    Create Market Order    0.00009    sell
    Select Order Form Tab    Margin
    Scroll Down To Order Form
    Create Market Order    0.00009    buy    ${True}
    Create Market Order    0.00009    sell    ${True}
    
    # Check created orders by API
    






    # Exchange have Balance info in quote and base currency, the values are same to the available balance    

    # Open non-margin pairs, like AGI/USD (or any other without margin)  will have only Exchange
