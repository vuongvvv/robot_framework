*** Variables ***
${txt_attribute_name}    id=form-search-attribute-{0}
${txt_value}            id=form-search-value-{0}
${btn_search_content}    //button[@type="submit" and contains(text(),"Search")]
${btn_view_content}           //span[@jhitranslate='entity.action.view']/..
${txt_search_result}    //div[contains(text(), '1 items')]
${txt_brand_tsm_merchant_id}   //label[text()=" tsmMerchantId "]/following-sibling::div/input[@placeholder="tsmMerchantId"]
${txt_brand_name_th}     //label[text()=" nameTh "]/following-sibling::div/input[@placeholder="nameTh"]
${txt_brand_name_en}     //label[text()=" nameEn "]/following-sibling::div/input[@placeholder="nameEn"]
${txt_social_website}    //label[text()=" socialWebsite "]/following-sibling::div/input[@placeholder="socialWebsite"]
${txt_social_facebook}    //label[text()=" socialFacebook "]/following-sibling::div/input[@placeholder="socialFacebook"]
${txt_social_instagram}    //label[text()=" socialInstagram "]/following-sibling::div/input[@placeholder="socialInstagram"]
${txt_social_twitter}    //label[text()=" socialTwitter "]/following-sibling::div/input[@placeholder="socialTwitter"]
${txt_social_line}    //label[text()=" socialLine "]/following-sibling::div/input[@placeholder="socialLine"]
${txt_shop_tsm_merchant_id}    //input[@placeholder="tsmMerchantId"]
${txt_shopNameTh}           //input[@placeholder="shopNameTh"]
${txt_shopNameEN}           //input[@placeholder="shopNameEn"]
${txt_shop_highlight}        //input[@placeholder="shopHighlight"]
${txt_shopTel}              //input[@placeholder="shopTel"]
${txt_shopMobile}           //input[@placeholder="shopMobile"]