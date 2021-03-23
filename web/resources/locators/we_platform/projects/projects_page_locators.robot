*** Variables ***
${btn_create_project}    //button[@id="jh-create-entity"]
${lnk_first_project}    (//a[contains(@href,"#/project/")])[1]
${lbl_project_title}    //h5[@class="card-title"]
${btn_project_toggle_menu}    //button[text()="..."]
${btn_edit_project}    //span[text()="Edit"]
${mdl_delete_project}    //div[@class="modal-body"]
${btn_delete_project}    //button[@class="btn-danger btn-sm dropdown-item"]
${lbl_delete_confirmation_message}    //p[@id="jhi-delete-project-heading"]
${btn_confirm_delete_project}    //button[@id="jhi-confirm-delete-project"]
${frm_alert}    //ngb-alert[contains(@class,'alert alert-success alert-dismissible')]
#Dynamic locators
${lbl_project_name}    (//h5[text()='_DYNAMIC_0'])[1]
${lnk_project}    //a[@href="_DYNAMIC_0"]
${lbl_project_toggle_menu}  //h5[text()="_DYNAMIC_0"]/../../../..//button[text()="..."]
${lbl_delete_project}  //h5[text()="_DYNAMIC_0"]/../../../..//button[@class="btn-danger btn-sm dropdown-item"]