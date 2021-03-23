*** Variables ***
${btn_back}    //button[@type="submit"]
${btn_edit_project}    //button[@type="button"]
${lbl_project_details}    //dl[@class="row-md jh-entity-details"]
#Dynamic Locators
${lbl_project_information}    (//span[contains(text(),'_DYNAMIC_0')]/../following-sibling::dd/span)[1]
