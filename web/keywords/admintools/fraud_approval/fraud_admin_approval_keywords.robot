*** Settings ***
Resource    ../../../resources/locators/admintools/fraud_approval/fraud_admin_approval_locators.robot
Resource    ../../common/locator_common.robot
Resource    ../../../../api/keywords/common/string_common.robot
Resource    ../../../../api/keywords/common/date_time_common.robot
Resource    ../common/common_keywords.robot
Resource    ../../../resources/testdata/all/admintools/merchant_qr_39/fraud_admin_approval_testdata.robot

*** Keywords ***
Verify Brand Table Column Headers
    [Arguments]    ${column_headers}
    ${fetch_column_headers}=    Get Elements Text    ${lbl_brands_column_headers}
    Lists Should Be Equal    ${column_headers}    ${fetch_column_headers}

Search Merchants
    [Arguments]    ${brand_id}=${None}    ${true_money_wallet_no}=${None}    ${brand_name_en}=${None}    ${registration_channel}=${None}    ${fraud_status}=${None}
    Run Keyword If    '${brand_id}'!='${None}'    Input Text Into Visible Element    ${txt_brand_id}    ${brand_id}
    Run Keyword If    '${brand_name_en}'!='${None}'    Input Text Into Visible Element    ${txt_brand_name_en}    ${brand_name_en}
    Run Keyword If    '${registration_channel}'!='${None}'    Select Dropwdown List By Label    ${ddl_registration_channel}    ${registration_channel}
    Run Keyword If    '${true_money_wallet_no}'!='${None}'    Input Text Into Visible Element    ${txt_true_money_wallet_no}    ${true_money_wallet_no}
    Run Keyword If    '${fraud_status}'!='${None}'    Select Dropwdown List By Label    ${ddl_search_fraud_status}    ${fraud_status}
    Click Visible Element    ${btn_search}

Clear Search Results
    Click Visible Element    ${btn_clear_search_results}

Save Fraud Approval Information
    Click Visible Element    ${btn_save}

Edit Brand Information
    [Arguments]    ${category}=${None}    ${sub_category}=${None}
    Run Keyword If    '${category}'!='${None}'    Select Dropwdown List By Label    ${ddl_brand_category}    ${category}
    Run Keyword If    '${sub_category}'!='${None}'    Select Dropwdown List By Label    ${ddl_brand_sub_category}    ${sub_category}

Edit Fraud Approval Status
    [Arguments]    ${fraud_status}=${None}    ${remark}=${None}
    Run Keyword If    '${fraud_status}'!='${None}'    Select Dropwdown List By Label    ${ddl_fraud_status}    ${fraud_status}
    Run Keyword If    '${remark}'!='${None}'    Input Text Into Visible Element    ${txa_fraud_review_remark}    ${remark}

Click View By Brand Id
    [Arguments]    ${brand_id}
    ${view_button_element}    Generate Element From Dynamic Locator    ${btn_view_by_brand_id}    ${brand_id}
    Click Visible Element    ${view_button_element}
    
Click Edit By Brand Id
    [Arguments]    ${brand_id}
    ${edit_button_element}    Generate Element From Dynamic Locator    ${btn_edit_by_brand_id}    ${brand_id}
    Click Visible Element    ${edit_button_element}

Click Load More Shop Button
    Click Visible Element    ${btn_load_more_shop}
    
