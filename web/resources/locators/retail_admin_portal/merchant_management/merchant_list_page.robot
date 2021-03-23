*** Variables ***
${ddl_search_by}    //input[@id="id_search_type"]
${search_value_id}    //*[@name="search_value"]
${btn_search}    id:btn_search
${lnk_approve}    //a[text()="Approve"]
${ddl_merchant_type}    //*[@id="react-select-3--value"]
${popup_status}    //*[@class="toast-close-button"]
${txt_admin_portal_merchant_name_th}    //*[@id="merchant_list_table"]/tbody/tr[1]/td[4]
${txt_admin_portal_merchant_name_en}    //*[@id="merchant_list_table"]/tbody/tr[1]/td[5]
${txt_admin_portal_merchant_status}    //*[@id="merchant_list_table"]/tbody/tr[1]/td[11]
${btn_admin_portal_view}    //*[@id="merchant_list_table"]/tbody/tr[1]/td[12]/a
${ddl_search_by_register_name}    //*[@class="Select-menu-outer"]//*[contains(text(),'Register Name')]
${ddl_search_by_merchant_id}    //*[@class="Select-menu-outer"]//*[contains(text(),'Merchant ID')]
${ddl_search_by_merchant_name}    //*[@class="Select-menu-outer"]//*[contains(text(),'Merchant Name')]