*** Variables ***
${modal}                   css=body.modal-open
${hamberger_menu}    //a[contains(@class,'jh-navbar-toggler d-none')]
${nav_right_menu}    //div[@id="navbarResponsive"][@class="navbar-collapse"]
${mnu_account}    //div[@id='navbarResponsive'][@class='navbar-collapse collapse']//a[@id='account-menu']
${lnk_logout}    //div[@id='navbarResponsive'][@class='navbar-collapse collapse']//a[@id='logout']
${lbl_dashboards}    //h2[text()='Dashboards']
${spn_loading_pane}    //div[@class="ngx-foreground-spinner center-center"]
${prg_loading_bar}    //div[@class="ngx-overlay loading-foreground"]//div[@class='sk-rectangle-bounce']
${lbl_table_column_headers}    //table//thead//th/span/span

#Dynamic locators
${mnu_right_menu_bar}    //*[@id="navbarResponsive"]//span[text()="_DYNAMIC_0"]//ancestor::a
${mnu_sub_menu}    //*[@id="navbarResponsive"]//span[text()="_DYNAMIC_0"]//ancestor::li//ul[contains(@class,"dropdown-menu")]//span[contains(text(),"_DYNAMIC_1")]//ancestor::a
${lnk_page_number}    //ngb-pagination//a[contains(text(),"_DYNAMIC_0")]
${lnk_main_menu}    //nav[@class='navbar navbar-dark navbar-expand-md jh-navbar']//div[@id='navbarResponsive']//span[text()='_DYNAMIC_0']
${lnk_sub_menu}    //ul[@class='dropdown-menu show']//*[contains(text(),'_DYNAMIC_0')]
${ico_column_header_sort}    //table//thead//span[text()='_DYNAMIC_0']/../following-sibling::span
${lbl_column_header}    //table//thead//span[text()='_DYNAMIC_0']
${cel_table}    //table//tbody//td[_DYNAMIC_0]