*** Settings ***
Resource    ../../../resources/locators/truemoney_admin_portal/common/truemoney_admin_portal_common_locators.robot

*** Keywords ***
Login TrueMoney Admin Portal
    [Arguments]    ${user_name}    ${password}
    Input Text Into Visible Element    username   ${username}
    Input Text Into Visible Element    password   ${password}
    Click Visible Element    ${btn_login_truemoney_admin_portal}