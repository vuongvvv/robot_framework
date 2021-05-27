*** Settings ***

Resource    ../../../mobile/resources/init.robot
Resource    ../../../mobile/keywords/bitfinex/common_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/trading_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/trading_pair_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/derivatives_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/derivatives_pair_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/funding_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/funding_pair_keywords.robot

Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/bitfinex_v1/bitfinex_common.robot
Resource    ../../../api/keywords/bitfinex_v1/orders_keywords.robot

Test Setup    Run Keywords    Open Apps    Bitfinex
...    AND    Create Bitfinex V1 Session
Test Teardown    Run Keywords    Close Test Application
...    AND    Delete All Sessions
*** Variables ***
${expected_chart_loading_time}    5s

*** Test Cases ***
order_form_test
    [Documentation]    order_form_test
    [Tags]     smoke
    Search Ticker    BTCUSD
    Access Trading Pair    BTCUSD
    
    # MARKET order
    Scroll Down To Order Form
    Select Order Type    Market
    Verify Max Sell Buy Buttons
    Create Market Order    0.00009    buy
    Create Market Order    0.00009    sell
    
    Select Order Form Tab    Margin
    Scroll Down To Order Form
    Create Market Order    0.00009    buy
    Create Market Order    0.00009    sell
    
    # Check created orders by API
    Post Order History
    Response Property Should Be    .symbol    btcusd
    Response Property Should Be    .side    sell
    Response Property Should Be    .type    market
    Response Property Should Be    .original_amount    0.00009
    Response Property Should Be    .executed_amount    0.00009
    Response Property Should Be    .src    web
    
    Response Property Should Be    .symbol    btcusd    1
    Response Property Should Be    .side    buy    1
    Response Property Should Be    .type    market    1
    Response Property Should Be    .original_amount    0.00009    1
    Response Property Should Be    .executed_amount    0.00009    1
    Response Property Should Be    .src    web    1
    
    Response Property Should Be    .symbol    btcusd    2
    Response Property Should Be    .side    sell    2
    Response Property Should Be    .type    exchange market    2
    Response Property Should Be    .original_amount    0.00009    2
    Response Property Should Be    .executed_amount    0.00009    2
    Response Property Should Be    .src    web    2
    
    Response Property Should Be    .symbol    btcusd    3
    Response Property Should Be    .side    buy    3
    Response Property Should Be    .type    exchange market    3
    Response Property Should Be    .original_amount    0.00009    3
    Response Property Should Be    .executed_amount    0.00009    3
    Response Property Should Be    .src    web    3

    # LIMIT order
    Select Order Type    Limit
    Verify Limit Order Form Button
    Create Exchange Order    max_bid    0.00009    buy
    Create Exchange Order    min_ask    0.00009    sell
    Select Order Form Tab    Margin
    Scroll Down To Order Form
    Create Exchange Order    max_bid    0.00009    buy
    Create Exchange Order    min_ask    0.00009    sell
    
    Post Active Order
    Response Property Should Be    .symbol    btcusd
    Response Property Should Be    .side    buy
    Response Property Should Be    .type    exchange limit
    Response Property Should Be    .original_amount    0.00009
    Response Property Should Be    .remaining_amount    0.00009
    Response Property Should Be    .executed_amount    0.0
    Response Property Should Be    .src    web
    
    Response Property Should Be    .symbol    btcusd    1
    Response Property Should Be    .side    sell    1
    Response Property Should Be    .type    exchange limit    1
    Response Property Should Be    .original_amount    0.00009    1
    Response Property Should Be    .remaining_amount    0.00009    1
    Response Property Should Be    .executed_amount    0.0    1
    Response Property Should Be    .src    web    1

    Response Property Should Be    .symbol    btcusd    2
    Response Property Should Be    .side    buy    2
    Response Property Should Be    .type    limit    2
    Response Property Should Be    .original_amount    0.00009    2
    Response Property Should Be    .remaining_amount    0.00009    2
    Response Property Should Be    .executed_amount    0.0    2
    Response Property Should Be    .src    web    2
    
    Response Property Should Be    .symbol    btcusd    3
    Response Property Should Be    .side    sell    3
    Response Property Should Be    .type    limit    3
    Response Property Should Be    .original_amount    0.00009    3
    Response Property Should Be    .remaining_amount    0.00009    3
    Response Property Should Be    .executed_amount    0.0    3
    Response Property Should Be    .src    web    3
    
    Post Cancel All Orders
    # Exchange have Balance info in quote and base currency, the values are same to the available balance    

    # Open non-margin pairs, like AGI/USD (or any other without margin)  will have only Exchange
