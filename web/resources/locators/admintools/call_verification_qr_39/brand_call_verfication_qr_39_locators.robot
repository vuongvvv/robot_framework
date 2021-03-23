*** Variables ***
${lbl_brands_column_headers}    //th/span/span
${btn_save_brand_call_verification}    //button[@class='btn btn-info']
${ddl_search_call_verification_status}    //select[@id='searchCallStatus']
${btn_search}    //button[@class='btn btn-success mr-2']
${btn_clear_search_results}    //button[@class='btn btn-danger mr-2']
${txa_call_verification_details_remark}    //span[contains(text(),'Call Verification details')]/../..//textarea
${txa_brand_information_address}    //textarea[@name='brandAddress']
${txt_brand_information_mobile}    //input[@name='brandContactPhone']
${txa_brand_information_email}    //textarea[@name='brandContactEmail']
${btn_cancel}    //button[text()='Cancel']
${mdl_successful_message}    //div[@class='alert alert-success alert-dismissible']
${btn_load_more_shop}    //button[@class='btn btn-lm btn-outline-primary mb-2']
${ddl_brand_category}    select[name='brandCategory']
${ddl_brand_sub_category}    select[name='brandSubCategory']
${ddl_brand_province}    select[name='brandProvince']
${ddl_brand_district}    select[name='brandDistrict']
${ddl_brand_sub_district}    select[name='brandSubDistrict']
${ddl_shop_province_elements}    [name='shopProvince']
${ddl_shop_district_elements}    [name='shopDistrict']
${ddl_shop_sub_district_elements}    [name='shopSubDistrict']

# dynamic locators
${btn_edit_by_brand_id}    //td[contains(text(),'_DYNAMIC_0')]/..//button[@text='edit']
${btn_view_by_brand_id}    //td[contains(text(),'_DYNAMIC_0')]/..//button[@text='view']
${ddl_brand_information_dropdown_list}    //span[contains(text(),'_DYNAMIC_0')]/../..//span[text()='_DYNAMIC_1']/../../following-sibling::div[1]//select
${ddl_shop_information_dropdown_list}    (//span[contains(text(),'_DYNAMIC_0')])[_DYNAMIC_2]/../..//span[text()='_DYNAMIC_1']/../../following-sibling::div[1]//select
${lbl_brand_information}    //span[contains(text(),'_DYNAMIC_0')]/../..//span[text()='_DYNAMIC_1']/../../following-sibling::div
${lbl_shop_information}    (//span[contains(text(),'_DYNAMIC_0')])[_DYNAMIC_2]/../..//span[text()='_DYNAMIC_1']/../../following-sibling::div
${chk_shop_information_type}    (//span[contains(text(),'_DYNAMIC_0')])[_DYNAMIC_2]/../..//label[text()='_DYNAMIC_1']//preceding-sibling::input
${txa_shop_information_address}    (//textarea[@name='shopAddress'])[_DYNAMIC_0]
${txa_shop_information_name_th}    (//textarea[@name='shopTh'])[_DYNAMIC_0]
${txa_shop_information_name_en}    (//textarea[@name='shopEn'])[_DYNAMIC_0]
${txa_shop_information_contact_person_email_address}    (//textarea[@name='shopContactEmail'])[_DYNAMIC_0]
${txt_shop_information_contact_person_mobile_phone}    (//input[@name='shopContactPhone'])[_DYNAMIC_0]
${txa_shop_information_contact_full_name}    (//textarea[@name='shopContactFullName'])[_DYNAMIC_0]