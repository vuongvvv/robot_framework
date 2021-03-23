*** Settings ***
Resource    ../../../resources/locators/admintools/call_verification_qr_39/brand_call_verfication_qr_39_locators.robot
Resource    ../../common/locator_common.robot
Resource    ../../../../api/keywords/common/string_common.robot
Resource    ../common/common_keywords.robot
Resource    ../../../resources/testdata/all/admintools/merchant_qr_39/brand_call_verification_testdata.robot

# Library    SeleniumLibrary    
Resource    ../../common/robot_browser_web_common.robot
*** Keywords ***
Verify Brand Table Column Headers
    [Arguments]    ${column_headers}
    ${fetch_column_headers}=    Get Elements Text    ${lbl_brands_column_headers}
    Lists Should Be Equal    ${column_headers}    ${fetch_column_headers}

Search Call Verification
    [Arguments]    ${call_verification_status}=${None}
    Run Keyword If    '${call_verification_status}'!='${None}'    Select Dropwdown List By Label    ${ddl_search_call_verification_status}    ${call_verification_status}
    Click Visible Element    ${btn_search}
        
Edit Brand Information
    [Arguments]    ${category}=${None}    ${sub_category}=${None}
    ...    ${address}=${None}    ${province}=${None}    ${district}=${None}    ${sub_district}=${None}
    ...    ${mobile}=${None}    ${email}=${None}
    ...    ${lang}=en
    # brand information
    Run Keyword If    '${category}'!='${None}'    Select Dropdown Item By Dropdown Name    ${brand_label_${lang}}    ${brand_information_category_${lang}}    ${category}
    Run Keyword If    '${sub_category}'!='${None}'    Select Dropdown Item By Dropdown Name    ${brand_label_${lang}}    ${brand_information_sub_category_${lang}}    ${sub_category}
    Run Keyword If    '${address}'!='${None}'    Input Text Into Visible Element    ${txa_brand_information_address}    ${address}
    Run Keyword If    '${province}'!='${None}'    Select Dropdown Item By Dropdown Name    ${brand_label_${lang}}    ${brand_information_province_${lang}}    ${province}
    Run Keyword If    '${district}'!='${None}'    Select Dropdown Item By Dropdown Name    ${brand_label_${lang}}    ${brand_information_district_${lang}}    ${district}
    Run Keyword If    '${sub_district}'!='${None}'    Select Dropdown Item By Dropdown Name    ${brand_label_${lang}}    ${brand_information_sub_district_${lang}}    ${sub_district}
    Run Keyword If    '${mobile}'!='${None}'    Input Text Into Visible Element    ${txt_brand_information_mobile}    ${mobile}
    Run Keyword If    '${email}'!='${None}'    Input Text Into Visible Element    ${txa_brand_information_email}    ${email}

Edit Call Verification Details
    [Arguments]    ${call_verification_status}=${None}    ${call_verification_reject_reason}=${None}    ${call_verification_remark}=${None}
    Run Keyword If    '${call_verification_status}'!='${None}'    Select Dropdown Item By Dropdown Name    ${call_verification_details_label_en}    ${call_verification_details_status_en}    ${call_verification_status}
    Run Keyword If    '${call_verification_reject_reason}'!='${None}'    Select Dropdown Item By Dropdown Name    ${call_verification_details_label_en}    ${call_verification_details_reject_reason_en}    ${call_verification_reject_reason}
    Run Keyword If    '${call_verification_remark}'!='${None}'    Input Text Into Visible Element    ${txa_call_verification_details_remark}    ${call_verification_remark}

