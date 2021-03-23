*** Settings ***
Resource    ../../resources/locators/test_management_tool/project_details_locators.robot

*** Keywords ***
Select Tab
    [Arguments]    ${tab_name}
    ${tab_to_select}    Generate Element From Dynamic Locator    ${tab_by_name}    ${tab_name}
    Click Visible Element    ${tab_to_select}
    
View First Execution
    Click Visible Element    ${btn_view_first_row}