*** Variables ***
${btn_create_report}    //button[@id='create-report-btn-top']
${btn_select_test_executions}    //i[@class='fa fa-pencil']
${ddl_from_service_on_select_test_results_from_other_execution}    //span[normalize-space()='Jobs']
${txt_search_on_select_test_results_from_other_execution}    //div[@class='btn-group open']//input[@placeholder='Search']
${ddl_test_executions_on_select_test_results_from_other_execution}    //button[@title='None selected']
${lbl_test_executions_on_select_test_results_from_other_execution}    //li[@style='display: block;']//label[@class='checkbox']
${btn_add_test_executions_on_select_test_results_from_other_execution}    //button[normalize-space()='Add']
${btn_save_on_select_test_results_from_other_execution}    //button[normalize-space()='Save']
${txt_test_report_name}    //input[@id='test_report_name']
${btn_save_as_draft}    //button[@id='item-save-btn-top']

# DYNAMIC LOCATORS
${lbl_service_by_name}    //label[normalize-space()='_DYNAMIC_0']
# ${lbl_project_on_test_executions_by_name}    //b[contains(normalize-space(),'_DYNAMIC_0')]