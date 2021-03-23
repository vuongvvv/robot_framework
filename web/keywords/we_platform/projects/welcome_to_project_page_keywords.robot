*** Settings ***
Resource    ../../../../web/resources/locators/we_platform/projects/welcome_to_projects_page_locators.robot
Resource    ../../common/locator_common.robot

*** Keywords ***
Verify Project Information
    [Arguments]    ${project_name}    ${project_description}    ${project_code}
    Wait Until Element Is Visible    ${lbl_project_details}
    ${name_element}=    Generate Element From Dynamic Locator    ${lbl_project_information}    Name
    Element Should Contain    ${name_element}    ${project_name}
    ${description_element}=    Generate Element From Dynamic Locator    ${lbl_project_information}    Description
    Element Should Contain    ${description_element}    ${project_description}
    ${code_element}=    Generate Element From Dynamic Locator    ${lbl_project_information}    Code
    Element Should Contain    ${code_element}    ${project_code}

Select To Edit Current Project
    Click Element    ${btn_edit_project}

Select To Back To The Project Page
    Click Element    ${btn_back}
