*** Settings ***

Resource    ../../../mobile/resources/init.robot
Resource    ../../../mobile/keywords/android/bitfinex/common_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/trading_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/trading_pair_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/derivatives_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/derivatives_pair_keywords.robot

Test Setup    Open Apps    Bitfinex.apk
*** Variables ***

*** Test Cases ***
trades_pair_transition_test
    [Documentation]    trades_pair_transition_test
    [Tags]     E2E
    Verify Trading Chart Loading Pair    BTCUSD    USD
    Verify Trading Chart Loading Pair    ETHUSD    USD

derivatives_pair_transition_test
    [Documentation]    derivatives_pair_transition_test
    [Tags]     E2E
    Tap On Navigation Tab By Name    Derivative
    Verify Trading Chart Loading Pair    BTC-PERP    BTC-PERP
    
    
*** Keywords ***
Verify Trading Chart Loading Pair
    [Arguments]    ${ticker}    ${pair}
    Search Ticker    ${ticker}
    Access Trading Pair    ${pair}
    Verify Chart Loading Success
    Tap On Back Button
    Clear Ticker Search
    
Verify Derivatives Chart Loading Pair
    [Arguments]    ${ticker}    ${pair}
    Search Ticker On Derivatives    ${ticker}
    Access Trading Pair On Derivatives    ${pair}
    Verify Chart Loading Success On Derivatives
    Tap On Back Button On Derivatives
    Clear Ticker Search On Derivatives