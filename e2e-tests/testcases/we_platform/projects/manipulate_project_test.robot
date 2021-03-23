*** Settings ***
Documentation    Verify user can create / view detail / update and delete own projects
Resource    ../../../../web/resources/init.robot
Resource    ../../../../web/keywords/we_platform/login/login_keyword.robot
Resource    ../../../../web/keywords/we_platform/projects/create_or_edit_a_project_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/projects/projects_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/projects/welcome_to_project_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/common/common_keywords.robot
Test Setup    Open Browser With Option    ${WE_PLATFROM_URL}    headless_mode=${True}
Test Teardown    Clean Environment

*** Variables ***
${project_name}    MAT Pool
${project_description}    MAT Pool Is Very Good
${project_code}    ASC56TY
${edit_project_description}    MAT Pool Is Very Great
${edit_project_code}    BSC56T2

*** Test Cases ***
TC_O2O_10861
    [Documentation]    Verify user can manage their own projects
    [Tags]    Regression    E2E    High
    Login To We Platform Website    ${WE_PLATFORM_USER}    ${WE_PLATFORM_PASSWORD}
    Navigate To Main Menu And Sub Main Menu    Menu    Project
    Select To Create Project
    Generate Project Name    ${project_name}
    Create Project    ${RANDOM_PROJECT_NAME}    ${project_description}    ${project_code}
    Browsing Project Information    ${RANDOM_PROJECT_NAME}
    Verify Project Information    ${RANDOM_PROJECT_NAME}    ${project_description}    ${project_code}
    Select To Edit Current Project
    Edit Project Information    ${edit_project_description}    ${edit_project_code}
    Verify Project Information    ${RANDOM_PROJECT_NAME}    ${edit_project_description}    ${edit_project_code}
    Select To Back To The Project Page
    Delete Project    ${RANDOM_PROJECT_NAME}
