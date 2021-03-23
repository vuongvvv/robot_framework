*** Settings ***
Documentation    Verify TrueId user can login and logout Admintools
Resource    ../../../resources/init.robot
Resource    ../../../keywords/admintools/login_page/login_keywords.robot
Resource    ../../../keywords/admintools/login_page/login_trueid_keywords.robot
Resource    ../../../keywords/admintools/common/common_keywords.robot

Test Setup    Open Browser With Option    ${ADMIN_TOOLS_URL}
Test Teardown    Clean Environment

*** Test Cases ***
TC_O2O_01498
    [Documentation]    [TrueID Integration] Logged to the account successful
    [Tags]    Regression    E2E    High    o2o-admintools
    Click Signin Button
    Click Login TrueID Button
    Switch To Non Angular JS Site
    Login TrueId    ${TRUE_ID_USER}    ${TRUE_ID_USER_PASSWORD}
    Switch To Angular JS Site
    Logout Admintools
    Switch To Non Angular JS Site
    Verify Login Page Displays
    Switch To Angular JS Site