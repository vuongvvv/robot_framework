*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/login_locators.robot
Resource    ../../common/mobile_common.robot

*** Keywords ***
Verify Login Screen
    Wait Element Is Visible    ${tab_scan_qr}
    Wait Element Is Visible    ${tab_add_key}
    Wait Element Is Visible    ${btn_need_login_help}
    
Close Login Screen
    Click Visible Element    ${btn_close_login_screen}