Edit Shop Information
    [Arguments]    ${shop_name_th}=${None}    ${shop_name_en}=${None}
    ...    ${shop_types}=${None}    ${address}=${None}   ${province}=${None}    ${district}=${None}    ${sub_district}=${None}
    ...    ${contact_person_email_address}=${None}    ${contact_person_mobile_phone}=${None}    ${contact_full_name}=${None}
    ...    ${shop_order}=1    ${lang}=en
    Run Keyword If    '${shop_types}'!='${None}'    Select Shop Type In Shop Information    ${shop_information_label_${lang}}    ${shop_types}    shop_order=${shop_order}    lang=${lang}
    ${txa_element}    Generate Element From Dynamic Locator    ${txa_shop_information_address}    ${shop_order}
    Run Keyword If    '${address}'!='${None}'    Clean And Input Text Into Element    ${txa_element}    ${address}
    Run Keyword If    '${province}'!='${None}'    Select Dropdown Item By Dropdown Name For Shop    ${shop_information_label_${lang}}    ${shop_information_province_${lang}}    ${province}    ${shop_order}
    Run Keyword If    '${district}'!='${None}'    Select Dropdown Item By Dropdown Name For Shop    ${shop_information_label_${lang}}    ${shop_information_district_${lang}}    ${district}    ${shop_order}
    Run Keyword If    '${sub_district}'!='${None}'    Select Dropdown Item By Dropdown Name For Shop    ${shop_information_label_${lang}}    ${shop_information_sub_district_${lang}}    ${sub_district}    ${shop_order}
    ${txa_shop_name_thai}    Generate Element From Dynamic Locator    ${txa_shop_information_name_th}    ${shop_order}
    Run Keyword If    '${shop_name_th}'!='${None}'    Clean And Input Text Into Element    ${txa_shop_name_thai}    ${shop_name_th}
    ${txa_shop_name_english}    Generate Element From Dynamic Locator    ${txa_shop_information_name_en}    ${shop_order}
    Run Keyword If    '${shop_name_en}'!='${None}'    Clean And Input Text Into Element    ${txa_shop_name_english}    ${shop_name_en}
    ${txa_shop_contact_person_email_address}    Generate Element From Dynamic Locator    ${txa_shop_information_contact_person_email_address}    ${shop_order}
    Run Keyword If    '${contact_person_email_address}'!='${None}'    Clean And Input Text Into Element    ${txa_shop_contact_person_email_address}    ${contact_person_email_address}
    ${txt_shop_contact_person_mobile_phone}    Generate Element From Dynamic Locator    ${txt_shop_information_contact_person_mobile_phone}    ${shop_order}
    Run Keyword If    '${contact_person_mobile_phone}'!='${None}'    Clean And Input Text Into Element    ${txt_shop_contact_person_mobile_phone}    ${contact_person_mobile_phone}
    ${txa_shop_contact_full_name}    Generate Element From Dynamic Locator    ${txa_shop_information_contact_full_name}    ${shop_order}
    Run Keyword If    '${contact_full_name}'!='${None}'    Clean And Input Text Into Element    ${txa_shop_contact_full_name}    ${contact_full_name}
    
Click Save Brand Call Verification Information
    Click Visible Element    ${btn_save_brand_call_verification}

Select Dropdown Item By Dropdown Name
    [Arguments]    ${brand_information_label}    ${dropdown_name}    ${value}
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_brand_information_dropdown_list}    ${brand_information_label}    ${dropdown_name}
    Select Dropwdown List By Label    ${element_dropdown_list}    ${value}

Select Dropdown Item By Dropdown Name For Shop
    [Arguments]    ${shop_information_label}    ${dropdown_name}    ${value}    ${shop_information_order}=1
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_shop_information_dropdown_list}    ${shop_information_label}    ${dropdown_name}   ${shop_information_order} 
    Select Dropwdown List By Label    ${element_dropdown_list}    ${value}
    
Verify Current Item By Dropdown Name
    [Arguments]    ${brand_information_label}    ${dropdown_name}    ${value}
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_brand_information_dropdown_list}    ${brand_information_label}    ${dropdown_name}
    # ${element_text}    Get Selected Dropdown List    ${element_dropdown_list}
    # Should Be Equal    ${element_text}    ${value}
    Verify Selected Dropdown List    select[name='brandCategory']    ${value}

Verify Dropdown Is Disabled By Dropdown Name
    [Arguments]    ${brand_information_label}    ${dropdown_name}
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_brand_information_dropdown_list}    ${brand_information_label}    ${dropdown_name}
    Verify Element State    ${element_dropdown_list}    disabled
    
Verify Dropdown Is Enabled By Dropdown Name
    [Arguments]    ${brand_information_label}    ${dropdown_name}
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_brand_information_dropdown_list}    ${brand_information_label}    ${dropdown_name}
    Verify Element State    ${element_dropdown_list}

