*** Variables ***
${txt_search_user_group_name}    //input[@id='search_user_group_name']
${btn_search}    //button[@class='btn btn-success mr-2']
${lbl_user_groups_count}    //div[@class='info jhi-item-count']/span
${btn_first_delete_button}    (//button[@class='btn btn-danger btn-sm'])[1]
${btn_edit_user_group}    //button[@class='btn btn-primary btn-sm']
${btn_delete_on_confirmation_popup}    //form[@name='deleteForm']//button[@class='btn btn-danger']
${frm_delete_confirmation}    //form[@name='deleteForm']
${txt_create_or_edit_user_group_popup_name}    //input[@id='field_name']
${txt_create_or_edit_user_group_permission_group}    //o2o-multi-select[@id='field_permissionGroup']//input[@name='name']
${txt_create_or_edit_user_group_permission}    //o2o-multi-select[@id='field_permission']//input[@name='name']
${txt_create_or_edit_user_group_user}    //o2o-multi-select-ajax[@id='field_user']//input[@name='name']
${btn_create_or_edit_user_group_save}    //button[@class='btn btn-primary']
${btn_create_or_edit_user_group_cancel}    //button[@class='btn btn-secondary']
${btn_create_a_new_user_group}    //button[contains(@class,'jh-create-entity create-user-group')]
${frm_create_or_edit_user_group}    //form[@name='editForm']
#Dynamic locators
${btn_delete_user_group}    //td[contains(text(),'_DYNAMIC_0')]/..//button[@class='btn btn-danger btn-sm']
${btn_create_or_edit_user_group_dropdown_item}    //button[contains(text(),'_DYNAMIC_0')]
${btn_create_or_edit_user_group_remove_user}    //li[contains(text(),'_DYNAMIC_0')]/button
${tbl_user_group_cell}    //td[text()='_DYNAMIC_0']