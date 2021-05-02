*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/trading_pair_locators.robot

*** Keywords ***
Verify Chart Loading Success
    [Arguments]    ${expected_load_time}=5s
    Run Keyword And Continue On Failure    Wait Element Is Visible    ${btn_volume_on_chart}    ${expected_load_time}
    
Tap On Back Button
    Click Visible Element    ${btn_back_on_trading_pair}