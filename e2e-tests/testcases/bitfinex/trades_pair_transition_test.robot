*** Settings ***

Resource    ../../../mobile/resources/init.robot
Resource    ../../../mobile/keywords/android/bitfinex/common_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/trading_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/trading_pair_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/derivatives_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/derivatives_pair_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/funding_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/funding_pair_keywords.robot

# Test Setup    Open Apps    Bitfinex
Test Setup    Open App On Browser Stack
Test Teardown    Close Test Application
*** Variables ***
${expected_chart_loading_time}    5s

*** Test Cases ***
trades_pair_transition_test
    [Documentation]    trades_pair_transition_test
    [Tags]     E2E
    Verify Trading Chart Loading Pair    BTCUSD    BTCUSD
    Verify Trading Chart Loading Pair    ETHUSD    ETHUSD
    Verify Trading Chart Loading Pair    USTUSD    USTUSD
    Verify Trading Chart Loading Pair    ETHBTC    ETHBTC
    Verify Trading Chart Loading Pair    BTCEUR    BTCEUR
    Tap On Navigation Tab By Name    Derivative
    Verify Derivatives Chart Loading Pair    BTC-PERP    BTCF0:USTF0
    Verify Derivatives Chart Loading Pair    LTC-PERP    LTCF0:USTF0
    Verify Derivatives Chart Loading Pair    XAUT-PERP    XAUTF0:USTF0
    Verify Derivatives Chart Loading Pair    EUROPE50-PERP    EUROPE50IXF0:USTF0
    Verify Derivatives Chart Loading Pair    JPY-PERP    JPYF0:USTF0
    Tap On Navigation Tab By Name    Funding
    Verify Funding Chart Loading Pair    USD    USD
    Verify Funding Chart Loading Pair    BTC    BTC
    Verify Funding Chart Loading Pair    ETC    ETC
    Verify Funding Chart Loading Pair    UST    UST
    Verify Funding Chart Loading Pair    LEO    LEO

*** Keywords ***
Verify Trading Chart Loading Pair
    [Arguments]    ${ticker}    ${pair}
    Search Ticker    ${ticker}
    Access Trading Pair    ${pair}
    Verify Chart Loading Success    ${expected_chart_loading_time}
    Tap On Back Button
    Clear Ticker Search
    
Verify Derivatives Chart Loading Pair
    [Arguments]    ${ticker}    ${pair}
    Search Ticker On Derivatives    ${ticker}
    Access Trading Pair On Derivatives    ${pair}
    Verify Chart Loading Success On Derivatives    ${expected_chart_loading_time}
    Tap On Back Button
    Clear Ticker Search On Derivatives
    
Verify Funding Chart Loading Pair
    [Arguments]    ${ticker}    ${pair}
    Search Ticker On Funding    ${ticker}
    Access Trading Pair On Funding    ${pair}
    Verify Chart Loading Success On Funding    ${expected_chart_loading_time}
    Tap On Back Button
    Clear Ticker Search On Funding