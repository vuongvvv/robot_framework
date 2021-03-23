*** Variables ***
${txt_search_sender_name}    //input[@class='form-control ng-valid ng-dirty ng-touched']
${btn_search}    //button[@id='btn_search']

#Dynamic locators
${btn_view_histories_table}    //div[@class="table-responsive"]//tr[_DYNAMIC_0]//span[text()="View"]
${lbl_history_field}    //span[text()="_DYNAMIC_0"]//ancestor::dt//following-sibling::dd[1]//span
${txt_search_field_by_label}    //span[contains(text(),'_DYNAMIC_0')]/../following-sibling::div//input