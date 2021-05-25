*** Settings ***
Resource    ../../resources/locators/android/bitfinex/account_locators.robot
Resource    ../common/mobile_common.robot

*** Keywords ***
Logout Bitfinex App
    Swipe Down To Element    ${mnu_log_out}
    Click Visible Element    ${mnu_log_out}
    Click Visible Element    ${btn_confirm_on_logout_modal}