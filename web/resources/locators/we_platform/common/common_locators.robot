*** Variables ***
#Dynamic locators
${lnk_main_menu_weplatform}    //span[contains(text(),'_DYNAMIC_0')]
${lnk_sub_menu_weplatform}    //a[@class='dropdown-item']//span[contains(text(),'_DYNAMIC_0')]
${lnk_left_main_menu}  //a[@class='nav-link']//span[contains(text(),'_DYNAMIC_0')]
${lnk_left_sub_menu}   //div[@class="list-group"]//a[contains(text(),'_DYNAMIC_0')]
${spn_property_information}    //span[text()='_DYNAMIC_0']/..//following-sibling::dd/span
${lbl_popup_alert}     //pre[contains(text(),'_DYNAMIC_0')]