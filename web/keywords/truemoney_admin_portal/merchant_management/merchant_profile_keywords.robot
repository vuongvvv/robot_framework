*** Settings ***
Resource    ../../../resources/locators/truemoney_admin_portal/merchant_management/merchant_profile_locator.robot
Resource    ../../common/locator_common.robot

*** Keywords ***
Verify Business Owner Detail
    [Arguments]    ${business_type}=${None}    ${identification_document_type}=${None}    ${thai_id}=${None}
    Run Keyword If    '${business_type}'!='${None}'    Verify Business Owner Detail By Label    Business Type    ${business_type}
    Run Keyword If    '${identification_document_type}'!='${None}'    Verify Business Owner Detail By Label    Identification Document Type    ${identification_document_type}
    Run Keyword If    '${thai_id}'!='${None}'    Verify Business Owner Detail By Label    Thai ID    ${thai_id}

Verify Merchant Detail
    [Arguments]    ${contact_address_address}=${None}    ${contact_address_sub_district}=${None}    ${contact_address_district}=${None}    ${contact_address_city_province}=${None}    ${contact_address_postcode}=${None}
    ...    ${billing_address_address}=${None}    ${billing_address_sub_district}=${None}    ${billing_address_district}=${None}    ${billing_address_city_province}=${None}    ${billing_address_postcode}=${None}
    Run Keyword If    '${contact_address_address}'!='${None}'    Verify Merchant Detail By Label    Contact Address    Address    ${contact_address_address}
    Run Keyword If    '${contact_address_sub_district}'!='${None}'    Verify Merchant Detail By Label    Contact Address    Sub-district    ${contact_address_sub_district}
    Run Keyword If    '${contact_address_district}'!='${None}'    Verify Merchant Detail By Label    Contact Address    District    ${contact_address_district}
    Run Keyword If    '${contact_address_city_province}'!='${None}'    Verify Merchant Detail By Label    Contact Address    City/Province    ${contact_address_city_province}
    Run Keyword If    '${contact_address_postcode}'!='${None}'    Verify Merchant Detail By Label    Contact Address    Postcode    ${contact_address_postcode}
    Run Keyword If    '${billing_address_address}'!='${None}'    Verify Merchant Detail By Label    Billing Address    Address    ${billing_address_address}
    Run Keyword If    '${billing_address_sub_district}'!='${None}'    Verify Merchant Detail By Label    Billing Address    Sub-district    ${billing_address_sub_district}
    Run Keyword If    '${billing_address_district}'!='${None}'    Verify Merchant Detail By Label    Billing Address    District    ${billing_address_district}
    Run Keyword If    '${billing_address_city_province}'!='${None}'    Verify Merchant Detail By Label    Billing Address    City/Province    ${billing_address_city_province}
    Run Keyword If    '${billing_address_postcode}'!='${None}'    Verify Merchant Detail By Label    Billing Address    Postcode    ${billing_address_postcode}

Verify Business Owner Detail By Label
    [Arguments]    ${label}    ${expected_value}
    ${element}    Generate Element From Dynamic Locator    ${lbl_merchant_profile_business_owner_detail_by_label}    ${label}
    Wait Element Is Visible    ${element}    30s
    Check Element Text    ${element}    ${expected_value}

Verify Merchant Detail By Label
    [Arguments]    ${label}    ${sub_label}    ${expected_value}
    ${element}    Generate Element From Dynamic Locator    ${lbl_merchant_detail_contact_billing_address_by_label}    ${label}    ${sub_label}
    Wait Element Is Visible    ${element}    30s
    Check Element Text    ${element}    ${expected_value}
    
Verify Brand Kyb Documents
    [Arguments]    ${business_owner_thai_id_or_passport}=${None}    ${vat_certificate}=${None}    ${bank_passbook_front_page}=${None}
    ...    ${shop_map}=${None}    ${storefront_photos}=${None}    ${rental_contact}=${None}
    ...    ${household_registration}=${None}    ${company_registration}=${None}
    Run Keyword If    '${business_owner_thai_id_or_passport}'!='${None}'    Verify Brand Kyb Document By Image Name    ${business_owner_thai_id_or_passport}
    Run Keyword If    '${vat_certificate}'!='${None}'    Verify Brand Kyb Document By Image Name    ${vat_certificate}
    Run Keyword If    '${bank_passbook_front_page}'!='${None}'    Verify Brand Kyb Document By Image Name    ${bank_passbook_front_page}
    Run Keyword If    '${shop_map}'!='${None}'    Verify Brand Kyb Document By Image Name    ${shop_map}
    Run Keyword If    '${storefront_photos}'!='${None}'    Verify Brand Kyb Document By Image Name    ${storefront_photos}
    Run Keyword If    '${rental_contact}'!='${None}'    Verify Brand Kyb Document By Image Name    ${rental_contact}
    Run Keyword If    '${household_registration}'!='${None}'    Verify Brand Kyb Document By Image Name    ${household_registration}
    Run Keyword If    '${company_registration}'!='${None}'    Verify Brand Kyb Document By Image Name    ${company_registration}
    
Verify Brand Kyb Document By Image Name
    [Arguments]    ${image_name}
    ${element}    Generate Element From Dynamic Locator    ${lnk_brand_kyb_document}    ${image_name}
    Verify Element Is Visible    ${element}
    
Click Edit Kyb Status Button
    Wait Element Is Visible    ${btn_edit_kyb_status}    30s
    Click Visible Element    ${btn_edit_kyb_status}
    
Select Merchant Status
    [Arguments]    ${merchant_status}
    Click Visible Element    ${ddl_merchant_status}
    ${ddl_merchant_status_item_element}    Generate Element From Dynamic Locator    ${ddl_merchant_status_item}    ${merchant_status}
    Wait Element Is Visible    ${ddl_merchant_status_item_element}    
    Click Visible Element    ${ddl_merchant_status_item_element}

Update Merchant Profile Information
    [Arguments]    ${merchant_status}=${None}    ${note}=${None}
    Run Keyword If    '${merchant_status}'!='${None}'    Select Merchant Status    ${merchant_status}
    Run Keyword If    '${merchant_status}'=='CERTIFICATED'    Unselect Visible Checkbox    ${chk_create_default_contract}
    Run Keyword If    '${note}'!='${None}'    Input Text Into Visible Element    ${txa_merchant_status_note}    ${note} 
    
Submit Merchant Profile Information
    Click Visible Element    ${btn_update_kyb_status}
    Click Visible Element    ${btn_confirm_update_merchant_information}
    
Update TrueMoney Merchant Operation Status
    [Arguments]    ${brand_id}    ${status}    ${note}=${None}
    Go To Url    https://backoffice-ui.tmn-dev.com/core/merchant-management/merchants/${brand_id}
    Click Edit Kyb Status Button
    Update Merchant Profile Information    merchant_status=${status}    note=${note}
    Submit Merchant Profile Information
    Wait Until Element Is Disappear    ${btn_confirm_update_merchant_information}   