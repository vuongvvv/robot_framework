*** Settings ***
Documentation    authenticated_api_test

Resource    ../../resources/init.robot
Resource    ../../keywords/bitfinex_v1/bitfinex_common.robot
Resource    ../../keywords/bitfinex_v1/authenticated_api_keywords.robot

Test Setup    Create Bitfinex V1 Session
Test Teardown     Delete All Sessions

*** Variables ***

*** Test Cases ***
authenticated_api_test
    [Documentation]    The tickers endpoint provides a high level overview of the state of the market. It shows the current best bid and ask, the last traded price, as well as information on the daily volume and price movement over the last day. The endpoint can retrieve multiple tickers with a single query.
    [Tags]    Regression    High    Smoke
    Post Account Infor
    Response Correct Code    ${SUCCESS_CODE}
    Post Account Fee
    Response Correct Code    ${SUCCESS_CODE}