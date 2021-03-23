*** Settings ***
Resource    ../../resources/locators/vm_cms/login_page_locators.robot

*** Keywords ***
Login To Vending Machine CMS
    [Arguments]    ${email}    ${password}
    Input Text    ${txt_email}    ${email}
    Input Text    ${txt_password}    ${password}
    Click Element    ${btn_signin}