*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/funding_pair_locators.robot

Resource    ../../common/mobile_common.robot

*** Keywords ***
Verify Chart Loading Success On Funding
    Wait Element Is Visible    ${btn_volume_on_chart_on_funding}
    
Tap On Back Button On Funding
    Click Visible Element    ${btn_back_on_trading_pair_on_funding}