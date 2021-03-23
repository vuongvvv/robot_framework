*** Variables ***
${mnu_product}    //a[@id='active_product']


# DYNAMIC LOCATORS
${mnu_sub_product}    //span[@class='level-2'][normalize-space()='_DYNAMIC_0']/..
${mnu_main_menu}    //span[contains(text(),'_DYNAMIC_0')]//ancestor::li
${mnu_sub_menu_on_test_management_tool}    //span[contains(text(),'_DYNAMIC_0')]/..//following-sibling::ul//span[contains(text(),'_DYNAMIC_1')]/..