Verify Dropdown Is Disabled By Dropdown Name For Shop
    [Arguments]    ${shop_information_label}    ${dropdown_name}    ${shop_information_order}=1
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_shop_information_dropdown_list}    ${shop_information_label}    ${dropdown_name}    ${shop_information_order}
    Verify Element State    ${element_dropdown_list}    disabled

Verify Dropdown Is Enabled By Dropdown Name For Shop
    [Arguments]    ${shop_information_label}    ${dropdown_name}    ${shop_information_order}=1
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_shop_information_dropdown_list}    ${shop_information_label}    ${dropdown_name}    ${shop_information_order}
    Verify Element State    ${element_dropdown_list}
        
Click Edit By Brand Id
    [Arguments]    ${brand_id}
    ${edit_button_element}    Generate Element From Dynamic Locator    ${btn_edit_by_brand_id}    ${brand_id}
    Click Visible Element    ${edit_button_element}
    
Click View By Brand Id
    [Arguments]    ${brand_id}
    ${view_button_element}    Generate Element From Dynamic Locator    ${btn_view_by_brand_id}    ${brand_id}
    Click Visible Element    ${view_button_element}

Verify Brand Call Information By Label
    [Arguments]    ${brand_information_label}    ${label}    ${expected_value}
    ${element_label}    Generate Element From Dynamic Locator    ${lbl_brand_information}    ${brand_information_label}    ${label}
    Verify Element Text    ${element_label}    ${expected_value}
    
Verify Shop Information By Label
    [Arguments]    ${shop_information_label}    ${label}    ${expected_value}    ${shop_information_order}=1
    ${element_label}    Generate Element From Dynamic Locator    ${lbl_shop_information}    ${shop_information_label}    ${label}    ${shop_information_order}
    Verify Element Text    ${element_label}    ${expected_value}
    
Verify Current Item By Dropdown Name For Shop
    [Arguments]    ${dropdown_elements}    ${value}    ${shop_information_order}=1
    ${element_dropdown_list}    Get Element By Index     ${dropdown_elements}    ${shop_information_order}
    Verify Selected Dropdown List    ${element_dropdown_list}    ${value}
    
Verify Brand Information
    [Arguments]    ${service_type}=${None}    ${business_type}=${None}    ${brand_name_th}=${None}    ${owner_name_th}=${None}    ${brand_name_en}=${None}    ${owner_name_en}=${None}
    ...    ${category}=${None}    ${mobile}=${None}    ${sub_category}=${None}    ${email}=${None}    ${address}=${None}    ${date_of_birth}=${None}    ${province}=${None}    ${district}=${None}    ${sub_district}=${None}    ${post_code}=${None}
    ...    ${start_end_privilege}=${None}    ${true_card_privilege}=${None}    ${red_card_privilege}=${None}    ${black_card_privilege}=${None}
    ...    ${call_verification_status}=${None}    ${call_verification_reject_reason}=${None}    ${call_verification_remark}=${None}
    ...    ${lang}=en
    Run Keyword If    '${service_type}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_service_type_${lang}}    ${service_type}
    Run Keyword If    '${business_type}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_business_type_${lang}}    ${business_type}
    Run Keyword If    '${brand_name_th}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_brand_name_thai_${lang}}    ${brand_name_th}
    Run Keyword If    '${owner_name_th}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_owner_name_thai_${lang}}    ${owner_name_th}
    Run Keyword If    '${brand_name_en}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_brand_name_english_${lang}}    ${brand_name_en}
    Run Keyword If    '${owner_name_en}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_owner_name_english_${lang}}    ${owner_name_en}

    Run Keyword If    '${category}'!='${None}'    Verify Selected Dropdown List    ${ddl_brand_category}    ${category}
    Run Keyword If    '${mobile}'!='${None}'    Verify Textfield Value    ${txt_brand_information_mobile}    ${mobile}
    Run Keyword If    '${sub_category}'!='${None}'    Verify Selected Dropdown List    ${ddl_brand_sub_category}    ${sub_category}
    Run Keyword If    '${email}'!='${None}'    Verify Textfield Value    ${txa_brand_information_email}    ${email}
    Run Keyword If    '${address}'!='${None}'    Verify Textfield Value    ${txa_brand_information_address}    ${address}
    Run Keyword If    '${date_of_birth}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_date_of_birth_${lang}}    ${date_of_birth}    
    Run Keyword If    '${province}'!='${None}'    Verify Selected Dropdown List    ${ddl_brand_province}    ${province}
    Run Keyword If    '${district}'!='${None}'    Verify Selected Dropdown List    ${ddl_brand_district}    ${district}
    Run Keyword If    '${sub_district}'!='${None}'    Verify Selected Dropdown List    ${ddl_brand_sub_district}    ${sub_district}
    Run Keyword If    '${post_code}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_post_code_${lang}}    ${post_code}

    Run Keyword If    '${start_end_privilege}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_start_end_privilege_${lang}}    ${start_end_privilege}
    Run Keyword If    '${true_card_privilege}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_true_card_privilege_${lang}}    ${true_card_privilege}
    Run Keyword If    '${red_card_privilege}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_red_card_privilege_${lang}}    ${red_card_privilege}
    Run Keyword If    '${black_card_privilege}'!='${None}'    Verify Brand Call Information By Label    ${brand_label_${lang}}    ${brand_information_black_card_privilege_${lang}}    ${black_card_privilege}
    
