*** Settings ***

Resource    ../../../mobile/resources/init.robot
Resource    ../../../mobile/keywords/android/bitfinex/trading_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/trading_pair_keywords.robot

*** Variables ***

*** Test Cases ***
trades_pair_transition_test
    [Documentation]    trades_pair_transition_test
    [Tags]     E2E
    Open Apps    Bitfinex.apk
    # Search Ticker    BTCUSD
    # Access Trading Pair    USD
    # Verify Chart Loading Success
    Verify Chart Loading Pair    BTCUSD    USD
    Verify Chart Loading Pair    ETHUSD    USD

*** Keywords ***
Verify Chart Loading Pair
    [Arguments]    ${ticker}    ${pair}
    Search Ticker    ${ticker}
    Access Trading Pair    ${pair}
    Verify Chart Loading Success
    Tap On Back Button
    Clear Ticker Search