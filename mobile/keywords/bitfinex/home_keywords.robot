*** Settings ***
Resource    ../../resources/locators/android/bitfinex/home_locators.robot
Resource    ../../../utility/common/locator_common.robot

*** Keywords ***
Verify Account Buttons Display
    Wait Element Is Visible    ${btn_login}
    Wait Element Is Visible    ${btn_sign_up}    
    
Select Tab
    [Arguments]    ${tab_name}
    ${tab_locator}    Generate Element From Dynamic Locator    ${tab_by_tab_name}    ${tab_name}
    Click Visible Element    ${tab_locator}
    
Verify Banner Displays
    Wait Element Is Visible    ${btn_join_now}
    
Click Sign In Button
    Click Visible Element    ${btn_login}
    
Click Sign Up Button
    Click Visible Element    ${btn_sign_up}