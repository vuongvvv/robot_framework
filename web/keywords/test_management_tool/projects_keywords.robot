*** Settings ***
Resource    ../../resources/locators/test_management_tool/projects_locators.robot

*** Keywords ***
View Project
    [Arguments]    ${project_name}
    ${btn_view_project}    Generate Element From Dynamic Locator    ${btn_view_by_project_name}    ${project_name}
    Click Visible Element    ${btn_view_project}