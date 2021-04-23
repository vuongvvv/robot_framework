*** Settings ***

Resource    ../../../mobile/resources/init.robot
Resource    ../../../mobile/keywords/android/bitfinex/common_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/trading_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/trading_pair_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/derivatives_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/derivatives_pair_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/funding_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/funding_pair_keywords.robot

Test Setup    Open Apps    Bitfinex.apk
Test Teardown    Close Test Application
*** Variables ***

*** Test Cases ***
trades_pair_transition_test
    [Documentation]    trades_pair_transition_test
    [Tags]     E2E
    Verify Trading Chart Loading Pair    BTCUSD    USD
    Verify Trading Chart Loading Pair    ETHUSD    USD
    Tap On Navigation Tab By Name    Derivative
    Verify Derivatives Chart Loading Pair    BTC-PERP    BTC-PERP
    Tap On Navigation Tab By Name    Funding
    Verify Funding Chart Loading Pair    USD    USD

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
    
Verify Funding Chart Loading Pair
    [Arguments]    ${ticker}    ${pair}
    Search Ticker On Funding    ${ticker}
    Access Trading Pair On Funding    ${pair}
    Verify Chart Loading Success On Funding
    Tap On Back Button On Funding
    Clear Ticker Search On Funding