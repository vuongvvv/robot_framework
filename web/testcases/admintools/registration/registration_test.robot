*** Settings ***
Documentation    Verify registration account
Resource    ../../../../web/resources/init.robot
Resource    ../../../keywords/admintools/common/common_keywords.robot
Resource    ../../../keywords/admintools/registration/registration_keyword.robot
Test Setup    Open Browser With Option    ${ADMIN_TOOLS_URL}
Test Teardown    Clean Environment

*** Variables ***
${mobile_login}    66639202331
${user_login}    qa.automation
${email}    o2o.qatesting@gmail.com
${password}    TestAscend1234

*** Test Cases ***
TC_O2O_19176
    [Documentation]    [AdminTools] Register account with existing information
    [Tags]    Regression    High    Smoke
    Navigate To Main Menu And Sub Main Menu    Account    Register
    Register Account    ${user_login}    ${mobile_login}    ${email}    ${password}
    Verify Registration Account Error Displays