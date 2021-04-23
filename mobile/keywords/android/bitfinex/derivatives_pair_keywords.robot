*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/derivatives_pair_locators.robot

Resource    ../../common/mobile_common.robot

*** Keywords ***
Verify Chart Loading Success On Derivatives
    Wait Element Is Visible    ${btn_volume_on_chart_on_derivatives}
    
Tap On Back Button On Derivatives
    Click Visible Element    ${btn_back_on_trading_pair_on_derivatives}