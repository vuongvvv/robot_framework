*** Settings ***
Resource    ../../../resources/locators/truemoney_admin_portal/merchant_management/shop_contract_approval_list_locator.robot
Resource    ../../common/locator_common.robot

*** Keywords ***
Approve Shop Contract Approval
    [Arguments]    ${shop_id}
    Go To Url    https://backoffice-ui.tmn-dev.com/core/merchant-management/shop_contract_approval_list#
    Input Text Into Visible Element    ${txt_search_shop_contract}    ${shop_id}
    Wait Until Element Is Interactable    ${btn_search_shop_contract}    sleep_time=1s
    Click Visible Element    ${btn_search_shop_contract}
    ${chk_shop_contract}    Generate Element From Dynamic Locator    ${chk_shop_contract_by_shop_id}    ${shop_id}
    Select Visible Checkbox    ${chk_shop_contract}
    Click Visible Element    ${btn_approve_shop_contract}
    Wait Element Is Visible    ${mdl_approve_reject_success_popup}
    
Reject Shop Contract Approval
    [Arguments]    ${shop_id}
    Go To Url    https://backoffice-ui.tmn-dev.com/core/merchant-management/shop_contract_approval_list#
    Input Text Into Visible Element    ${txt_search_shop_contract}    ${shop_id}
    Wait Until Element Is Interactable    ${btn_search_shop_contract}    sleep_time=3s
    Click Visible Element    ${btn_search_shop_contract}
    ${chk_shop_contract}    Generate Element From Dynamic Locator    ${chk_shop_contract_by_shop_id}    ${shop_id}
    Select Visible Checkbox    ${chk_shop_contract}
    Click Visible Element    ${btn_reject_shop_contract}
    Wait Element Is Visible    ${mdl_approve_reject_success_popup}