*** Variables ***
${txt_thai_outlet_name}                  //label[@for='outlet_name_th']/following-sibling::div/input
${btn_search_outlet}                    //button[@id='btn_search']
${txt_brand_id_of_outlet}                 //tr[contains(@class,"d-flex") and (not (@jhisort))][1]//a
${btn_edit_tr1st_row_outlet_table}         //tr[contains(@class,"d-flex") and (not (@jhisort))][1]//button[@text="edit"]
${popup_edit_outlet}                    //h4[contains(text(),"Edit Outlet Detail")]
${txa_outlet_name_th}                    //textarea[@formcontrolname="outletNameTh"]
${txa_outlet_name_en}                    //textarea[@formcontrolname="outletNameEn"]
${txt_outlet_contact_first_name}          //input[@formcontrolname="contactFirstName"]
${txt_outlet_contact_last_name}           //input[@formcontrolname="contactLastName"]
${txt_outlet_description}               //input[@formcontrolname="outletDetail"]
${txt_outlet_contact_email}              //input[@formcontrolname="contactEmail"]
${txt_outlet_contact_phone_no}            //input[@formcontrolname="contactTel"]
${txt_outlet_contact_mobile_no}           //input[@formcontrolname="contactMobile"]
${btn_save_update_outlet}                //div[h5[contains(text(),"General Information")]]/following-sibling::div//button[contains(@type,"submit")]