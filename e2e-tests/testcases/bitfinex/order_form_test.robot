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
${expected_chart_loading_time}    5s

*** Test Cases ***
order_form_test
    [Documentation]    order_form_test
    [Tags]     E2E
    Search Ticker    BTCUSD
    Access Trading Pair    BTCUSD
    Scroll Down To Order Form
    # - Submitting the form with invalid number values should highlight the fields in red
    # - taping on book rows in order book should populate the  price you selected and max amount 
    # - order form is collapsible by taping on the header
    # - there are 2 tabs: Exchange and Margin
    # Exchange have Balance info in quote and base currency, the values are same to the available balance
    # - switching to Margin tab reveals  
        # the reduce-only option checkbox appears 
        # and the buttons change from Exchange Buy & Sell to Margin Buy & Sell

    # Open non-margin pairs, like AGI/USD (or any other without margin)  will have only Exchange   