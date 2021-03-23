*** Settings ***
Resource    ../../../resources/locators/admintools/user_management_user/user_group_locators.robot
Resource    ../../../../web/keywords/common/locator_common.robot
Resource    ../common/common_keywords.robot

*** Keywords ***
Delete All User Group Matched Pattern
    [Arguments]    ${user_group_pattern}    
    Input Text    ${txt_search_user_group_name}    ${user_group_pattern}
    Click Button    Search
    ${user_groups_count_text}=    Get Text    ${lbl_user_groups_count}
    ${total_user_groups_text}=    Split String From Right    ${user_groups_count_text}    f
    ${total_user_groups_count}=    Get Regexp Matches    ${total_user_groups_text}[1]    \\d+
    FOR    ${index}    IN RANGE    0    ${${total_user_groups_count}[0]}
        Click Element    ${btn_first_delete_button}    
        Click Element    ${btn_delete_on_confirmation_popup}    
        Wait Until Element Is Not Visible    ${frm_delete_confirmation}
    END

Is User Group Exist
    [Arguments]    ${user_group_name}
    Clean And Input Text Into Element    ${txt_search_user_group_name}    ${user_group_name}
    Click Button    Search
    ${user_group_table_cell}    Generate Element From Dynamic Locator    ${tbl_user_group_cell}    ${user_group_name}
    ${is_visible}    Is Element Visible    ${user_group_table_cell}
    [Return]    ${is_visible}
    
Check And Create User Group
    [Arguments]    ${name}    ${permission_groups}    ${permissions}    ${users}
    ${is_user_group_exist}    Is User Group Exist    ${name}
    Run Keyword If    ${is_user_group_exist}==${False}    Create User Group    ${name}    ${permission_groups}    ${permissions}    ${users}
    
Create User Group
    [Arguments]    ${name}    ${permission_groups}    ${permissions}    ${users}
    Click Visible Element    ${btn_create_a_new_user_group}
    Input Text Into Visible Element    ${txt_create_or_edit_user_group_popup_name}    ${name}
    Run Keyword If    '${permission_groups}'!='${None}'    Select Permission Group    ${permission_groups}
    Run Keyword If    '${permissions}'!='${None}'    Select Permission    ${permissions}
    Run Keyword If    '${users}'!='${None}'    Select User    ${users}
    Click Visible Element    ${btn_create_or_edit_user_group_save}
    
Select Permission Group
    [Arguments]    ${permission_groups}
    ${permission_groups_list}=    Split String    ${permission_groups}    ,
    FOR    ${permission_group}    IN    @{permission_groups_list}
        Clear Element Text    ${txt_create_or_edit_user_group_permission_group}
        Input Text    ${txt_create_or_edit_user_group_permission_group}    ${permission_group}        
        ${dropdown_item_element}=    Generate Element From Dynamic Locator    ${btn_create_or_edit_user_group_dropdown_item}	${permission_group}
        Click Visible Element    ${dropdown_item_element}
    END
    
Select Permission
    [Arguments]    ${permissions}
    ${permissions_list}=    Split String    ${permissions}    ,
    FOR    ${permission}    IN    @{permissions_list}
        Clear Element Text    ${txt_create_or_edit_user_group_permission}
        Input Text    ${txt_create_or_edit_user_group_permission}    ${permission}        
        ${dropdown_item_element}=    Generate Element From Dynamic Locator    ${btn_create_or_edit_user_group_dropdown_item}	${permission}
        Click Element    ${dropdown_item_element}
    END
    
Select User
    [Arguments]    ${users}
    ${users_list}=    Split String    ${users}    ,
    FOR    ${user}    IN    @{users_list}
        Clear Element Text    ${txt_create_or_edit_user_group_user}
        Input Text    ${txt_create_or_edit_user_group_user}    ${user}        
        ${dropdown_item_element}=    Generate Element From Dynamic Locator    ${btn_create_or_edit_user_group_dropdown_item}	${user}
        Click Element    ${dropdown_item_element}
    END
    
Update User Group
    [Arguments]    ${user_group}    ${permissions}    ${user}    ${permission_groups}=${None}
    Input Text    ${txt_search_user_group_name}    ${user_group}
    Click Button    Search
    Click Element    ${btn_edit_user_group}
    Run Keyword If    '${permission_groups}'!='${None}'    Select Permission Group    ${permission_groups}
    Run Keyword If    '${permissions}'!='${None}'    Select Permission    ${permissions}
    Run Keyword If    '${user}'!='${None}'    Select User    ${user}
    Click Element    ${btn_create_or_edit_user_group_save}
    
Remove User From User Group
    [Arguments]    ${user_group}    ${user}
    Input Text    ${txt_search_user_group_name}    ${user_group}
    Click Button    Search
    Click Element    ${btn_edit_user_group}
    ${removed_user_element}=    Generate Element From Dynamic Locator    ${btn_create_or_edit_user_group_remove_user}    ${user}
    Click Element    ${removed_user_element}
    Click Element    ${btn_create_or_edit_user_group_save}