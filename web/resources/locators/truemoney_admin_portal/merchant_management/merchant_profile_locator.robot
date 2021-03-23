*** Variables ***
${txt_search_value}    //input[@id='id_search_value']
${btn_edit_kyb_status}    //button[@name='edit-kyb-status']
${ddl_merchant_status}    //div[@name='kyb-status']
${btn_update_kyb_status}    //button[@name='update-kyb-btn']
${btn_confirm_update_merchant_information}    //button[text()='Confirm Update']
${lnk_brand_kyb_document}    //div[text()='Copy Of THAI ID Or Passport Of Business Owner']/../div//a
${chk_create_default_contract}    //input[@name='default contract']
${txa_merchant_status_note}    //div[@name='kyb-status-note']//textarea

# dynamic locators
${lbl_merchant_profile_business_owner_detail_by_label}    //div[contains(text(),'_DYNAMIC_0')]//following-sibling::div[1]
${lbl_merchant_detail_contact_billing_address_by_label}    //div[contains(text(),'Merchant Detail')]//following-sibling::div//span[text()='_DYNAMIC_0']/../following-sibling::div[1]/div[text()='_DYNAMIC_1']//following-sibling::div[1]
${ddl_merchant_status_item}    //a[text()='Merchant Status']/../../..//*[text()='_DYNAMIC_0']