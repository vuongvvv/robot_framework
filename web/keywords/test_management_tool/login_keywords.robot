*** Settings ***
Resource    ../../resources/locators/test_management_tool/login_locators.robot

*** Keywords ***
Login
    [Arguments]    ${username}    ${password}
    Input Text Into Visible Element    ${txt_username}    ${username}
    Input Text Into Visible Element    ${txt_password}    ${password}
    Click Visible Element    ${btn_signin}
