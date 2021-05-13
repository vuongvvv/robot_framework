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
    
Tap On Add Key
    Click Visible Element    ${tab_add_key}
    
Login Bitfinex
    [Arguments]    ${public_key}    ${secret_key}
    Input Text Into Element    ${txt_public_key}    ${public_key}
    Input Text Into Element    ${txt_secret_key}    ${secret_key}
    Swipe Down To Element    ${btn_login_on_login_screen}
    Click Visible Element    ${btn_login_on_login_screen}
    
Verify Create Pin Code Screen
    Wait Element Is Visible    ${lbl_create_pin_code}
    Wait Element Is Visible    ${btn_skip_app_protection_on_login}
    
Enter Pin Code
    Input Text Into Element    ${txt_pin_code_1}    8
    Input Text Into Element    ${txt_pin_code_2}    8
    Input Text Into Element    ${txt_pin_code_3}    8
    Input Text Into Element    ${txt_pin_code_4}    8
    
Verify Get Started Modal
    Wait Element Is Visible    ${lbl_get_started_on_get_started_modal}
    
Close Get Started Modal
    Click Visible Element    ${btn_close_on_get_started_modal}    