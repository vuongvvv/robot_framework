*** Settings ***
Documentation    orders_api_test

Resource    ../../resources/init.robot
Resource    ../../keywords/bitfinex_v1/bitfinex_common.robot
Resource    ../../keywords/bitfinex_v1/orders_keywords.robot

Test Setup    Create Bitfinex V1 Session
Test Teardown     Delete All Sessions

*** Variables ***
${multiple_orders}    
*** Test Cases ***
orders_api_test
    [Documentation]    The tickers endpoint provides a high level overview of the state of the market. It shows the current best bid and ask, the last traded price, as well as information on the daily volume and price movement over the last day. The endpoint can retrieve multiple tickers with a single query.
    [Tags]    Regression    High    Smoke
    Post New Order    { "symbol": "btcusd", "amount": "0.02", "price": "5", "side": "buy", "type": "exchange limit", "ocoorder": false }
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    id    ORDER_ID
    # Post Multiple New Orders    { "orders": [{ "symbol": "btcusd", "amount": "0.02", "price": "5", "side": "buy", "type": "exchange limit" }, { "symbol": "btcusd", "amount": "0.02", "price": "5", "side": "buy", "type": "exchange limit" }]}
    # Response Correct Code    ${SUCCESS_CODE}
    # Fetch All Property Values    order_ids..id    ORDER_IDS
    
    # Post Cancel Multiple Order    [1232544905, 1232544906]
    # Post Cancel Order    1232543901
    # Post Cancel Order    1232543902
    
    # Post Cancel All Orders
    # Response Correct Code    ${SUCCESS_CODE}
    Post Order Status    ${ORDER_ID}
    Response Correct Code    ${SUCCESS_CODE}