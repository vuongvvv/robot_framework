*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/create_account_locators.robot
Resource    ../../common/mobile_common.robot

*** Keywords ***
Fill Account Information
    [Arguments]    ${username}=${None}    ${email}=${None}    ${password}=${None}    ${confirm_password}=${None}    ${password_acknowledge}=${True}    ${time_zone}=${None}
    Run Keyword If    '${username}'!='${None}'    Input Text Into Element    ${txt_username}    ${username}    
    Run Keyword If    '${email}'!='${None}'    Input Text Into Element    ${txt_email}    ${email}    
    Run Keyword If    '${password}'!='${None}'    Input Text Into Element    ${txt_password}    ${password}    
    Run Keyword If    '${confirm_password}'!='${None}'    Input Text Into Element    ${txt_confirm_password}    ${confirm_password}    
    Run Keyword If    '${confirm_password}'!='${None}'    Input Text Into Element    ${txt_confirm_password}    ${confirm_password}    
    Run Keyword If    ${password_acknowledge}==${True}    Input Text Into Element    ${txt_confirm_password}    ${confirm_password}    
    
Close Login Screen
    Click Visible Element    ${btn_close_create_account_screen}