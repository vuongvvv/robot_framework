*** Settings ***
Resource    ../../../../web/resources/locators/we_platform/content_types/content_types_page_locators.robot
Resource    ../../common/locator_common.robot

*** Keywords ***
Select To See Content Of Content Types By Name And Alias
    [Arguments]    ${content_types_name}    ${alias}
    ${lbl_content_types_name_locator}=    Generate Element From Dynamic Locator    ${lbl_content_types_name}    ${alias}    ${content_types_name}
    Click Element    ${lbl_content_types_name_locator}

Press Content Types Button By Name And Alias
    [Arguments]    ${button_wording}    ${content_types_name}    ${alias}
    #${button_wording} should be case sensitive as same as UI
    ${btn_view_locator}=    Generate Element From Dynamic Locator    ${cnt_type_button}    ${content_types_name}   ${alias}    ${button_wording}
    Wait Until Element Is Visible    ${btn_view_locator}
    Click Element    ${btn_view_locator}

Click Create New Content Type Button
    Wait Until Keyword Succeeds  1s  0.1s  Click Element    ${btn_create_a_new_content_type}

Press Confirm Delete Button On Popup By Content Type Name
    [Arguments]    ${content_types_Name}
    Wait Until Element Is Visible    ${pup_confirm_delete}
    Input Text     ${pup_confirm_delete}    ${content_types_Name}
    Click Element  ${btn_confirm_delete}

Delete Content Types By Name And Alias
    [Arguments]    ${content_types_name}    ${alias}
    Press Content Types Button By Name And Alias    Delete    ${content_types_name}    ${alias}
    Press Confirm Delete Button On Popup By Content Type Name   ${content_types_Name}
    
Click Edit Button By Alias
    [Arguments]    ${content_type_alias}
    ${btn_edit}    Generate Element From Dynamic Locator    ${btn_edit_content_type_by_alias}    ${content_type_alias}
    Click Visible Element    ${btn_edit}
    
Click View Button By Alias
    [Arguments]    ${content_type_alias}
    ${btn_edit}    Generate Element From Dynamic Locator    ${btn_view_content_type_by_alias}    ${content_type_alias}
    Click Visible Element    ${btn_edit}