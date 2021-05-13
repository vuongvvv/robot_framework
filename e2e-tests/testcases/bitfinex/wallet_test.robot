*** Settings ***
Documentation    Wallet
...    https://bitfinex.ontestpad.com/script/751#//

Resource    ../../../mobile/resources/init.robot
Resource    ../../../mobile/keywords/android/bitfinex/common_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/wallet_keywords.robot

Test Setup    Open Apps    Bitfinex
Test Teardown    Close Test Application

*** Test Cases ***
wallet_test
    [Documentation]    login_logout_test
    [Tags]     Smoke
    Tap On Navigation Tab By Name    Wallet
    Tap On I Button
    Tap On Okay Got It Button
    Tap On Eyes Icon
    Verify Balances Information Is Hidden
    Tap On Eyes Icon
    Verify Balances Information Is Shown
    Tap On Balances Button    Deposit
    Select Payment Type    Payment Card    0.000490
    
    # Tap On Balances Button    Conversion
    # Tap On Balances Button    Bitrefill
    # Tap On Balances Button    Reports