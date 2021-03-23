*** Variables ***
${cel_first_cell_of_merchant_table}    //table[@id='table_merchant']/tbody/tr[1]/td[1]
${row_first_cell_ty_status_of_merchant_table}    //*[@id='table_merchant']/tbody/tr[1]/td[6]

#revise xpath
${btn_revise}   //*[@id="btn_revise"]
${ddl_revise_reason}   //*[@id="formRevise"]//*[@name="mer_reason"]
${revise_reason_details}   //*[@id="mer_remarkr"]
${btn_revise_ok}   //*[@aria-labelledby='ui-dialog-title-dialogRevise']//*[contains(text(),'OK')]
${btn_revise_cancel}   //*[@aria-labelledby='ui-dialog-title-dialogRevise']//*[contains(text(),'Cancel')]

#reject xpath
${btn_reject}   //*[@id="btn_cancel"]
${ddl_reject_reason}   //*[@id="formCancel"]//*[@name="mer_reason"]
${reject_reason_details}   //*[@id="mer_remark"]
${btn_reject_ok}   //*[@aria-labelledby='ui-dialog-title-dialogCancel']//*[contains(text(),'OK')]
${btn_reject_cancel}   //*[@aria-labelledby='ui-dialog-title-dialogCancel']//*[contains(text(),'Cancel')]

${txt_shop_address_road}    //input[@id='mer_address2']
${img_chrm_information_image_review}    //body//div//img

#Dynamic locators
${lbl_store_information_by_label}    //th[contains(text(),'_DYNAMIC_0')]//following-sibling::td[1]
${lnk_chrm_information_pictures}    //a[contains(text(),'/_DYNAMIC_0')]