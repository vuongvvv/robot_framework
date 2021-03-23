*** Settings ***
Resource    ../../resources/locators/test_management_tool/common_locators.robot
Resource    ../common/locator_common.robot

*** Keywords ***
Select Project
    [Arguments]    ${project_name}
    Hover On Element    ${mnu_product}
    ${mnu_sub_menu}    Generate Element From Dynamic Locator    ${mnu_sub_product}    ${project_name}
    Click Visible Element    ${mnu_sub_menu}
    
Select Menu
    [Arguments]    ${menu}    ${sub_menu}
    ${mnu_main}    Generate Element From Dynamic Locator    ${mnu_main_menu}    ${menu}
    Wait Until Element Is Interactable    ${mnu_main}
    Hover On Element    ${mnu_main}
    ${mnu_sub}    Generate Element From Dynamic Locator    ${mnu_sub_menu_on_test_management_tool}    ${menu}    ${sub_menu}
    Wait Until Element Is Interactable    ${mnu_sub}
    Click Visible Element    ${mnu_sub}
