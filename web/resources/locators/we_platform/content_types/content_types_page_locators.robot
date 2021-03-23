*** Variables ***
${btn_create_a_new_content_type}     //button[@id="jh-create-entity"]
${pup_confirm_delete}   //input[@placeholder="Please insert content type name"]
${btn_confirm_delete}   //button[@id="jhi-confirm-delete-contentType"]

#Dynamic locators
${lbl_content_types_name}    //td[text()="_DYNAMIC_0"]/..//a[text()='_DYNAMIC_1']
${cnt_type_button}    //a[text()='_DYNAMIC_0']/../../td[3][text()="_DYNAMIC_1"]//following::button/span[text()="_DYNAMIC_2"]
${btn_edit_content_type_by_alias}    //td[text()='_DYNAMIC_0']/..//button[@class='btn btn-primary btn-sm']