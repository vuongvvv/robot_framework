*** Settings ***
Documentation    Verify Project owner can add member in project  / member view detail after assign
Resource    ../../../../web/resources/init.robot
Resource    ../../../../web/keywords/we_platform/login/login_keyword.robot
Resource    ../../../../web/keywords/we_platform/projects/create_or_edit_a_project_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/members/members_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/projects/projects_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/projects/welcome_to_project_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/common/common_keywords.robot
Test Setup    Open Browser With Option    ${WE_PLATFROM_URL}
Test Teardown    Clean Environment

*** Variables ***
${project_description}    Test robot joker
${project_code}    Test robot joker
${member_role}     Owner
${project_name}    TestMember

*** Test Cases ***
TC_O2O_07822
    [Documentation]    Verify Project owner add member in project
    [Tags]    Regression    Smoke    E2E    High    joker    webackoffice
    Login To We Platform Website    ${WE_PLATFORM_USER}     ${WE_PLATFORM_PASSWORD}
    Navigate To Main Menu And Sub Main Menu    Menu    Project
    Clear All Projects    ${project_name}
    Select To Create Project
    Generate Project Name   ${project_name}
    Create Project    ${RANDOM_PROJECT_NAME}    ${project_description}    ${project_code}
    Browsing Project Information   ${RANDOM_PROJECT_NAME}
    Navigate To Left Menu     Settings   Members
    Add Member To Projects   ${WE_PLATFORM_MEMBERS_ID}   ${member_role}
    Navigate To Main Menu And Sub Main Menu    Account    Sign out
    Login To We Platform Website    ${WE_PLATFORM_MEMBERS_USER}    ${WE_PLATFORM_MEMBERS_PASSWORD}
    Navigate To Main Menu And Sub Main Menu    Menu    Project
    Verify Project Name  ${RANDOM_PROJECT_NAME}
    Delete Project       ${RANDOM_PROJECT_NAME}