*** Settings ***
Documentation    Login / Logout
...    https://bitfinex.ontestpad.com/script/51#//

Resource    ../../../mobile/resources/init.robot
Resource    ../../../mobile/resources/testdata/alpha/bitfinex_data.robot
Resource    ../../../mobile/keywords/bitfinex/common_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/login_keywords.robot
Resource    ../../../mobile/keywords/bitfinex/account_keywords.robot

Test Setup    Open Apps    Bitfinex
Test Teardown    Close Test Application

*** Test Cases ***
login_logout_test
    [Documentation]    login_logout_test
    [Tags]     smoke
    Tap On Login Button
    Tap On Add Key
    Login Bitfinex    ${TEST_DATA_STAGING_FULL_VERIFIED_API_KEY}    ${TEST_DATA_STAGING_FULL_VERIFIED_API_SECRET}
    Verify Create Pin Code Screen
    Enter Pin Code
    Enter Pin Code
    Verify Get Started Modal
    Close Get Started Modal
    Verify Affiliate Program Modal
    Tap On Navigation Tab By Name    Settings
    Logout Bitfinex App
    Verify Login Panel