*** Variables ***
${btn_searching}    //button[@type='submit']
${ddl_searching_by}    id=searching
${icn_magnifier_of_top_search_result}    //span[@class='text-center fa fa-search']
${icn_pencil_of_top_search_result}    //table[@class='table table-striped table-hover table-md dataTable no-footer DTFC_Cloned']//i[@class='fa fa-pencil']
${icn_qr_code_of_top_search_result}    xpath=//td[@data-dt-column="12"]/a
${lbl_top_table_row}    xpath=//tbody/tr
#Add Delivery & Pickup Status Modal
${mdl_delivery_and_pickup_status}    xpath=//div[@class="modal-content"]
${ddl_status}    xpath=//select[@name="status" and @required]
${ddl_action_by}    xpath=//select[@name="updated_by"]
${btn_save}    xpath=//button[@type="submit" and text()="Save"]
${tbd_delivery_and_pickup_list}    xpath=//div[@class="modal-content"]//tbody
${icn_exit_modal}    xpath=//button[@data-dismiss="modal"]
${ddl_search_property}    //select[@id='searching']
${txt_search_value}    //input[@id='data_searching']
${ddl_search_status}    //select[@id='status']
${txt_search_start_date}    //input[@id='start_date']
${txt_search_end_date}    //input[@id='end_date']

#Dynamic locators
${search_field}    xpath=//*[contains(text(),"_DYNAMIC_0")]//ancestor::div[contains(@class,"col-md-3")]//*[@class="form-control"]
${ico_magnifier_by_merchant_name_th}    //td[contains(text(),'_DYNAMIC_0')]/..//a
${ico_pencial_by_merchant_mongo_id}    (//a[@data-id='_DYNAMIC_0'])[2]