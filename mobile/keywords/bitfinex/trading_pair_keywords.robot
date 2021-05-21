*** Settings ***
Resource    ../../resources/locators/android/bitfinex/trading_pair_locators.robot

Resource    ../common/mobile_common.robot
*** Keywords ***
Verify Chart Loading Success
    [Arguments]    ${expected_load_time}=5s
    Run Keyword And Continue On Failure    Wait Element Is Visible    ${btn_volume_on_chart}    ${expected_load_time}
    
Scroll Down To Order Form
    Swipe Down To Element    ${btn_exchange_buy_on_order_form_trading}