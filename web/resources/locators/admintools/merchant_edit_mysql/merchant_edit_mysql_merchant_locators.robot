*** Variables ***
${txt_thai_merchant_name}              //label[span[contains(text(),"Merchant Name (TH)")]]/following-sibling::div/input
${btn_search_merchant}                id=btn_search
${btn_edit_tr1st_row_merchant_table}     //tr[contains(@class,"d-flex") and (not (@jhisort))][1]//button[@text="edit"]
${popup_edit_merchant}                //h4[contains(text(),"Edit Merchant Detail")]
${txt_merchant_id}                    //td[contains(text(),"Merchant ID")]/following-sibling::td
${txa_merchant_name_th}                //td[span[contains(text(),"Merchant name TH")]]/following-sibling::td/textarea
${txa_merchant_name_en}                //td[span[contains(text(),"Merchant name EN")]]/following-sibling::td/textarea
${txt_first_name}                     //td[span[contains(text(),"First Name")]]/following-sibling::td/input
${txt_last_name}                      //td[span[contains(text(),"Last Name")]]/following-sibling::td/input
${txt_merchant_description}           //td[span[contains(text(),"Merchant Description")]]/following-sibling::td/input
${txt_merchant_email}                 //td[span[contains(text(),"Merchant Email")]]/following-sibling::td/input
${txt_merchant_phone_no}               //td[span[contains(text(),"Merchant Phone no")]]/following-sibling::td/input
${txt_merchant_mobile_no}              //td[span[contains(text(),"Merchant Mobile no")]]/following-sibling::td/input
${txt_merchant_website}               //td[span[contains(text(),"Merchant Website")]]/following-sibling::td/input
${txt_merchant_facebook}              //td[span[contains(text(),"Merchant Facebook")]]/following-sibling::td/input
${txt_merchant_instagram}             //td[span[contains(text(),"Merchant Instagram")]]/following-sibling::td/input
${txt_merchant_twitter}               //td[span[contains(text(),"Merchant Twitter")]]/following-sibling::td/input
${txt_merchant_line}                  //td[span[contains(text(),"Merchant Line@")]]/following-sibling::td/input
${btn_save_update_merchant}            //div[@class='modal-footer']/button[@class='btn btn-primary']
${btn_confirm}                       //button[span[contains(text(),"Confirm")]]