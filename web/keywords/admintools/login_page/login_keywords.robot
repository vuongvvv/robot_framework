*** Settings ***
Resource    ../../../resources/locators/admintools/login_page/login_locators.robot

*** Keywords ***
Click Signin Button
    Click Visible Element    ${btn_signin}

Click Login TrueID Button
    Click Visible Element    ${btn_login_true_id}

Verify Login Page Displays
    Wait Until Element Is Visible    ${btn_signin}