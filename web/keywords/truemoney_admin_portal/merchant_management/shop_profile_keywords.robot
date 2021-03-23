*** Settings ***
Resource    ../../../resources/locators/truemoney_admin_portal/merchant_management/shop_profile_locator.robot
Resource    ../../common/locator_common.robot

*** Keywords ***
Click Shop Edit Button
    Wait Element Is Visible    ${btn_shop_edit}
    Scroll Element Into View    ${btn_shop_edit}
    Click Visible Element    ${btn_shop_edit}
    
Clean Shop Profile Information
    [Arguments]    ${label}
    ${element}    Generate Element From Dynamic Locator    ${txt_shop_profile_by_label}    ${label}
    Wait Element Is Visible    ${element}
    Click Visible Element    ${element}
    Clean And Input Text Into Element    ${element}    ${SPACE}
    Sleep    0.5s
    Send Keys To Element    ${element}    BACKSPACE

Submit Shop Profile Information
    Click Visible Element    ${btn_update_shop_information}
    Click Visible Element    ${btn_confirm_update_shop_information}

Edit Merchant Status
    [Arguments]    ${txt_status}=CERTIFICATED
    Wait Until Loading Pane Is Disappear
    Wait Until Element Is Visible    ${btn_merchant_status}    30s
    Click Visible Element    ${btn_merchant_status}
    Input Text Into Visible Element    ${ddl_merchant_status}    ${txt_status}
    Run keyword if    '${txt_status}' == 'CERTIFICATED'    Click Visible Element    ${ddl_certificated_value}
    Run keyword if    '${txt_status}' == 'CERTIFICATED_FAILED'    Click Visible Element    ${ddl_certificated_failed_value}
    Run keyword if    '${txt_status}' == 'UNCERTIFICATED'    Click Visible Element    ${ddl_uncertificated_value}
    Run Keyword If    '${txt_status}' == 'CERTIFICATED'    Run keywords    Wait Until Element Is Visible    ${chk_create_default_contract}    10s
    ...  AND    Unselect Visible Checkbox    ${chk_create_default_contract}
    ...  AND    Wait Until Element Is Visible    ${chk_create_default_shop}    10s
    ...  AND    Unselect Visible Checkbox    ${chk_create_default_shop}
    Submit Shop Profile Information
    Wait Until Element Is Disappear    ${btn_confirm_update_shop_information}

Validate Kyb Status And Merchant Status in Admin Portal
    [Arguments]    ${txt_status}
    Wait Until Element Is Visible    ${txt_merchant_status}    timeout=10s
    Wait Until Element Is Visible    ${txt_kyb_status}    timeout=10s
    ${actual_merchant_status}=    Get Text      ${txt_merchant_status}
    ${actual_kyb_status}=    Get Text      ${txt_kyb_status}
    ${expected_kyb_status}=    run keyword if  '${txt_status}' == 'CERTIFICATED'    Set variable    ACTIVE
    Wait Until Keyword Succeeds    5    1s    should be equal as strings    ${actual_merchant_status}    ${txt_status}
    Wait Until Keyword Succeeds    5    1s    should be equal as strings    ${actual_kyb_status}    ${expected_kyb_status}

Remove TrueMoney Account
    [Arguments]    ${brand_id}    ${shop_id}
    Go To Url    https://backoffice-ui.tmn-dev.com/core/merchant-management/merchants/${brand_id}/shops/${shop_id}
    Click Shop Edit Button
    Clean Shop Profile Information    Wallet Number
    Clean Shop Profile Information    Wallet Owner Name
    Submit Shop Profile Information
    Wait Until Element Is Disappear    ${btn_confirm_update_shop_information}

Set Expired Shop Constract
    [Arguments]    ${brand_id}    ${shop_id}    ${true_money_contract_shop_id}
    Go To Url    https://backoffice-ui.tmn-dev.com/core/merchant-management/merchants/${brand_id}/shops/${shop_id}
    ${lnk_expire_shop_contract}    Generate Element From Dynamic Locator    ${lnk_expired_true_money_shop_contrancts}    ${true_money_contract_shop_id}
    Wait Element Is Visible    ${lnk_expire_shop_contract}
    Click Visible Element    ${lnk_expire_shop_contract}
    Click Visible Element    ${btn_confirm_expire_shop_constract}
        
Verify Terminal List
    [Arguments]    ${terminal_id}    ${terminal_name}    ${device_type}    ${terminal_status}
    ${lbl_terminal_id}    Generate Element From Dynamic Locator    ${cel_terminal_list_table}    ${terminal_id}
    Verify Element Is Visible    ${lbl_terminal_id}
    ${lbl_terminal_name}    Generate Element From Dynamic Locator    ${lbl_terminal_name_on_terminal_list_table}    ${terminal_id}
    Check Element Text    ${lbl_terminal_name}    ${terminal_name}
    ${lbl_device_type}    Generate Element From Dynamic Locator    ${lbl_device_type_on_terminal_list_table}    ${terminal_id}
    Check Element Text    ${lbl_device_type}    ${device_type}
    ${lbl_terminal_status}    Generate Element From Dynamic Locator    ${lbl_terminal_status_on_terminal_list_table}    ${terminal_id}
    Check Element Text    ${lbl_terminal_status}    ${terminal_status}
    
