*** Settings ***
Resource    ../../../resources/locators/admintools/login_page/login_trueid_locators.robot
Resource    ../../../resources/locators/admintools/main_page/main_page_locators.robot

*** Keywords ***
Login TrueId
    [Arguments]    ${mobile_phone}    ${password}
    Wait Until Element Is Visible    ${txt_mobile_phone_or_email}
    Input Text Into Visible Element    ${txt_mobile_phone_or_email}    ${mobile_phone}
    Input Text Into Visible Element    ${txt_password}    ${password}
    Click Visible Element    ${btn_login}
    Wait Until Element Is Visible    ${lbl_admintools}