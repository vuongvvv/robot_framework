*** Variables ***
${txt_search_shop_contract}    //input[@id='id_search_value']
${btn_search_shop_contract}    //button[@id='btn_search']
${btn_approve_shop_contract}    //button[normalize-space()='Approve']
${btn_reject_shop_contract}    //button[normalize-space()='Reject']
${mdl_approve_reject_success_popup}    //div[@id='toast-container']

# dynamic locators
${chk_shop_contract_by_shop_id}    //td[normalize-space()='_DYNAMIC_0']//preceding-sibling::td//input[@id='contract-checkbox-1']