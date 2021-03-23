*** Variables ***
${btn_create_a_new_proxy}    //button[@id='jh-create-entity']
${txt_project_id}    //input[@id='field_projectId']
${txt_name}    //input[@id='field_name']
${txt_group_name}    //input[@id='field_groupName']
${txt_description}    //input[@id='field_description']
${txt_owner}    //input[@id='field_owner']
${txt_path}    //input[@id='field_path']
${chk_project_base_path}    //input[@id='field_projectBase']
${chk_authorization_configuration_enable_authorization}    //input[@id='field_enableAuthorization']
${drd_method}    //select[@id='field_method']
${drd_target_method}    //select[@id='field_targetMethod']
${txt_target}    //input[@id='field_target']
${chk_rest_full}    //input[@id='field_restEnable']
${txt_search_name}    //input[@id='name']
${btn_save}    //button[@id='save-entity']
${btn_search}    //button[@id='btn-search-attribute']
${btn_delete_proxy}    //button[@class='btn btn-danger btn-sm']
${btn_confirm_delete_popup_delete}    //button[@id='jhi-confirm-delete-proxy']
${frm_delete}    //form[@name='deleteForm']
${dlg_alert}    //ngb-alert[@class='alert alert-danger alert-dismissible']/pre
${btn_edit_proxy}    //button[@class='btn btn-primary btn-sm']
${txt_access_policy_project}    //input[@id='field_accessPolicyProject']
${btn_add_policy}    //button[@class='btn btn-info']
${lbl_proxies_column_headers}    //th/span

# dynamic locators
${txt_policy_subject}    //div[contains(text(),'Policy _DYNAMIC_0')]/..//input[@name='policySubject']
${txt_policy_action}    //div[contains(text(),'Policy _DYNAMIC_0')]/..//input[@name='policyAction']
${txt_policy_resource}    //div[contains(text(),'Policy _DYNAMIC_0')]/..//input[@name='policyResource']
${btn_policy_delete}    //div[contains(text(),'Policy _DYNAMIC_0')]/..//button