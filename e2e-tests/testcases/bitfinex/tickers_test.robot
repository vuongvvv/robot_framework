*** Settings ***

Resource    ../../../mobile/resources/init.robot
Resource    ../../../mobile/keywords/android/bitfinex/home_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/login_keywords.robot
Resource    ../../../mobile/keywords/android/bitfinex/trading_keywords.robot

*** Variables ***

*** Test Cases ***
tickers
    [Documentation]    tickers
    [Tags]     E2E
    Open Apps    mobile-4.0.0.apk
    # Tickers is expanded tap on header to check is it collapsible 
    Verify Tickers
    Click Collapse Ticker    2
    Verify Tickers Disappear
    Click Collapse Ticker
    Verify Tickers
    
    # First time accounts without any starred items, "All" tab is shown as default
    Select Starred Tab
    Verify Tickers Table Has No Data
    Select All Tab
    
    Click Tickers Table Column Header    NAME
    Verify Column Data Sorting By Screenshot    NAME    asc
    Click Tickers Table Column Header    NAME
    Verify Column Data Sorting By Screenshot    NAME    desc
    Click Tickers Table Column Header    LAST
    Verify Column Data Sorting By Screenshot    LAST    asc
    Click Tickers Table Column Header    LAST
    Verify Column Data Sorting By Screenshot    LAST    desc
    Click Tickers Table Column Header    24H
    Verify Column Data Sorting By Screenshot    24H    asc
    Click Tickers Table Column Header    24H
    Verify Column Data Sorting By Screenshot    24H    desc
    
    # Type non-existing ticker pair will show No ticker found
    Search Ticker    NONEXIST
    Verify Tickers Table Has No Data
    Clear Ticker Search
    
    # Type ticker without "/" character between will recognize that ticker
    Search Ticker    USDBTC
    Verify Filter Ticker By Screenshot    SEARCH WITHOUT / CHAR
    Clear Ticker Search
    
    # Type Bitcoin will recognize all BTC tickers
    Search Ticker    BTC
    Verify Filter Ticker By Screenshot    SEARCH WITH BTC
    Clear Ticker Search
    
    # Type BTC/USD will show that result
    Search Ticker    BTC/US
    Verify Filter Ticker By Screenshot    SEARCH WITH BTC/USD
    
    # Tap X will reset search
    Clear Ticker Search
    Verify Filter Ticker By Screenshot    RESET SEARCH
    
    # Selecting currency will filter search for that selected currency
    # For example BTC will filter results to all CCY/BTC ccy(any currency)
    # Drop-down will open new screen with X and radio button list that should match to web app ticker dropdown 
    Click Currency Filter
    Select Currency    USD
    Verify Filter Ticker By Screenshot    USD FILTER
    Click Currency Filter
    Select Currency    Any
    Verify Filter Ticker By Screenshot    ALL CURRENCY