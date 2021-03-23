*** Settings ***
Resource    ../../../../web/resources/init.robot
Resource    ../../../resources/locators/admintools/user_management_user/user_locators.robot
Resource    ../../../../web/keywords/common/locator_common.robot

*** Keywords ***
Random Login Number
    ${numbers}=    Evaluate    random.randint(100000000000, 999999999999)    random
    ${login_number}=    Convert To String    ${numbers}
    Set Test Variable    ${USER_LOGIN_NUMBER}    ${login_number}
    [Return]    ${login_number}

Random Email
    ${numbers}=    Evaluate    random.randint(1, 9999)    random
    ${random_email}=    Catenate    SEPARATOR=${numbers}    ${create_email}    @mailinator.com
    Set Test Variable    ${USER_EMAIL}    ${random_email}
    [Return]    ${random_email}

Random Phone Number
    ${numbers}=    Evaluate    random.randint(10000000, 99999999)    random
    ${phone_number}=    Catenate    SEPARATOR=    ${create_phone}    ${numbers}
    Set Test Variable    ${USER_MOBILE}    ${phone_number}
    [Return]    ${phone_number}

Create New Random Account
    Click Button    ${btn_create_user}
    Wait Until Element Is Visible    ${lbl_create_edit_user}
    ${login_number}=    Random Login Number
    ${random_email}=    Random Email
    ${phone_number}=    Random Phone Number
    Press Keys    ${txt_create_login}    ${login_number}
    Press Keys    ${txt_edit_firstname}    ${create_firstname}
    Press Keys    ${txt_edit_lastname}    ${create_lastname}
    Press Keys    ${txt_edit_email}    ${random_email}
    Press Keys    ${txt_edit_mobile}    ${phone_number}
    Select From List By Label    ${ddl_language}    ไทย
    Click Element    ${dbl_user_role}
    Click Button    ${btn_submit}

Search User
    [Arguments]    ${login}
    Input Text    ${txt_search_login}    ${login}
    Wait Until Element Is Visible    ${btn_search}
    Click Button    ${btn_search}

Verify User Displays On Users Table
    [Arguments]    ${login}    ${email}    ${mobile}
    ${login_element}=    Generate Element From Dynamic Locator    ${tbl_information_cell}    ${login}
    ${email_element}=    Generate Element From Dynamic Locator    ${tbl_information_cell}    ${email}
    ${mobile_element}=    Generate Element From Dynamic Locator    ${tbl_information_cell}    ${mobile}
    Wait Until Element Is Visible    ${login_element}
    Element Should Be Visible    ${login_element}
    Element Should Be Visible    ${email_element}
    Element Should Be Visible    ${mobile_element}

Update User Account
    [Arguments]    ${user_login_update}    ${edit_firstname}    ${edit_lastname}    ${edit_email}    ${edit_mobile}
    Press Keys    ${txt_search_login}    ${user_login_update}
    Wait Until Element Is Visible    ${btn_search}
    Click Button    ${btn_search}
    Wait Until Element Is Visible    ${btn_edit}
    Click Button    ${btn_edit}
    Wait Until Element Is Visible    ${lbl_create_edit_user}
    Clear Element Text    ${txt_edit_firstname}
    Press Keys    ${txt_edit_firstname}    ${edit_firstname}
    Clear Element Text    ${txt_edit_lastname}
    Press Keys    ${txt_edit_lastname}    ${edit_lastname}
    Clear Element Text    ${txt_edit_email}
    Press Keys    ${txt_edit_email}    ${edit_email}
    Clear Element Text    ${txt_edit_mobile}
    Press Keys    ${txt_edit_mobile}    ${edit_mobile}
    Click Button    ${btn_save}
    Wait Until Element Is Visible    ${lbl_users}

Reverse Updated Account
    [Arguments]    ${user_login_update}    ${original_firstname}    ${original_lastname}    ${original_email}    ${original_mobile}
    Open Browser With Option    ${ADMIN_TOOLS_URL}
    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
    Click The Hamburger Menu
    Navigate On Right Menu Bar    User Management    User
    Press Keys    ${txt_search_login}    ${user_login_update}
    Click Button    ${btn_search}
    Wait Until Element Is Visible    ${btn_edit}
    Click Button    ${btn_edit}
    Wait Until Element Is Visible    ${lbl_create_edit_user}
    Clear Element Text    ${txt_edit_firstname}
    Press Keys    ${txt_edit_firstname}    ${original_firstname}
    Clear Element Text    ${txt_edit_lastname}
    Press Keys    ${txt_edit_lastname}    ${original_lastname}
    Clear Element Text    ${txt_edit_email}
    Press Keys    ${txt_edit_email}    ${original_email}
    Clear Element Text    ${txt_edit_mobile}
    Press Keys    ${txt_edit_mobile}    ${original_mobile}
    Click Button    ${btn_save}
