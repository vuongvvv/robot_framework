*** Settings ***
Resource    ../../../../web/resources/locators/we_platform/login/login_page_locators.robot

*** Keywords ***
Login To We Platform Website
    [Arguments]    ${we_platform_username}    ${we_platform_password}
    Click Visible Element    ${btn_signin}
    Input Text Into Visible Element    ${txt_username}    ${we_platform_username}
    Input Text Into Visible Element    ${txt_password}    ${we_platform_password}
    Click Visible Element    ${btn_signin_modal}