Verify Brand Information
    [Arguments]    ${brand_name_th}=${None}    ${business_type}=${None}
    ...    ${brand_name_en}=${None}    ${service_type}=${None}
    ...    ${category}=${None}    ${register_channel}=${None}
    ...    ${sub_category}=${None}    ${settlement_type}=${None}    
    ...    ${address}=${None}    ${province}=${None}    ${district}=${None}    ${sub_district}=${None}    ${post_code}=${None}
    ...    ${lang}=en
    Run Keyword If    '${brand_name_th}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_brand_name_thai_${lang}}    ${brand_name_th}
    Run Keyword If    '${business_type}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_business_type_${lang}}    ${business_type}
    Run Keyword If    '${brand_name_en}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_brand_name_english_${lang}}    ${brand_name_en}
    Run Keyword If    '${service_type}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_service_type_${lang}}    ${service_type}    
    Run Keyword If    '${category}'!='${None}'    Verify Current Item By Dropdown Name On Fraud Approval    ${brand_label_${lang}}    ${brand_information_category_${lang}}    ${category}
    Run Keyword If    '${register_channel}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_register_channel_${lang}}    ${register_channel}
    Run Keyword If    '${sub_category}'!='${None}'    Verify Current Item By Dropdown Name On Fraud Approval    ${brand_label_${lang}}    ${brand_information_sub_category_${lang}}    ${sub_category}
    Run Keyword If    '${settlement_type}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_settlement_type_${lang}}    ${settlement_type}
    Run Keyword If    '${address}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_address_${lang}}    ${address}
    Run Keyword If    '${province}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_province_${lang}}    ${province}
    Run Keyword If    '${district}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_district_${lang}}    ${district}
    Run Keyword If    '${sub_district}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_sub_district_${lang}}    ${sub_district}
    Run Keyword If    '${post_code}'!='${None}'    Verify Brand Information By Label    ${brand_label_${lang}}    ${brand_information_post_code_${lang}}    ${post_code}

Verify Owner Information
    [Arguments]    ${owner_name}=${None}    ${thai_id}=${None}
    ...    ${mobile}=${None}    ${true_money_wallet_no}=${None}
    ...    ${email}=${None}    ${date_of_birth}=${None}
    ...    ${address}=${None}    ${province}=${None}    ${district}=${None}    ${sub_district}=${None}    ${post_code}=${None}
    ...    ${lang}=en

    Run Keyword If    '${owner_name}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_owner_name_${lang}}    ${owner_name}
    Run Keyword If    '${thai_id}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_thai_id_${lang}}    ${thai_id}
    Run Keyword If    '${mobile}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_mobile_${lang}}    ${mobile}
    Run Keyword If    '${true_money_wallet_no}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_email_${lang}}    ${email}
    Run Keyword If    '${date_of_birth}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_date_of_birth_${lang}}    ${date_of_birth}    
    Run Keyword If    '${address}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_address_${lang}}    ${address}
    Run Keyword If    '${province}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_province_${lang}}    ${province}
    Run Keyword If    '${district}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_district_${lang}}    ${district}
    Run Keyword If    '${sub_district}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_sub_district_${lang}}    ${sub_district}
    Run Keyword If    '${post_code}'!='${None}'    Verify Brand Information By Label    ${owner_information_label_${lang}}    ${owner_information_post_code_${lang}}    ${post_code}

Verify Shop Information
    [Arguments]    ${shop_name_th}=${None}    ${contact_name}=${None}    ${shop_image}=checked
    ...    ${shop_name_en}=${None}    ${mobile}=${None}
    ...    ${address}=${None}    ${email}=${None}
    ...    ${province}=${None}    ${district}=${None}    ${sub_district}=${None}    ${post_code}=${None}
    ...    ${shop_order}=1    ${lang}=en
    Run Keyword If    '${shop_name_th}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_shop_name_thai_${lang}}    ${shop_name_th}    ${shop_order}    
    Run Keyword If    '${contact_name}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_contact_name_${lang}}    ${contact_name}    ${shop_order}    
    Run Keyword If    '${shop_name_en}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_shop_name_english_${lang}}    ${shop_name_en}    ${shop_order}    
    Run Keyword If    '${mobile}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_mobile_${lang}}    ${mobile}    ${shop_order}
    Run Keyword If    '${address}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_address_${lang}}    ${address}    ${shop_order}    
    Run Keyword If    '${email}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_email_${lang}}    ${email}    ${shop_order}
    Run Keyword If    '${province}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_province_${lang}}    ${province}    ${shop_order}    
    Run Keyword If    '${district}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_district_${lang}}    ${district}    ${shop_order}    
    Run Keyword If    '${sub_district}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_sub_district_${lang}}    ${sub_district}    ${shop_order}    
    Run Keyword If    '${post_code}'!='${None}'    Verify Shop Information By Label On Fraud Approval    ${shop_information_post_code_${lang}}    ${post_code}    ${shop_order}    
    Run Keyword If    '${shop_image}'!='${None}'    Verify Shop Store Front Image Displays    ${shop_order}    

