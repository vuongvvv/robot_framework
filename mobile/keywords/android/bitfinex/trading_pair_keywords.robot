*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/trading_pair_locators.robot

*** Keywords ***
Verify Chart Loading Success
    Wait Element Is Visible    ${btn_volume_on_chart}
    
Tap On Back Button
    Click Visible Element    ${btn_back_on_trading_pair}