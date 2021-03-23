*** Settings ***
Resource    ../../../../web/resources/locators/audit_web/login/login_page_locators.robot

*** Keywords ***
Login To Audit Web
    [Arguments]    ${username}    ${password}
    Input Text Into Visible Element    ${txt_username}    ${username}
    Input Text Into Visible Element    ${txt_password}    ${password}
    Click Visible Element    ${btn_signin}
    Wait Until Page Contains    Login Success

