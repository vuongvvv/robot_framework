*** Settings ***
Documentation    The tickers endpoint provides a high level overview of the state of the market. It shows the current best bid and ask, the last traded price, as well as information on the daily volume and price movement over the last day. The endpoint can retrieve multiple tickers with a single query.
...    https://docs.bitfinex.com/reference#rest-public-tickers

Resource    ../../resources/init.robot
Resource    ../../keywords/bitfinex/bitfinex_common.robot
Resource    ../../keywords/bitfinex/tickers_keywords.robot

Test Setup    Create Bitfinex Session
Test Teardown     Delete All Sessions

*** Variables ***

*** Test Cases ***
TICKERS_01
    [Documentation]    The tickers endpoint provides a high level overview of the state of the market. It shows the current best bid and ask, the last traded price, as well as information on the daily volume and price movement over the last day. The endpoint can retrieve multiple tickers with a single query.
    [Tags]    Regression    High    Smoke
    Get Tickers    symbols=tBTCUSD,tLTCUSD,fUSD
    Response Correct Code    ${SUCCESS_CODE}
    Verify Response Length    3
    Verify Response Field Is String    0
    Verify Response Field Is Number    1
    Get Tickers    symbols=tBTCUSD
    Response Correct Code    ${SUCCESS_CODE}
    Get Tickers    symbols=ALL
    Response Correct Code    ${SUCCESS_CODE}