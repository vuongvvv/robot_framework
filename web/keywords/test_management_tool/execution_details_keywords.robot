*** Settings ***
Resource    ../../resources/locators/test_management_tool/execution_details_locators.robot

*** Keywords ***
Click Create Report Button
    Click Visible Element    ${btn_create_report}
    
Create Report
    [Arguments]    ${report_name}    ${project}    ${release}
    Click Create Report Button
    Wait Until Element Is Interactable    ${btn_select_test_executions}    sleep_time=2s
    Scroll Element Into View    ${btn_select_test_executions}
    Click Visible Element    ${btn_select_test_executions}
    Click Visible Element    ${ddl_from_service_on_select_test_results_from_other_execution}
    Input Text Into Visible Element    ${txt_search_on_select_test_results_from_other_execution}    ${project}
    ${rdo_service}    Generate Element From Dynamic Locator    ${lbl_service_by_name}    ${project}
    Click Visible Element    ${rdo_service}
    Wait Until Element Is Interactable    ${ddl_test_executions_on_select_test_results_from_other_execution}
    Click Visible Element    ${ddl_test_executions_on_select_test_results_from_other_execution}
    Wait Until Element Is Interactable    ${txt_search_on_select_test_results_from_other_execution}
    Input Text Into Visible Element    ${txt_search_on_select_test_results_from_other_execution}    ${release}
    Click Elements    ${lbl_test_executions_on_select_test_results_from_other_execution}
    Click Visible Element    ${btn_add_test_executions_on_select_test_results_from_other_execution}
    Click Visible Element    ${btn_save_on_select_test_results_from_other_execution}
    Input Text Into Visible Element    ${txt_test_report_name}    ${report_name}
    # Click Visible Element    ${btn_save_as_draft}