Verify Shop Information
    [Arguments]    ${shop_name_th}=${None}    ${shop_name_en}=${None}    ${business_type}=${None}    ${wallet_no}=${None}    ${shop_type}=${None}
    ...    ${address}=${None}    ${province}=${None}    ${district}=${None}    ${sub_district}=${None}    ${post_code}=${None}
    ...    ${contact_person_email_address}=${None}    ${contact_person_mobile_phone}=${None}    ${contact_full_name}=${None}
    ...    ${shop_order}=1    ${lang}=en
    ${txa_shop_information_name_thai}    Generate Element From Dynamic Locator    ${txa_shop_information_name_th}    ${shop_order}
    Run Keyword If    '${shop_name_th}'!='${None}'    Verify Textfield Value    ${txa_shop_information_name_thai}    ${shop_name_th}
    ${txa_shop_information_name_english}    Generate Element From Dynamic Locator    ${txa_shop_information_name_en}    ${shop_order}
    Run Keyword If    '${shop_name_en}'!='${None}'    Verify Textfield Value    ${txa_shop_information_name_english}    ${shop_name_en}
    Run Keyword If    '${business_type}'!='${None}'    Verify Shop Information By Label    ${shop_information_label_${lang}}    ${shop_information_business_type_${lang}}    ${business_type}    ${shop_order}
    Run Keyword If    '${wallet_no}'!='${None}'    Verify Shop Information By Label    ${shop_information_label_${lang}}    ${shop_information_wallet_no_${lang}}    ${wallet_no}    ${shop_order}
    Run Keyword If    '${shop_type}'!='${None}'    Verify Shop Type In Shop Information    ${shop_information_label_${lang}}    ${shop_type}    ${shop_order}    ${lang}
    ${txa_element}    Generate Element From Dynamic Locator    ${txa_shop_information_address}    ${shop_order}
    Run Keyword If    '${address}'!='${None}'    Verify Textfield Value    ${txa_element}    ${address}
    Run Keyword If    '${province}'!='${None}'    Verify Current Item By Dropdown Name For Shop    ${ddl_shop_province_elements}    ${province}    ${shop_order}
    Run Keyword If    '${district}'!='${None}'    Verify Current Item By Dropdown Name For Shop    ${ddl_shop_district_elements}    ${district}    ${shop_order}
    Run Keyword If    '${sub_district}'!='${None}'    Verify Current Item By Dropdown Name For Shop    ${ddl_shop_sub_district_elements}    ${sub_district}    ${shop_order}
    Run Keyword If    '${post_code}'!='${None}'    Verify Shop Information By Label    ${shop_information_label_${lang}}    ${shop_information_post_code_${lang}}    ${post_code}    ${shop_order}
    ${txa_shop_information_contact_person_email_address}    Generate Element From Dynamic Locator    ${txa_shop_information_contact_person_email_address}    ${shop_order}
    Run Keyword If    '${contact_person_email_address}'!='${None}'    Verify Textfield Value    ${txa_shop_information_contact_person_email_address}    ${contact_person_email_address}
    ${txt_shop_information_contact_person_mobile_phone}    Generate Element From Dynamic Locator    ${txt_shop_information_contact_person_mobile_phone}    ${shop_order}
    Run Keyword If    '${contact_person_mobile_phone}'!='${None}'    Verify Textfield Value    ${txt_shop_information_contact_person_mobile_phone}    ${contact_person_mobile_phone}
    ${txa_shop_contact_full_name}    Generate Element From Dynamic Locator    ${txa_shop_information_contact_full_name}    ${shop_order}
    Run Keyword If    '${contact_full_name}'!='${None}'    Verify Textfield Value    ${txa_shop_contact_full_name}    ${contact_full_name}
    
