*** Variables ***
${lbl_client_id}    //td[2][contains(text(),'TC_O2O')]
${btn_delete_on_confirmation_popup}    //button[@class='btn btn-danger']//span//span[contains(text(),'Delete')]
${btn_create_a_new_client}    //button[contains(@class,'create-o-auth-client-details')]
${frm_delete_confirmation}    //form[@name='deleteForm']
${txt_create_or_edit_popup_name}    //input[@id='field_name']
${txt_create_or_edit_popup_client_id}    //input[@id='field_clientId']
${txt_create_or_edit_popup_client_secret}    //input[@id='field_clientSecret']
${btn_create_or_edit_popup_generate}    //button[@id='btn_clientSecret']
${txt_create_or_edit_popup_scope}    //input[@id='field_scope']
${txt_create_or_edit_popup_access_token_validity}    //input[@id='field_accessTokenValidity']
${txt_create_or_edit_popup_refresh_token_validity}    //input[@id='field_refreshTokenValidity']
${chk_create_or_edit_popup_auto_approve}    //input[@id='field_autoApprove']
${btn_create_or_edit_popup_save}    //button[@class='btn btn-primary']
${btn_create_or_edit_popup_cancel}    //button[@class='btn btn-secondary']
${frm_grant_types}    //div[@class='form-check']
${chk_grant_types}    //div[@class='form-check']/input
${txt_search_client_name}    //input[@id='clientName']
${btn_search}    //button[@class='btn btn-success mr-2']

#Dynamic locator
${btn_delete_client_by_id}    //td[contains(text(),'_DYNAMIC_0')][1]//parent::tr//button[@class='btn btn-danger btn-sm']
${btn_edit_client_id}    //td[contains(text(),'_DYNAMIC_0')]/..//button[@class='btn btn-primary btn-sm']
${tbl_client_id_cell}    //td[text()='_DYNAMIC_0']