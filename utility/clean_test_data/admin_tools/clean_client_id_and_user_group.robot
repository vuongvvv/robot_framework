*** Settings ***
Documentation    Clean test data on AdminTools

Resource    ../../../api/resources/init.robot
Resource    ../../../web/resources/init.robot
Resource    ../../../web/keywords/admintools/common/common_keywords.robot
Resource    ../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../web/keywords/admintools/client/client_keywords.robot
Resource    ../../../web/keywords/admintools/user_management_user/user_group_keywords.robot
Test Setup    Open Browser With Option    ${ADMIN_TOOLS_URL}    headless_mode=${False}
Test Teardown    Clean Environment

*** Test Cases ***
CLEAN_CLIENT_IDS
    [Documentation]    Draft test case to create e2e-tests folder
    Login Backoffice    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
    Navigate On Left Menu Bar    Application    Client
    Delete All Client Id Matched Pattern    TC_O2O
    
CLEAN_USER_GROUPS
    [Documentation]    Draft test case to create e2e-tests folder
    Login Backoffice    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
    Navigate On Left Menu Bar    User Management    User Group
    Delete All User Group Matched Pattern    TC_O2O