*** Settings ***
Resource    ../../../resources/locators/admintools/client/client_locators.robot
Resource    ../../common/locator_common.robot

*** Keywords ***
Delete All Client Id Matched Pattern
    [Arguments]    ${client_id_pattern}
    ${elements_list}=    Get WebElements    ${lbl_client_id}
    FOR    ${client_id_element}    IN    @{elements_list}
        ${client_id}=    Get Text    ${client_id_element}
        Delete Client Id    ${client_id}
    END

Delete Client Id
    [Arguments]    ${client_id}
    ${btn_delete_client}=    Generate Element From Dynamic Locator    ${btn_delete_client_by_id}    ${client_id}
    Click Element    ${btn_delete_client}
    Click Element    ${btn_delete_on_confirmation_popup}
    Wait Until Element Is Not Visible    ${frm_delete_confirmation}

Is Client Id Exist
    [Arguments]    ${client_id_name}
    Search Client Id    ${client_id_name}
    ${client_id_table_cell}    Generate Element From Dynamic Locator    ${tbl_client_id_cell}    ${client_id_name}
    ${is_client_id_exist}    Is Element Visible    ${client_id_table_cell}
    [Return]    ${is_client_id_exist}

Check And Create Client Id
    [Arguments]    ${name}    ${client_id}    ${client_secret}    ${scopes}    ${grant_types}
    ${is_client_id_exist}    Is Client Id Exist    ${name}
    Run Keyword If    ${is_client_id_exist}==${False}    Create Client Id    ${name}    ${client_id}    ${client_secret}    ${scopes}    ${grant_types}
    
Create Client Id
    [Arguments]    ${name}    ${client_id}    ${client_secret}    ${scopes}    ${grant_types}    ${access_token_validity}=600    ${refresh_token_validity}=86400    ${auto_approve}=${True}
    Click Visible Element    ${btn_create_a_new_client}    
    Input Text Into Visible Element    ${txt_create_or_edit_popup_name}    ${name}
    Input Text Into Visible Element    ${txt_create_or_edit_popup_client_id}    ${client_id}
    Input Text Into Visible Element    ${txt_create_or_edit_popup_client_secret}    ${client_secret}
    Select Scopes    ${scopes}    
    Select Grant Types    ${grant_types}    
    Input Text Into Visible Element    ${txt_create_or_edit_popup_access_token_validity}    ${access_token_validity}
    Input Text Into Visible Element    ${txt_create_or_edit_popup_refresh_token_validity}    ${refresh_token_validity}
    Select Checkbox    ${chk_create_or_edit_popup_auto_approve}
    Click Visible Element    ${btn_create_or_edit_popup_save}

Update Client Id
    [Arguments]    ${name}    ${scopes}
    Search Client Id    ${name}
    ${edit_client_id_locator}=    Generate Element From Dynamic Locator    ${btn_edit_client_id}    ${name}
    Click Visible Element    ${edit_client_id_locator}
    Select Scopes    ${scopes}
    Click Element    ${btn_create_or_edit_popup_save}
                
Select Authorized Grant Type
    [Arguments]    ${grant_type}
    ${elements}=    Get WebElements    ${frm_grant_types}
    ${checkbox_elements}=    Get WebElements    ${chk_grant_types}
    ${elements_count}=    Get Length    ${elements}
    FOR    ${index}    IN RANGE    0    ${elements_count}
        ${element_text}=    Get Text    ${elements}[${index}]        
        Run Keyword If    '${element_text}'=='${grant_type}'    Click Element    ${checkbox_elements}[${index}]
        Exit For Loop If    '${element_text}'=='${grant_type}'
    END
    
Select Scopes
    [Arguments]    ${scopes}
    ${scopes_list}=    Split String    ${scopes}    ,
    FOR    ${scope_item}    IN    @{scopes_list}
        Input Text    ${txt_create_or_edit_popup_scope}    ${scope_item}
        Press Keys    ${txt_create_or_edit_popup_scope}    RETURN
    END
    
Select Grant Types
    [Arguments]    ${grant_types}
    ${grant_types_list}=    Split String    ${grant_types}    ,
    FOR    ${grant_type_item}    IN    @{grant_types_list}
        Select Authorized Grant Type    ${grant_type_item}
    END

Search Client Id
    [Arguments]    ${client_name}
    Clean And Input Text Into Element    ${txt_search_client_name}    ${client_name}
    Click Visible Element    ${btn_search}

#Template keywords
Template Create Client Id
    [Arguments]    ${name}    ${client_id}    ${client_secret}    ${scopes}    ${grant_types}    ${access_token_validity}=600    ${refresh_token_validity}=86400    ${auto_approve}=${True}
    Run Keyword And Return Status    Create Client Id    ${name}    ${client_id}    ${client_secret}    ${scopes}    ${grant_types}    ${access_token_validity}    ${refresh_token_validity}    ${auto_approve}