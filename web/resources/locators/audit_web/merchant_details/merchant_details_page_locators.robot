*** Variables ***
${btn_submit_merchant_imgs}    xpath=.//button[@type="submit" and text()="บันทึกข้อมูล"]
${lbl_submit_merchant_imgs}    xpath=(.//div[@class="col-md-6 mb-3"])[2]
${btn_show_upload_img_success_state}    //button[@id='btn-submit']
${ddl_registration_type}    xpath=//select[@id="recomend.event_id"]
${btn_update_registration_type}    xpath=//button[text()="เก็บข้อมูล"]
#Fraud User Locators
${ddl_true_money_status}    xpath=//select[@id="doc_status"]
${btn_update_tmn_status}    xpath=(//button[text()="เก็บข้อมูล"])[2]
#Dynamic locators
${btn_browse_img}    xpath=.//input[@id="_DYNAMIC_0[0]"]
${lbl_text_verify}    xpath=//*[contains(text(),"_DYNAMIC_0")]/../div[contains(text(),"_DYNAMIC_1")]