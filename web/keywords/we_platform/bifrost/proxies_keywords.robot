*** Settings ***
Resource    ../../../resources/locators/we_platform/bifrost/proxies_locators.robot
Resource    ../../common/locator_common.robot

*** Keywords ***
Navigate To Create A New Proxy Page
    Click Visible Element    ${btn_create_a_new_proxy}
    
Create A New Proxy
    [Arguments]    ${project_id}    ${name}    ${group_name}    ${description}    ${owner}    ${path}    ${project_base_path}    ${method}    ${target_method}    ${target}    ${rest_full}    ${authorization_configuration_enable}    ${authorization_configuration_policy_project_id}    @{authorization_configuration_policy}
    Fill Proxy Information    ${project_id}    ${name}    ${group_name}    ${description}    ${owner}    ${path}    ${project_base_path}    ${method}    ${target_method}    ${target}    ${rest_full}    ${authorization_configuration_enable}    ${authorization_configuration_policy_project_id}    @{authorization_configuration_policy}
    Click Save Policy Button
    
Search Proxies
    [Arguments]    ${name}
    Input Text Into Visible Element    ${txt_search_name}    ${name}
    Click Visible Element    ${btn_search}
    
Delete Proxy By Name
    [Arguments]    ${name}
    Search Proxies    ${name}
    Click Visible Element    ${btn_delete_proxy}
    Click Visible Element    ${btn_confirm_delete_popup_delete}
    Wait Until Element Is Disappear    ${frm_delete}
    
Verify Alert Message
    [Arguments]    ${message}
    Wait Until Page Contains Text    ${message}
    
Verify Proxies Table Column Headers
    [Arguments]    ${column_headers}
    ${fetch_column_headers}=    Get Elements Text    ${lbl_proxies_column_headers}
    Lists Should Be Equal    ${column_headers}    ${fetch_column_headers}

Fill Proxy Information
    [Arguments]    ${project_id}    ${name}    ${group_name}    ${description}    ${owner}    ${path}    ${project_base_path}    ${method}    ${target_method}    ${target}    ${rest_full}    ${authorization_configuration_enable}    ${authorization_configuration_policy_project_id}    @{authorization_configuration_policy}    
    Refresh Page
    Input Text Into Visible Element    ${txt_project_id}    ${project_id}
    Input Text Into Visible Element    ${txt_name}    ${name}
    Input Text Into Visible Element    ${txt_group_name}    ${group_name}
    Input Text Into Visible Element    ${txt_description}    ${description}
    Input Text Into Visible Element    ${txt_owner}    ${owner}
    Input Text Into Visible Element    ${txt_path}    ${path}
    Run Keyword If    ${project_base_path}==${True}    Select Visible Checkbox    ${chk_project_base_path}
    ...    ELSE    Unselect Visible Checkbox    ${chk_project_base_path}
    Select Dropwdown List By Value    ${drd_method}    ${method}
    Select Dropwdown List By Value    ${drd_target_method}    ${target_method}
    Input Text Into Visible Element    ${txt_target}    ${target}
    Run Keyword If    ${rest_full}==${True}    Select Visible Checkbox    ${chk_rest_full}
    ...    ELSE    Unselect Visible Checkbox    ${chk_rest_full}
    Fill Proxy Authorization Configuration    ${authorization_configuration_enable}    ${authorization_configuration_policy_project_id}    @{authorization_configuration_policy}    

Fill Proxy Authorization Configuration
    [Arguments]    ${authorization_configuration_enable}    ${authorization_configuration_policy_project_id}    @{authorization_configuration_policy}
    Run Keyword If    ${authorization_configuration_enable}==${True}    Select Visible Checkbox    ${chk_authorization_configuration_enable_authorization}
    ...    ELSE    Unselect Visible Checkbox    ${chk_authorization_configuration_enable_authorization}
    Input Text Into Visible Element    ${txt_access_policy_project}    ${authorization_configuration_policy_project_id}
    Fill Authorization Configuration Policies    @{authorization_configuration_policy}
    
Fill Authorization Configuration Policies
    [Arguments]    @{authorization_configuration_policy}
    ${count_dict}=    Get Length    ${authorization_configuration_policy}
    Run Keyword If    ${count_dict}!=0    Click Visible Element    ${btn_add_policy}
    ${count_loop}=    Evaluate    ${count_dict} / 3
    ${count_loop}=    Convert To Integer    ${count_loop}
    FOR    ${index}    IN RANGE    0    ${count_loop}
        ${locator_index}=    Evaluate    ${index} + 1
        ${locator_index_str}=    Convert To String    ${locator_index}        
        ${subject_locator}=    Generate Element From Dynamic Locator    ${txt_policy_subject}    ${locator_index_str}
        ${action_locator}=    Generate Element From Dynamic Locator    ${txt_policy_action}    ${locator_index_str}
        ${resource_locator}=    Generate Element From Dynamic Locator    ${txt_policy_resource}    ${locator_index_str}
        
        ${subject_index}=    Evaluate    ${index} * 3
        Input Text Into Visible Element    ${subject_locator}    ${authorization_configuration_policy}[${subject_index}]
        
        ${action_index}=    Evaluate    ${index} * 3 + 1
        Input Text Into Visible Element    ${action_locator}    ${authorization_configuration_policy}[${action_index}]
        
        ${resource_index}=    Evaluate    ${index} * 3 + 2
        Input Text Into Visible Element    ${resource_locator}    ${authorization_configuration_policy}[${resource_index}]
        
        Run Keyword If    ${locator_index} < ${count_loop}    Click Visible Element    ${btn_add_policy}
    END

Verify Save Button Is Disabled
    Verify Element Is Disabled    ${btn_save}
    
Verify Save Button Is Enabled
    Verify Element Is Enabled    ${btn_save}
    
Verify Add Policy Button Is Disabled
    Verify Element Is Disabled    ${btn_add_policy}

Verify Delete Button Is Hidden
    ${delete_button_element}=    Generate Element From Dynamic Locator    ${btn_policy_delete}    1
    Verify Element Is Hidden    ${delete_button_element}

Verify Delete Button Is Shown
    ${delete_button_element}=    Generate Element From Dynamic Locator    ${btn_policy_delete}    1
    Verify Element Is Enabled    ${delete_button_element}

Uncheck Enable Authorization Checkbox
    Unselect Visible Checkbox    ${chk_authorization_configuration_enable_authorization}
    
Click Save Policy Button
    Click Element    ${btn_save}