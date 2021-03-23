*** Settings ***
Resource    ../../../resources/locators/retail_admin_portal/merchant_management/merchant_profile_page.robot

*** Keywords ***
Click Update Merchant Kyb Link
    Click Element    ${lnk_update_merchant_kyb}

Update Kyb Status
    [Arguments]    ${kyb_status}
    Input Text    ${txt_kyb_status}    ${kyb_status}
    Press Key    ${txt_kyb_status}    \\13
    Click Element    ${btn_update_kyb_status}
    Wait Until Element Is Visible    ${btn_update_status_confirm_dialog}
    Click Element    ${btn_update_status_confirm_dialog}
    Wait Until Element Is Visible    ${tbl_contract_list}