*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/derivatives_pair_locators.robot

*** Keywords ***
Verify Chart Loading Success On Derivatives
    [Arguments]    ${expected_load_time}=5s
    Run Keyword And Continue On Failure    Wait Element Is Visible    ${btn_volume_on_chart_on_derivatives}    ${expected_load_time}
    
Tap On Back Button On Derivatives
    Click Visible Element    ${btn_back_on_trading_pair_on_derivatives}