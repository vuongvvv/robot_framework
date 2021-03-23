*** Variables ***
${lbl_project_id_path}    //div/dl/dd[1]/span
${ddl_record_per_page}    //div[@class='d-flex justify-content-between']//select
${lbl_column_header_path}    //table[@class='table table-striped']//thead//tr
${btn_search}          //button[text()="Search"]
${btn_view}            //button[@class="btn btn-info btn-sm"]
${btn_void}            //p[contains(text(),'Void')]
${btn_confirm}         //button[@class="btn btn-success"]//span[text()="Confirm"]
${txt_order_no}       //label[text()="Order No"]/..//input
${txt_transaction_date_time_from}     //label[text()="Transaction Date/Time"]/..//input
${txt_transaction_amount_from}       //label[text()="Transaction Amount (THB)"]/..//input
${txt_transaction_date_time_to}     //label[text()="To"]/..//input[@placeholder="End Date"]
${txt_transaction_amount_to}        //label[text()="To"]/..//input[@placeholder="max"]
#Dynamic locators
${lbl_navigate_link_menu}    //a[@class='nav-link' and span[contains(text(),'_DYNAMIC_0')]]
${lbl_page_title_path}    //h2[@id='page-heading']//span[contains(text(),'_DYNAMIC_0')]
${lbl_sort_column_header_path}    //span[contains(text(),'_DYNAMIC_0')]
${ico_sort_path}    //th[@jhisortby ='_DYNAMIC_0']/fa-icon/*[@data-icon='_DYNAMIC_1']
${lbl_transaction_list_path}    //tr[_DYNAMIC_0]/td[_DYNAMIC_1]
${lbl_index_column_path}    //th[_DYNAMIC_0]/span
${lbl_comfirm_popup_path}       //p[text()="_DYNAMIC_0"]//following-sibling::p
${lbl_void_history}       //table[@id="payment-table"]//tbody//tr[17]//td[_DYNAMIC_0]
