*** Variables ***
${btn_lot}    //div[@id="cam_lots"]
${btn_campaign_name}    //button[@class="ui-multiselect ui-widget ui-state-default ui-corner-all"]
${btn_campaign_status}    //select[@id="camstat_id"]//following-sibling::button
${btn_food_type}    //select[@id="cam_subcategory2_id"]//following-sibling::button
${btn_coverage_area}    //select[@id="cam_cover"]//following-sibling::button

#dynamic locators
${lbl_dropdown_item}    //span[text()="_DYNAMIC_0"]