Clear Search Results
    Click Visible Element    ${btn_clear_search_results}
    
Click Cancel Button
    Click Visible Element    ${btn_cancel}

Click Load More Shop Button
    Click Visible Element    ${btn_load_more_shop}

Select Shop Type In Shop Information
    [Arguments]    ${shop_information_label}    ${shop_types}    ${shop_order}=1    ${lang}=en
    ${chk_offline_shop_type_element}    Run Keyword If    '${lang}'=='en'    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label}    Offline    ${shop_order}
    ...    ELSE    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label}    มีหน้าร้าน    ${shop_order}
    ${is_contain_offline}    Is String Contain    ${shop_types}    Offline
    Run Keyword If    ${is_contain_offline}==${True}    Select Visible Checkbox    ${chk_offline_shop_type_element}
    ...    ELSE    Unselect Visible Checkbox    ${chk_offline_shop_type_element}
    
    ${chk_online_shop_type_element}    Run Keyword If    '${lang}'=='en'    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label}    Online    ${shop_order}
    ...    ELSE    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label}    ไม่มีหน้าร้าน    ${shop_order}
    ${is_contain_online}    Is String Contain    ${shop_types}    Online
    Run Keyword If    ${is_contain_online}==${True}    Select Visible Checkbox    ${chk_online_shop_type_element}
    ...    ELSE    Unselect Visible Checkbox    ${chk_online_shop_type_element}    

Verify Shop Type In Shop Information
    [Arguments]    ${shop_information_label}    ${shop_types}    ${shop_order}    ${lang}
    ${chk_offline_shop_type_element}    Run Keyword If    '${lang}'=='en'    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label}    Offline    ${shop_order}
    ...    ELSE    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label}    มีหน้าร้าน    ${shop_order}
    ${is_contain_offline}    Is String Contain    ${shop_types}    Offline
    Run Keyword If    ${is_contain_offline}==${True}    Verify Checkbox State    ${chk_offline_shop_type_element}    ${True}
    ...    ELSE    Verify Checkbox State    ${chk_offline_shop_type_element}
    
    ${chk_online_shop_type_element}    Run Keyword If    '${lang}'=='en'    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label}    Online    ${shop_order}
    ...    ELSE    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label}    ไม่มีหน้าร้าน    ${shop_order}
    ${is_contain_online}    Is String Contain    ${shop_types}    Online
    Run Keyword If    ${is_contain_online}==${True}    Verify Checkbox State    ${chk_online_shop_type_element}    ${True}
    ...    ELSE    Verify Checkbox State    ${chk_online_shop_type_element}
    
Verify Elements On View Brand Information Page Are Disabled
    [Arguments]    ${number_of_shops}=1
    # brand information
    # Verify Dropdown Is Disabled By Dropdown Name    ${brand_label_en}    ${brand_information_category_en}
    # Verify Dropdown Is Disabled By Dropdown Name    ${brand_label_en}    ${brand_information_sub_category_en}
    Verify Element State    ${txa_brand_information_address}    disabled
    # Verify Dropdown Is Disabled By Dropdown Name    ${brand_label_en}    ${brand_information_province_en}
    # Verify Dropdown Is Disabled By Dropdown Name    ${brand_label_en}    ${brand_information_district_en}
    # Verify Dropdown Is Disabled By Dropdown Name    ${brand_label_en}    ${brand_information_sub_district_en}
    
    # # shop information
    # FOR    ${index}    IN RANGE    1    ${${number_of_shops}+1}
    # ${chk_offline_shop_type_element}    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label_en}    Offline    ${index}
    # Verify Element State    ${chk_offline_shop_type_element}    disabled
    # ${chk_online_shop_type_element}    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label_en}    Online    ${index}
    # Verify Element State    ${chk_offline_shop_type_element}    disabled
    # ${txa_element}    Generate Element From Dynamic Locator    ${txa_shop_information_address}    ${index}
    # Verify Element State    ${txa_element}    disabled
    # Verify Dropdown Is Disabled By Dropdown Name For Shop    ${shop_information_label_en}    ${shop_information_province_en}    ${index}
    # Verify Dropdown Is Disabled By Dropdown Name For Shop    ${shop_information_label_en}    ${shop_information_district_en}    ${index}
    # Verify Dropdown Is Disabled By Dropdown Name For Shop    ${shop_information_label_en}    ${shop_information_sub_district_en}    ${index}
    # END
    # Verify Element State    ${btn_save_brand_call_verification}    disabled
    
