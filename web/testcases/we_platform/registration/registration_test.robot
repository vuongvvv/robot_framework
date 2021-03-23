*** Settings ***
Documentation    Verify registration account
Resource    ../../../../web/resources/init.robot
Resource    ../../../keywords/we_platform/common/common_keywords.robot
Resource    ../../../keywords/we_platform/registration/registration_keyword.robot
Test Setup    Open Browser With Option    ${WE_PLATFROM_URL}
Test Teardown    Clean Environment

*** Variables ***
${mobile_login}    66639202331
${user_login}    qa.automation
${email}    o2o.qatesting@gmail.com
${password}    TestAscend1234

*** Test Cases ***
TC_O2O_19175
    [Documentation]    Register account with valid information
    [Tags]    Regression    High    Smoke
    Navigate To Main Menu And Sub Main Menu    Account    Register
    Register Account    ${mobile_login}    ${user_login}    ${email}    ${password}
    Verify Register Account Successful