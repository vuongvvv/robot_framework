*** Settings ***
Resource    ../../../../web/resources/locators/we_platform/content_types/create_or_edit_content_type_locators.robot
Resource    ../../../../web/keywords/common/locator_common.robot

*** Keywords ***
Input Content Type Values
    [Arguments]   &{text_edit_field_and_values_for_edit}
    FOR  ${edit_field}    IN   @{text_edit_field_and_values_for_edit.keys()}
        ${value} =    Set Variable     ${text_edit_field_and_values_for_edit}[${edit_field}]
        ${txt_edit_content_type_locator} =    Generate Element From Dynamic Locator    ${txt_edit_content_type_field}    ${edit_field}
        Wait Until Element Is Visible    ${txt_edit_content_type_locator}
        Input Text   ${txt_edit_content_type_locator}   ${value}
    END

Edit Content Type
    [Arguments]    ${alias}=${None}
    Run Keyword If    '${alias}'!='${None}'    Clean And Input Text Into Element    ${txt_alias}    ${alias}
    Click Visible Element    ${btn_save}    
    
Verify Save Button Is Disabled
    Element Should Be Disabled    ${btn_save}    
    
Click Save Button
    Click Element   ${btn_save}

Create Attribute Of Content Type
    Click Add Attribute Button
    [Arguments]  ${attribute_name}   ${attribute_type}   ${enum_value}=${empty}   ${required_flag}=N
    Input Text   ${txt_attribute_name}    ${attribute_name}
    Select From List By Label   ${ddl_attribute_type}  ${attribute_type}
    Run Keyword If   '${required_flag}' == 'Y'   Click Element   ${cbx_required}
    Run Keyword If   '${attribute_type}' == 'Enum'   Input Text  ${txt_value_of_enum}   ${enum_value}

Verify Default Content Type Fields Textbox Turns Red With Invalid Values
    [Arguments]    ${fields_name}
    ${txt_invalid_fields_locator} =   Generate Element From Dynamic Locator    ${txt_invalid_fields}    ${fields_name}
    Wait Until Element Is Visible    ${txt_invalid_fields_locator}

Verify Content Type Fields Textbox Turns Red With Invalid Values
    [Arguments]   ${fields_name}    ${list_character}   
    @{list_character}=   Split String To Characters    ${list_character}
    FOR  ${character}    IN    @{list_character}
        ${lower_case_fields_name}   Convert To Lowercase   ${fields_name}
        Input Content Type Values    ${lower_case_fields_name}=${character}
        Verify Default Content Type Fields Textbox Turns Red With Invalid Values   ${fields_name}
    END

Click Add Attribute Button
    Click Element    ${btn_add_attribute}

Click Add Permission Button
    Click Element    ${btn_add_permission}

Input Permissions Values
    [Arguments]   &{txt_add_permission_field_and_values_for_add}
    FOR  ${add_field}    IN   @{txt_add_permission_field_and_values_for_add.keys()}
        ${value} =    Set Variable     ${txt_add_permission_field_and_values_for_add}[${add_field}]
        ${txt_add_permission_locator} =    Generate Element From Dynamic Locator    ${txt_add_permission_field}    ${add_field}
        Wait Until Element Is Visible    ${txt_add_permission_locator}
        Input Text   ${txt_add_permission_locator}   ${value}
    END

Select Add Or All Button
    [Arguments]  ${button_name}
    ${btn_add_or_all_locator} =    Generate Element From Dynamic Locator    ${btn_add_or_all}    ${button_name}
    Wait Until Element Is Visible   ${btn_add_or_all_locator}
    Click Element   ${btn_add_or_all_locator}

Select Authorize Permissions Checkbox
    [Arguments]  @{fields_name}
    FOR  ${fields_name_list}    IN    @{fields_name}
        ${cbx_authorize_locator} =    Generate Element From Dynamic Locator    ${cbx_authorize}  ${fields_name_list}
        Click Element    ${cbx_authorize_locator}
    END

Select Read Permissions Checkbox by Attributes Name
    [Arguments]   @{attribute_name}
    FOR  ${attribute_name_list}    IN    @{attribute_name}
        ${cbx_authorize_attri_read_locator}=    Generate Element From Dynamic Locator    ${cbx_authorize_attri_read}   ${attribute_name_list}
        Click Element   ${cbx_authorize_attri_read_locator}
    END

Select Update Permissions Checkbox by Attributes Name
    [Arguments]   @{attribute_name}
    FOR  ${attribute_name_list}    IN    @{attribute_name}
        ${cbx_authorize_attri_update_locator}=    Generate Element From Dynamic Locator    ${cbx_authorize_attri_update}   ${attribute_name_list}
        Click Element   ${cbx_authorize_attri_update_locator}
    END
    
Click Save Add Permissions Button
    Click Element  ${btn_save_add_permission}

Click Delete Attribute
    Click Element   ${btn_delete_attribute}