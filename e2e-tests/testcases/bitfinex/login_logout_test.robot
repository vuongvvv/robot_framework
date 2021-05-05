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
login_logout_test
    [Documentation]    login_logout_test
    [Tags]     E2E
    # Login button tap will open Login screen > Tap X to return
    # Trading: Only TICKERS panel displays
    Verify Ticker Panel Displays
    # Derivatives have only Ticker subtitle test same functionalities as for trading
    Tap On Navigation Tab By Name    Derivative
    Verify Ticker Panel Displays On Derivatives    
    # Funding have only ticker without quote currency filter, test same functionalities as for trading
    # Wallets is empty and have only Login button
    # Tap on Account tab