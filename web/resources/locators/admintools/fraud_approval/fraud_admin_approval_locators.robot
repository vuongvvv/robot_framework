*** Variables ***
${lbl_brands_column_headers}    //th/span/span
${ddl_registration_channel}    //select[@id='searchChannel2']
${txt_true_money_wallet_no}    //input[@id='searchTrueMoneyWalletNo']
${txt_brand_name_en}    //input[@id='searchBrandEn']
${txt_brand_id}    //input[@id='searchBrandId']
${ddl_search_fraud_status}    //select[@id='searchFraudStatus']
${btn_search}    //button[@class='btn btn-success mr-2']
${btn_clear_search_results}    //button[@class='btn btn-danger mr-2']
${txa_fraud_review_remark}    //textarea[@name='fraudRemark']
${btn_load_more_shop}    //button[@class='btn btn-lm btn-outline-primary mb-2']
${mdl_document_preview_shop}    //div[@id='ng-lightbox-image-0']
${btn_close_preview_model_shop}    //a[@class='close']
${mdl_document_preview_brand_documents}    //embed[contains(@id,'ToPreview')][contains(@src,':')]
${btn_close_preview_model_brand_documents}    //embed[contains(@id,'ToPreview')][contains(@src,':')]//preceding-sibling::span
# ${img_shop_images}    //div[@id='ng-lightbox-image-0']//img
${lbl_caption_show}    //div[@class='caption show']
${btn_next_on_shop_preview}    //div[@class='lightbox-div']//a[@class='next icons next-icon'][contains(text(),'›')]
${img_thai_id}    //embed[@id='documentOwnerCertificate']/..
${img_owner_image}    //embed[@id='documentOwnerImage']/..
${img_bank_passbook}    //embed[@id='documentBankPassbook']/..
${ddl_brand_category}    //select[@name='brandCategory']
${ddl_brand_sub_category}    //select[@name='brandSubCategory']
${ddl_fraud_status}    //select[@name='fraudStatus']
${btn_save}    //button[@class='btn btn-info'][text()='Save']

# dynamic locators
${lbl_brand_information}    //span[contains(text(),'_DYNAMIC_0')]/../..//span[text()='_DYNAMIC_1']/../../following-sibling::div[1]
${lbl_shop_information}    (//jhi-shop-details//span[text()='_DYNAMIC_0'])[_DYNAMIC_1]//following::div[1]
${img_shop_store_front}    (//div[@class='ng-image-slider'])[_DYNAMIC_0]
${ddl_brand_information_dropdown_list}    //span[contains(text(),'_DYNAMIC_0')]/../..//span[text()='_DYNAMIC_1']/../../following-sibling::div[1]//select
${btn_view_by_brand_id}    //td[contains(text(),'_DYNAMIC_0')]/..//button[@text='view']
${btn_edit_by_brand_id}    //td[contains(text(),'_DYNAMIC_0')]/..//button[@text='edit']