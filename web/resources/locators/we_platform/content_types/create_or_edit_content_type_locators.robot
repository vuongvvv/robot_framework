*** Variable ***
${btn_save}   //button[@id="save-entity"]
${btn_save_add_permission}     //div[@class="modal-footer"]//button[2]
${btn_add_attribute}    //button[@class="btn btn-info"]
${txt_attribute_name}         (//Input[@placeholder="Attribute"])[last()]
${ddl_attribute_type}  (//div[@class="form-group"]//select)[last()]
${cbx_required}    (//div[@class="form-group"]//input[@type="checkbox"])[last()]
${txt_value_of_enum}      (//input[@placeholder="Value"])[last()]
${btn_delete_attribute}    //button[@class="btn btn-danger"]
${txt_alias}    //input[@id='field_alias']
#Dynamic locators
${txt_edit_content_type_field}   //input[@name="_DYNAMIC_0"]
${txt_invalid_fields}     (//label[text()="_DYNAMIC_0"]/..//input[contains(@class, 'ng-invalid')])[last()]
${btn_add_permission}     (//button[@class="btn btn-info float-right"])[last()]
${txt_add_permission_field}         //*[@id="_DYNAMIC_0"]
${txt_area_permissions_name}    //textarea[@id="description"]
${btn_add_or_all}   //span[text()="_DYNAMIC_0"]
${cbx_authorize}        //span[contains(text(),'_DYNAMIC_0')]/../..//input
${cbx_authorize_attri_read}        //span[text()="_DYNAMIC_0"]/../..//td[2]//input
${cbx_authorize_attri_update}      //span[text()="_DYNAMIC_0"]/../..//td[3]//input
