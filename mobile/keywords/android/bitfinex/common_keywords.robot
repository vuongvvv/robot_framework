*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/common_locators.robot
Resource    ../../../../utility/common/locator_common.robot
Resource    ../../common/mobile_common.robot

*** Keywords ***
Tap On Navigation Tab By Name
    [Arguments]    ${tab_name}
    ${tab_locator}    Generate Element From Dynamic Locator    ${tab_navigation_by_name}    ${tab_name}
    Wait Element Is Visible    ${tab_locator}
    Click Visible Element    ${tab_locator}
    
Tap On Login Button
    Wait Element Is Visible    ${btn_login}
    Click Visible Element    ${btn_login}
    
Verify Affiliate Program Modal
    Wait Element Is Visible    ${btn_join_now_on_affiliate_program}    
    
Verify Login Panel
    Wait Element Is Visible    ${btn_login}    
    Wait Element Is Visible    ${btn_signup}
    
Tap On Back Button
    Click Visible Element    ${btn_back_on_screen}