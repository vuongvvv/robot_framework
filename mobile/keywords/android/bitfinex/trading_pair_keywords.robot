*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/trading_pair_locators.robot

Resource    ../../common/mobile_common.robot

*** Keywords ***
Verify Chart Loading Success
    Wait Element Is Visible    ${btn_volume_on_chart}
    
Tap On Back Button
    Click Visible Element    ${btn_back_on_trading_pair}