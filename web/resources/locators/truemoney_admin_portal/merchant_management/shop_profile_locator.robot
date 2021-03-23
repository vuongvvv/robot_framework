*** Variables ***
${btn_shop_edit}    //button[@id='shop_edit_button']
${btn_update_shop_information}    //button[text()='Update']
${btn_confirm_update_shop_information}    //button[text()='Confirm Update']
${btn_confirm_expire_shop_constract}    //button[normalize-space()='Confirm Expire']
${btn_merchant_status}    //*[@name="edit-kyb-status"]
${ddl_merchant_status}    //div[@name='kyb-status']//*[@class="Select-input"]/input
${ddl_certificated_value}    //*[@class="Select-menu-outer"]//*[@aria-label="CERTIFICATED"][contains(text(),"CERTIFICATED")]
${ddl_certificated_failed_value}    //*[@class="Select-menu-outer"]//*[@aria-label="CERTIFICATED_FAILED"][contains(text(),"CERTIFICATED_FAILED")]
${ddl_uncertificated_value}    //*[@class="Select-menu-outer"]//*[@aria-label="UNCERTIFICATED"][contains(text(),"UNCERTIFICATED")]
${chk_create_default_contract}    //input[@name='default contract']
${chk_create_default_shop}    //input[@name='default shop']
${txt_kyb_status}    //*[@id="merchant-profile-accordion"]/div[6]//*[@class="merchant-status primary"]
${txt_merchant_status}    //*[@id="merchant-profile-accordion"]/div[7]//*[@class="merchant-status primary"]

# dynamic locators
${txt_shop_profile_by_label}    //div[text()='_DYNAMIC_0']//following-sibling::div//input
${cel_terminal_list_table}    //table[@id='terminal_list_table']//td[text()='_DYNAMIC_0']
${lbl_terminal_name_on_terminal_list_table}    //table[@id='terminal_list_table']//td[text()='_DYNAMIC_0']//following-sibling::td[1]
${lbl_device_type_on_terminal_list_table}    //table[@id='terminal_list_table']//td[text()='_DYNAMIC_0']//following-sibling::td[3]
${lbl_terminal_status_on_terminal_list_table}    //table[@id='terminal_list_table']//td[text()='_DYNAMIC_0']//following-sibling::td[4]
${lnk_contract_id_on_contract_list_table}    //table[@id='contract_list_table']//td/a[text()='_DYNAMIC_0']
${lbl_contract_name_on_contract_list_table}    //table[@id='contract_list_table']//td/a[text()='_DYNAMIC_0']//following::td[1]
${lbl_product_name_on_contract_list_table}    //table[@id='contract_list_table']//td/a[text()='_DYNAMIC_0']//following::td[2]
${lbl_last_modifier_by_on_contract_list_table}    //table[@id='contract_list_table']//td/a[text()='_DYNAMIC_0']//following::td[3]
${lbl_contract_status_on_contract_list_table}    //table[@id='contract_list_table']//td/a[text()='_DYNAMIC_0']//following::td[5]
${lnk_shop_kyb_document}    //div[text()='Copy Of THAI ID Or Passport Of Business Owner']/../div//a
${lnk_expired_true_money_shop_contrancts}    //a[normalize-space()='_DYNAMIC_0']/..//following-sibling::td//a[text()='Expire']
${lbl_contact_information_by_label}    //div[normalize-space()='Contact Information']//following-sibling::div//div[text()='_DYNAMIC_0']//following-sibling::div
${lbl_billing_address_by_label}    //div[normalize-space()='Billing Address']//following-sibling::div//div[text()='_DYNAMIC_0']//following-sibling::div