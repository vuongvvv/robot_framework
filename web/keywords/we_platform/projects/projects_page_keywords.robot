*** Settings ***
Resource    ../../../../web/resources/locators/we_platform/projects/projects_page_locators.robot
Resource    ../../../../web/keywords/common/locator_common.robot

*** Keywords ***
Delete Project
    [Arguments]    ${project_name}
    ${lbl_project_toggle_menu_locator}=    Generate Element From Dynamic Locator    ${lbl_project_toggle_menu}    ${project_name}
    ${lbl_delete_project_locator}=    Generate Element From Dynamic Locator    ${lbl_delete_project}    ${project_name}
    Click Visible Element    ${lbl_project_toggle_menu_locator}    
    Click Visible Element    ${lbl_delete_project_locator}
    Click Visible Element    ${btn_confirm_delete_project}

Clear All Projects
    [Arguments]    ${project_name}
    @{elements}=    Wait Until Keyword Succeeds    10s    2s    Verify Get WebElements    ${lbl_project_title}
    FOR    ${element}    IN    @{elements}
        ${is_element_contain}=    Run Keyword And Return Status    Element Should Contain    ${element}    ${project_name}
        Run Keyword If    ${is_element_contain}==${True}    Delete Project    ${element.text}            
    END

Wait Until Project Is Created
    [Arguments]    ${project_name}
    ${lbl_project_locator}=    Generate Element From Dynamic Locator    ${lbl_project_name}    ${project_name}
    Wait Until Element Is Visible    ${lbl_project_locator}    30

Select To Create Project
    Click Visible Element    ${btn_create_project}

Browsing Project Information
    [Arguments]    ${project_name}
    ${lbl_project_locator}=    Generate Element From Dynamic Locator    ${lbl_project_name}    ${project_name}
    Click Visible Element    ${lbl_project_locator}

Get Project Id
    Wait Until Element Is Enabled    ${lbl_project_id_path}    5
    ${PROJECT_ID}  Get Text  ${lbl_project_id_path}
    Set Test Variable    ${PROJECT_ID}

Verify Project Name
    [Arguments]    ${project_name}
    ${lbl_project_name_locator}=    Generate Element From Dynamic Locator    ${lbl_project_name}    ${project_name}
    Wait Until Element Is Visible   ${lbl_project_name_locator}