Verify Brand And Shop Documents
    ${element_image_shop_1}    Generate Element From Dynamic Locator    ${img_shop_store_front}    1
    Verify Document Review For Shop    ${element_image_shop_1}    5
    ${element_image_shop_2}    Generate Element From Dynamic Locator    ${img_shop_store_front}    2
    Verify Document Review For Shop    ${element_image_shop_2}
    Verify Document Review For Brand    ${img_thai_id}
    Verify Document Review For Brand    ${img_owner_image}
    Verify Document Review For Brand    ${img_bank_passbook}
    
Verify Fraud Review
    [Arguments]    ${dipchip}=${None}    ${revise_no}=${None}
    ...    ${fraud_status}=${None}    ${remark}=${None}
    ...    ${lang}=en
    Run Keyword If    '${dipchip}'!='${None}'    Verify Brand Information By Label    ${fraud_review_label_${lang}}    ${fraud_review_information_dipchip_${lang}}    ${dipchip}
    Run Keyword If    '${revise_no}'!='${None}'    Verify Brand Information By Label    ${fraud_review_label_${lang}}    ${fraud_review_information_revise_no_${lang}}    ${revise_no}
    Run Keyword If    '${fraud_status}'!='${None}'    Verify Current Item By Dropdown Name On Fraud Approval    ${fraud_review_label_${lang}}    ${fraud_review_information_fraud_status_${lang}}    ${fraud_status}
    Run Keyword If    '${remark}'!='${None}'    Textarea Value Should Be    ${txa_fraud_review_remark}    ${remark}

Verify Brand Information By Label
    [Arguments]    ${brand_information_label}    ${label}    ${expected_value}
    ${element_label}    Generate Element From Dynamic Locator    ${lbl_brand_information}    ${brand_information_label}    ${label}
    Check Element Text    ${element_label}    ${expected_value}

Verify Shop Information By Label On Fraud Approval
    [Arguments]    ${label}    ${expected_value}    ${shop_order}
    ${element_label}    Generate Element From Dynamic Locator    ${lbl_shop_information}    ${label}    ${shop_order}
    Check Element Text    ${element_label}    ${expected_value}

Verify Shop Store Front Image Displays
    [Arguments]    ${shop_order}
    ${element_image}    Generate Element From Dynamic Locator    ${img_shop_store_front}    ${shop_order}
    Verify Element Is Visible    ${element_image}

Verify Document Review For Shop
    [Arguments]    ${element_document}    ${number_of_documents}=1
    Click Visible Element    ${element_document}
    Verify Element Is Visible    ${mdl_document_preview_shop}
    FOR    ${index}    IN RANGE    1    ${number_of_documents}
        Check Element Text    ${lbl_caption_show}    ${index}/${number_of_documents}
        Click Visible Element    ${btn_next_on_shop_preview}
    END
    Check Element Text    ${lbl_caption_show}    ${number_of_documents}/${number_of_documents}
    Click Visible Element    ${btn_close_preview_model_shop}

Verify Document Review For Brand
    [Arguments]    ${element_document}
    Click Visible Element    ${element_document}
    Verify Element Is Visible    ${mdl_document_preview_brand_documents}
    Click Visible Element    ${btn_close_preview_model_brand_documents}

Verify Current Item By Dropdown Name On Fraud Approval
    [Arguments]    ${brand_information_label}    ${dropdown_name}    ${value}
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_brand_information_dropdown_list}    ${brand_information_label}    ${dropdown_name}
    ${element_text}    Get Selected List Label    ${element_dropdown_list}
    Should Be Equal    ${element_text}    ${value}

Verify Fraud Status Dropdown Items
    [Arguments]    @{expected_items}
    Verify Dropdown Items    ${ddl_fraud_status}    ${expected_items}
    
Verify User Is Not Allowed To Update Fraud Approval Status When Status Is Passed Or Rejected
    Verify Element Is Disabled    ${ddl_brand_category}
    Verify Element Is Disabled    ${ddl_brand_sub_category}
    Verify Element Is Disabled    ${ddl_fraud_status}
    Verify Element Is Disabled    ${txa_fraud_review_remark}
    Verify Element Is Disabled    ${btn_save}