Verify Contract Signed
    [Arguments]    ${contract_id}    ${contract_name}    ${product_name}    ${last_modifier_by}    ${contract_status}
    ${lnk_contract_id}    Generate Element From Dynamic Locator    ${lnk_contract_id_on_contract_list_table}    ${contract_id}
    Verify Element Is Visible    ${lnk_contract_id}
    ${lbl_contract_name}    Generate Element From Dynamic Locator    ${lbl_contract_name_on_contract_list_table}    ${contract_id}
    Check Element Text    ${lbl_contract_name}    ${contract_name}
    ${lbl_product_name}    Generate Element From Dynamic Locator    ${lbl_product_name_on_contract_list_table}    ${contract_id}
    Check Element Text    ${lbl_product_name}    ${product_name}
    ${lbl_last_modifier_by}    Generate Element From Dynamic Locator    ${lbl_last_modifier_by_on_contract_list_table}    ${contract_id}
    Check Element Text    ${lbl_last_modifier_by}    ${last_modifier_by}
    ${lbl_contract_status}    Generate Element From Dynamic Locator    ${lbl_contract_status_on_contract_list_table}    ${contract_id}
    Check Element Text    ${lbl_contract_status}    ${contract_status}
    
Verify Shop Kyb Documents
    [Arguments]    ${business_owner_thai_id_or_passport}=${None}    ${vat_certificate}=${None}    ${bank_passbook_front_page}=${None}
    ...    ${shop_map}=${None}    ${storefront_photos}=${None}    ${rental_contact}=${None}
    ...    ${household_registration}=${None}    ${company_registration}=${None}
    Run Keyword If    '${business_owner_thai_id_or_passport}'!='${None}'    Verify Shop Kyb Document By Image Name    ${business_owner_thai_id_or_passport}
    Run Keyword If    '${vat_certificate}'!='${None}'    Verify Shop Kyb Document By Image Name    ${vat_certificate}
    Run Keyword If    '${bank_passbook_front_page}'!='${None}'    Verify Shop Kyb Document By Image Name    ${bank_passbook_front_page}
    Run Keyword If    '${shop_map}'!='${None}'    Verify Shop Kyb Document By Image Name    ${shop_map}
    Run Keyword If    '${storefront_photos}'!='${None}'    Verify Shop Kyb Document By Image Name    ${storefront_photos}
    Run Keyword If    '${rental_contact}'!='${None}'    Verify Shop Kyb Document By Image Name    ${rental_contact}
    Run Keyword If    '${household_registration}'!='${None}'    Verify Shop Kyb Document By Image Name    ${household_registration}
    Run Keyword If    '${company_registration}'!='${None}'    Verify Shop Kyb Document By Image Name    ${company_registration}
    
Verify Shop Kyb Document By Image Name
    [Arguments]    ${image_name}
    ${element}    Generate Element From Dynamic Locator    ${lnk_shop_kyb_document}    ${image_name}
    Verify Element Is Visible    ${element}
    
Verify Contact Information
    [Arguments]    ${address}=${None}    ${sub_district}=${None}    ${district}=${None}    ${city_province}=${None}    ${post_code}=${None}
    Run Keyword If    '${address}'!='${None}'    Verify Contact Information By Label    Address    ${address}
    Run Keyword If    '${sub_district}'!='${None}'    Verify Contact Information By Label    Sub-district    ${sub_district}
    Run Keyword If    '${district}'!='${None}'    Verify Contact Information By Label    District    ${district}
    Run Keyword If    '${city_province}'!='${None}'    Verify Contact Information By Label    City/Province    ${city_province}
    Run Keyword If    '${post_code}'!='${None}'    Verify Contact Information By Label    Postcode    ${post_code}

Verify Contact Information By Label
    [Arguments]    ${contact_information_label}    ${expected_value}
    ${element}    Generate Element From Dynamic Locator    ${lbl_contact_information_by_label}    ${contact_information_label}
    Wait Until Element Contain Text    ${element}    ${expected_value}
    
Verify Billing Address
    [Arguments]    ${address}=${None}    ${sub_district}=${None}    ${district}=${None}    ${city_province}=${None}    ${post_code}=${None}
    Run Keyword If    '${address}'!='${None}'    Verify Billing Address By Label    Address    ${address}
    Run Keyword If    '${sub_district}'!='${None}'    Verify Billing Address By Label    Sub-district    ${sub_district}
    Run Keyword If    '${district}'!='${None}'    Verify Billing Address By Label    District    ${district}
    Run Keyword If    '${city_province}'!='${None}'    Verify Billing Address By Label    City/Province    ${city_province}
    Run Keyword If    '${post_code}'!='${None}'    Verify Billing Address By Label    Postcode    ${post_code}

Verify Billing Address By Label
    [Arguments]    ${billing_address_label}    ${expected_value}
    ${element}    Generate Element From Dynamic Locator    ${lbl_billing_address_by_label}    ${billing_address_label}
    Wait Until Element Contain Text    ${element}    ${expected_value}