Verify Elements On View Brand Information Page Are Enabled
    [Arguments]    ${number_of_shops}=1
    # brand information
    Verify Dropdown Is Enabled By Dropdown Name    ${brand_label_en}    ${brand_information_category_en}
    Verify Dropdown Is Enabled By Dropdown Name    ${brand_label_en}    ${brand_information_sub_category_en}
    Verify Element State    ${txa_brand_information_address}
    Verify Dropdown Is Enabled By Dropdown Name    ${brand_label_en}    ${brand_information_province_en}
    Verify Dropdown Is Enabled By Dropdown Name    ${brand_label_en}    ${brand_information_district_en}
    Verify Dropdown Is Enabled By Dropdown Name    ${brand_label_en}    ${brand_information_sub_district_en}
    
    # shop information
    FOR    ${index}    IN RANGE    1    ${${number_of_shops}+1}
    ${chk_offline_shop_type_element}    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label_en}    Offline    ${index}
    Verify Element State    ${chk_offline_shop_type_element}
    ${chk_online_shop_type_element}    Generate Element From Dynamic Locator    ${chk_shop_information_type}    ${shop_information_label_en}    Online    ${index}
    Verify Element State    ${chk_offline_shop_type_element}
    ${txa_element}    Generate Element From Dynamic Locator    ${txa_shop_information_address}    ${index}
    Verify Element State    ${txa_element}
    Verify Dropdown Is Enabled By Dropdown Name For Shop    ${shop_information_label_en}    ${shop_information_province_en}    ${index}
    Verify Dropdown Is Enabled By Dropdown Name For Shop    ${shop_information_label_en}    ${shop_information_district_en}    ${index}
    Verify Dropdown Is Enabled By Dropdown Name For Shop    ${shop_information_label_en}    ${shop_information_sub_district_en}    ${index}
    END
    Verify Element State    ${btn_save_brand_call_verification}

Verify Reject Reason And Remark Fields On Call Verification Details Are Disabled
    Verify Dropdown Is Disabled By Dropdown Name    ${call_verification_details_label_en}    ${call_verification_details_reject_reason_en}
    Verify Element State    ${txa_call_verification_details_remark}    disabled

Verify Call Verification Details Status Dropdown Is Disabled
    Verify Dropdown Is Disabled By Dropdown Name    ${call_verification_details_label_en}    ${call_verification_details_status_en}
    
Verify Reject Reason And Remark Fields On Call Verification Details Are Enabled
    Verify Dropdown Is Enabled By Dropdown Name    ${call_verification_details_label_en}    ${call_verification_details_reject_reason_en}
    Verify Element State    ${txa_call_verification_details_remark}

Verify Call Verification Details Status Dropdown Items
    [Arguments]    @{expected_item_list}
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_brand_information_dropdown_list}    ${call_verification_details_label_en}    ${call_verification_details_status_en}
    Verify Dropdown Items    ${element_dropdown_list}    ${expected_item_list}
    
Verify Call Verification Details Reject Reason Dropdown Items
    [Arguments]    @{expected_item_list}
    ${element_dropdown_list}    Generate Element From Dynamic Locator    ${ddl_brand_information_dropdown_list}    ${call_verification_details_label_en}    ${call_verification_details_reject_reason_en}
    Verify Dropdown Items    ${element_dropdown_list}    ${expected_item_list}