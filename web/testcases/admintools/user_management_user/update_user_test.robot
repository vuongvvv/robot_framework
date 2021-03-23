*** Settings ***
Documentation     Verify admin is able to create and update user via Admintools successfully

Resource    ../../../../web/resources/init.robot
Resource    ../../../keywords/admintools/main_page/login_keywords.robot
Resource    ../../../keywords/admintools/user_management_user/user_keywords.robot

Test setup    Open Browser With Option    ${ADMIN_TOOLS_URL}
Test teardown  Clean Environment

*** Variables ***
${edit_firstname}    Jonathan
${original_firstname}    John
${edit_lastname}    Bright
${original_lastname}    Mayer
${edit_email}    admin_tool_testing@ascendcorp.com
${original_email}    tester_admin_tool@ascendcorp.com
${edit_mobile}    66800311207
${original_mobile}    66811234567
${create_login}    66889990000
${create_firstname}    Automated QA
${create_lastname}    Test
${create_email}    ASC_QA_Test_
${create_phone}    660

*** Test Case ***
TC_O2O_01915
    [Documentation]    Can create user successfully
    [Tags]    Regression    E2E    Robot
    Login Backoffice   ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
    Click The Hamburger menu
    Navigate On Right Menu Bar    User Management    User
    Create New Random Account
    Search User    ${USER_LOGIN_NUMBER}
    Verify User Displays On Users Table    ${USER_LOGIN_NUMBER}    ${USER_EMAIL}    ${USER_MOBILE}

TC_O2O_01916
    [Documentation]    Can update user successfully
    [Tags]    Regression    Smoke    Robot
    Login Backoffice   ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
    Click The Hamburger Menu
    Navigate On Right Menu Bar    User Management    User
    Update User Account    ${USER_LOGIN_FOR_UPDATE}    ${edit_firstname}    ${edit_lastname}    ${edit_email}    ${edit_mobile}
    Search User    ${USER_LOGIN_FOR_UPDATE}
    Verify User Displays On Users Table    ${USER_LOGIN_FOR_UPDATE}    ${edit_email}    ${edit_mobile}
    Reverse Updated Account    ${USER_LOGIN_FOR_UPDATE}    ${original_firstname}    ${original_lastname}    ${original_email}    ${original_mobile}
