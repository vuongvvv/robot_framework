*** Settings ***
Resource    ../../../../web/resources/locators/we_platform/projects/create_or_edit_a_project_page_locators.robot
Resource    ../../../../api/keywords/common/string_common.robot

*** Keywords ***
Create Project
    [Arguments]    ${project_name}    ${project_description}    ${project_code}
    Input Text Into Visible Element    ${txt_name}    ${project_name}
    Input Text Into Visible Element    ${txt_descrition}    ${project_description}
    Input Text Into Visible Element    ${txt_code}    ${project_code}
    Click Visible Element    ${btn_save}

Edit Project Information
    [Arguments]    ${project_description}    ${project_code}
    Input Text Into Visible Element    ${txt_descrition}    ${project_description}
    Input Text Into Visible Element    ${txt_code}    ${project_code}
    Click Visible Element    ${btn_save}

Generate Project Name
    [Arguments]  ${project_name}
    ${rand_str}=    Get Random Strings    6    [LETTERS][NUMBERS]
    Set Test Variable    ${RANDOM_PROJECT_NAME}    ${project_name}${rand_str}