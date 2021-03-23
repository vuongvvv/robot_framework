*** Variables ***
${btn_submit_login_true_you}    //input[@class="submit-login"]
${bar_please_wait}    //div[@class="blockUI blockOverlay"]
${bar_block_page}    //div[@class="blockUI blockMsg blockPage"]
${txt_username}    //input[@id='username']
${txt_password}    //input[@id='password']

#Dynamic locators
${mnu_menu_deal_management}    //div[@class="table"]//li[@class="select"]//b[contains(text(),"_DYNAMIC_0")]//ancestor::li
${mnu_sub_menu_deal_management}    //div[@class="table"]//li[@class="select"]//b[contains(text(),"_DYNAMIC_0")]//ancestor::li//ul//b[text()="_DYNAMIC_1"]