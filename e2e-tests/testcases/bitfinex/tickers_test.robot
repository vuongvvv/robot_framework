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