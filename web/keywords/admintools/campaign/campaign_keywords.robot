*** Settings ***
Resource    ../../../resources/locators/admintools/campaign/campaign_locators.robot
Resource    ../../common/locator_common.robot

*** Keywords ***
Set Value To Action
    [Arguments]    ${action}=${null}
    Run Keyword If    '${action}'!='${null}'    Run Keywords    Click Element    ${chk_action}
    ...    AND    Input Text    ${txt_action}    ${action}

Create Campaign
    [Arguments]    ${type}    ${group}    ${action}    ${spending_amount}    ${point}    ${minimum_spending}    ${start_date}    ${end_date}    ${status}    ${daily_cap}    ${monthly_cap}    ${payment_method}
    Click Element    ${btn_create_campaign}
    Wait Until Element Is Visible    ${lbl_create_edit_campaign}
    Select From List By Label    ${ddl_type}    ${type}
    Input Text    ${txt_group}    ${group}
    Set Value To Action    ${action}
    Input Text    ${txt_spending_amount}    ${spending_amount}
    Input Text    ${txt_point}    ${point}
    Run Keyword If    '${minimum_spending}'!='${null}'    Input Text    ${txt_minimum_spending}    ${minimum_spending}
    Clear Element Text    ${txt_start_date}
    Input Text    ${txt_start_date}    ${start_date}
    Clear Element Text    ${txt_end_date}
    Input Text    ${txt_end_date}    ${end_date}
    Select From List By Label    ${ddl_status}    ${status}
    Run Keyword If    '${daily_cap}'!='${null}'    Input Text    ${txt_daily_cap}    ${daily_cap}
    Run Keyword If    '${monthly_cap}'!='${null}'    Input Text    ${txt_monthly_cap}    ${monthly_cap}
    Select From List By Label    ${lst_payment_method}    ${payment_method}
    Click Element    ${btn_save}
    Wait Until Element Is Disappear    ${lbl_create_campaign_popup}

Update Campaign
    [Arguments]    ${type}    ${group}    ${action}    ${spending_amount}    ${point}    ${minimum_spending}    ${start_date}    ${end_date}    ${status}    ${daily_cap}    ${monthly_cap}    ${payment_method}
    Wait Until Element Is Visible    ${lbl_create_edit_campaign}
    Select From List By Label    ${ddl_type}    ${type}
    Update Text    ${txt_group}    ${group}
    Update Text    ${txt_action}    ${action}
    Update Text    ${txt_spending_amount}    ${spending_amount}
    Update Text    ${txt_point}    ${point}
    Run Keyword If    '${minimum_spending}'!='${null}'    Update Text    ${txt_minimum_spending}    ${minimum_spending}
    Clear Element Text    ${txt_start_date}
    Update Text    ${txt_start_date}    ${start_date}
    Clear Element Text    ${txt_end_date}
    Press Keys    ${txt_end_date}    ${end_date}
    Select From List By Label    ${ddl_status}    ${status}
    Run Keyword If    '${daily_cap}'!='${null}'    Update Text    ${txt_daily_cap}    ${daily_cap}
    Run Keyword If    '${monthly_cap}'!='${null}'    Update Text    ${txt_monthly_cap}    ${monthly_cap}
    Select From List By Label    ${lst_payment_method}    ${payment_method}
    Click Element    ${btn_save}
    Wait Until Element Is Disappear    ${lbl_create_campaign_popup}

Click Edit Button Of Campaign
    [Arguments]    ${unique_value_on_campaigns_table}
    ${edit_button_element}=    Generate Element From Dynamic Locator    ${btn_edit_with_unique_value_on_campaigns_table}    ${unique_value_on_campaigns_table}
    Wait Until Element Is Visible    ${edit_button_element}
    Click Visible Element    ${edit_button_element}

Click Delete Button Of Campaign
    [Arguments]    ${unique_value_on_campaigns_table}
    ${delete_button_element}=    Generate Element From Dynamic Locator    ${btn_delete_with_unique_value_on_campaigns_table}    ${unique_value_on_campaigns_table}
    Wait Until Element Is Visible    ${delete_button_element}
    Click Element    ${delete_button_element}

Click Campaign Status Of Campaign
    [Arguments]    ${unique_value_on_campaigns_table}
    ${status_button_element}=    Generate Element From Dynamic Locator    ${btn_status_with_unique_value_on_campaigns_table}    ${unique_value_on_campaigns_table}
    Wait Until Element Is Visible    ${status_button_element}
    Click Element    ${status_button_element}

Sort Campaigns Table
    [Arguments]    ${sort_column}
    ${sort_by_column_element}=    Generate Element From Dynamic Locator    ${btn_sort_with_column_name}    ${sort_column}
    Click Element    ${sort_by_column_element}

Verify Data On Campaigns Table With Unique Input
    [Arguments]    ${unique_input_value}    ${expected_type}    ${expected_action}
    ${type_element}=    Generate Element From Dynamic Locator    ${tbl_type_cell}    ${unique_input_value}
    Wait Until Element Is Visible    ${type_element}
    Element Text Should Be    ${type_element}    ${expected_type}
    ${action_element}=    Generate Element From Dynamic Locator    ${tbl_action_cell}    ${unique_input_value}
    Element Text Should Be    ${action_element}    ${expected_action}

Delete Campaign
    [Arguments]    ${unique_value_on_campaigns_table}
    Click Delete Button Of Campaign    ${unique_value_on_campaigns_table}
    Click Visible Element    ${btn_confirm_delete}
