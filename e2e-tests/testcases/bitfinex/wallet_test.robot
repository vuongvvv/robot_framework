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
    [Documentation]    wallet_test
    [Tags]     Smoke
    Tap On Navigation Tab By Name    Wallet
    Tap On I Button
    Tap On Okay Got It Button
    Tap On Eyes Icon
    Verify Balances Information Is Hidden
    Tap On Eyes Icon
    Verify Balances Information Is Shown
    
    Search For Currency On Balance    BTC
    Verify Currency On Balances Table    BTC
    Tap On Clear Search Button
    Search For Currency On Balance    BITCOIN
    Verify Currency On Balances Table    BTC
    Tap On Clear Search Button
    
    Tap On Cog Icon Button
    Configure Hide Small Balances
    Verify Currency On Balances Table    LBTC
    Tap On Cog Icon Button
    Configure Hide Small Balances
    Verify Currency On Balances Table    LBTC
    
    Tap On Balances Button    Deposit
    Tap On I Button On Deposit Panel
    Tap On Okay Got It Button
    Select Payment Type    Payment Card    0.000490
    
    Swipe Back To Top
    Tap On Balances Button    Conversion
    Select Currency Conversion    50
    
    Swipe Back To Top
    # Tap On Balances Button    Bitrefill
    # Tap On Balances Button    Reports