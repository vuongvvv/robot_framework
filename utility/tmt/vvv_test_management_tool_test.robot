*** Settings ***
Documentation    vvv_test_management_tool_test

Resource    ../../web/resources/init.robot
Resource    ../../web/keywords/test_management_tool/common_keywords.robot
Resource    ../../web/keywords/test_management_tool/login_keywords.robot
Resource    ../../web/keywords/test_management_tool/projects_keywords.robot
Resource    ../../web/keywords/test_management_tool/project_details_keywords.robot
Resource    ../../web/keywords/test_management_tool/execution_details_keywords.robot


Test Setup    Open Browser With Option    https://ascendtmt.tmn-dev.com/users/sign_in    JS_Site=${False}

*** Variables ***


*** Test Cases ***
vvv_test_management_tool_test
    [Documentation]    vvv_test_management_tool_test
    [Tags]     vvv_test_management_tool_test
    [Template]    Generate TMT Test Report
    O2O    2021.3.1 Release    2021.3.1 release test report
    
*** Keywords ***
Generate TMT Test Report
    [Arguments]    ${project}    ${release_name}    ${report_name}
    Login    vuong.van    3V@bkdn0707
    Select Project    ${project}
    Select Menu    Projects    View
    View Project    ${release_name}
    Select Tab    Executions
    View First Execution
    Create Report    ${report_name}    ${project}    ${release_name}