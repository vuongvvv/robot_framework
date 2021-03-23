*** Settings ***
Resource    ../../../resources/locators/admintools/merchant_edit_mysql/merchant_edit_mysql_merchant_locators.robot
Resource    ../../../resources/locators/admintools/merchant_edit_mysql/merchant_edit_mysql_outlet_locators.robot

*** Variables ***
${create_merchant_json}    ../../resources/testdata/merchant_publisher/publish_merchant_created_event.json
${update_merchant_json}    ../../resources/testdata/merchant_publisher/publish_merchant_updated_event.json

*** Keywords ***
Search Merchant By Thai Merchant Name
    [Arguments]    ${thai_merchant_name}
    Input Text Into Visible Element    ${txt_thai_merchant_name}   ${thai_merchant_name}
    Click Visible Element    ${btn_search_merchant}

Search Outlet By Thai Outlet Name
    [Arguments]    ${thai_outlet_name}
    Input Text    ${txt_thai_outlet_name}   ${thai_outlet_name}
    Click Visible Element    ${btn_search_outlet}
    Wait Until Page Does Not Contain  ${hidden_side_bar}

Get BrandId Of Outlet
    Wait Until Element Is Visible    ${txt_brand_id_of_outlet}
    ${brand_id_of_outlet}=    Get Text    ${txt_brand_id_of_outlet}
    Set Test Variable    ${BRAND_ID_OF_OUTLET}         ${brand_id_of_outlet}

Open Edit Merchant Popup From 1st Merchant
    Click Visible Element     ${btn_edit_tr1st_row_merchant_table}

Open Edit Outlet Popup From 1st Outlet
    Click Visible Element     ${btn_edit_tr1st_row_outlet_table}

Get Merchant Information On Edit Merchant Popup
    ${merchant_id_before_update}                  Get Element Text                 ${txt_merchant_id}
    ${merchant_name_th_before_update}             Get Element Property    ${txa_merchant_name_th}            value
    ${merchant_name_en_before_update}             Get Element Property    ${txa_merchant_name_en}            value
    ${firstname_before_update}                    Get Element Property    ${txt_first_name}                 value
    ${lastname_before_update}                     Get Element Property    ${txt_last_name}                  value
    ${merchant_description_before_update}         Get Element Property    ${txt_merchant_description}       value
    ${merchant_email_before_update}               Get Element Property    ${txt_merchant_email}             value
    ${merchant_phone_no_before_update}            Get Element Property    ${txt_merchant_phone_no}           value
    ${merchant_mobile_no_before_update}           Get Element Property    ${txt_merchant_mobile_no}          value
    ${merchant_website_before_update}             Get Element Property    ${txt_merchant_website}           value
    ${merchant_facebook_before_update}            Get Element Property    ${txt_merchant_facebook}          value
    ${merchant_instagram_before_update}           Get Element Property    ${txt_merchant_instagram}         value
    ${merchant_twitter_before_update}             Get Element Property    ${txt_merchant_twitter}           value
    ${merchant_line_before_update}                Get Element Property    ${txt_merchant_line}              value
    Set Test Variable    ${TEST_DATA_MERCHANT_ID_BEFORE_UPDATE}         ${merchant_id_before_update}
    Set Test Variable    ${TEST_DATA_MERCHANT_NAME_TH_BEFORE_UPDATE}    ${merchant_name_th_before_update}
    Set Test Variable    ${TEST_DATA_MERCHANT_NAME_EN_BEFORE_UPDATE}    ${merchant_name_en_before_update}
    Set Test Variable    ${TEST_DATA_FIRSTNAME_BEFORE_UPDATE}           ${firstname_before_update}
    Set Test Variable    ${TEST_DATA_LASTNAME_BEFORE_UPDATE}            ${lastname_before_update}
    Set Test Variable    ${TEST_DATA_MERCHANT_WEBSITE_BEFORE_UPDATE}    ${merchant_website_before_update}
    Set Test Variable    ${TEST_DATA_MERCHANT_FACEBOOK_BEFORE_UPDATE}   ${merchant_facebook_before_update}
    Set Test Variable    ${TEST_DATA_MERCHANT_INSTAGRAM_BEFORE_UPDATE}  ${merchant_instagram_before_update}
    Set Test Variable    ${TEST_DATA_MERCHANT_TWITTER_BEFORE_UPDATE}    ${merchant_twitter_before_update}
    Set Test Variable    ${TEST_DATA_MERCHANT_LINE_BEFORE_UPDATE_DATA}  ${merchant_line_before_update}

Get Outlet Information On Edit Outlet Popup
    ${outlet_name_th_before_update}             Get Element Property    ${txa_outlet_name_th}               value
    ${outlet_name_en_before_update}             Get Element Property    ${txa_outlet_name_en}               value
    ${outlet_contact_firstname_before_update}   Get Element Property    ${txt_outlet_contact_first_name}     value
    ${outlet_contact_lastname_before_update}    Get Element Property    ${txt_outlet_contact_last_name}      value
    ${outlet_description_before_update}         Get Element Property    ${txt_outlet_description}          value
    ${outlet_contact_email_before_update}       Get Element Property    ${txt_outlet_contact_email}         value
    ${outlet_contact_phone_no_before_update}    Get Element Property    ${txt_outlet_contact_phone_no}       value
    ${outlet_contact_mobile_no_before_update}   Get Element Property    ${txt_outlet_contact_mobile_no}      value
    Set Test Variable    ${TEST_DATA_OUTLET_NAME_TH_BEFORE_UPDATE}                 ${outlet_name_th_before_update}
    Set Test Variable    ${TEST_DATA_OUTLET_NAME_EN_BEFORE_UPDATE}                 ${outlet_name_en_before_update}
    Set Test Variable    ${TEST_DATA_OUTLET_CONTACT_FIRSTNAME_BEFORE_UPDATE}       ${outlet_contact_firstname_before_update}
    Set Test Variable    ${TEST_DATA_OUTLET_CONTACT_LASTNAME_BEFORE_UPDATE}        ${outlet_contact_lastname_before_update}
    Set Test Variable    ${TEST_DATA_OUTLET_DESCRIPTION_BEFORE_UPDATE}             ${outlet_description_before_update}
    Set Test Variable    ${TEST_DATA_OUTLET_CONTACT_EMAIL_BEFORE_UPDATE}           ${outlet_contact_email_before_update}
    Set Test Variable    ${TEST_DATA_OUTLET_CONTACT_PHONE_NO_BEFORE_UPDATE}        ${outlet_contact_phone_no_before_update}
    Set Test Variable    ${TEST_DATA_OUTLET_CONTACT_MOBILE_NO_BEFORE_UPDATE}       ${outlet_contact_mobile_no_before_update}

Update Merchant Information On Edit Merchant Popup
    [Arguments]    ${merchant_name_th}=${None}    ${merchant_name_en}=${None}
    ...    ${firstname}=${None}    ${lastname}=${None}
    ...    ${merchant_description}=${None}   ${merchant_email}=${None}
    ...    ${merchant_phone_no}=${None}    ${merchant_mobile_no}=${None}
    ...    ${merchant_website}=${None}    ${merchant_facebook}=${None}
    ...    ${merchant_instagram}=${None}    ${merchant_twitter}=${None}
    ...    ${merchant_line}=${None}
    Run Keyword If    '${merchant_name_th}'!='${None}'    Input Text Into Visible Element    ${txa_merchant_name_th}    ${merchant_name_th}
    Run Keyword If    '${merchant_name_en}'!='${None}'    Input Text Into Visible Element    ${txa_merchant_name_en}    ${merchant_name_en}
    Run Keyword If    '${firstname}'!='${None}'    Input Text Into Visible Element    ${txt_first_name}    ${firstname}
    Run Keyword If    '${lastname}'!='${None}'    Input Text Into Visible Element    ${txt_last_name}    ${lastname}
    Run Keyword If    '${merchant_description}'!='${None}'    Input Text Into Visible Element    ${txt_merchant_description}    ${merchant_description}
    Run Keyword If    '${merchant_email}'!='${None}'    Input Text Into Visible Element    ${txt_merchant_email}    ${merchant_email}
    Run Keyword If    '${merchant_phone_no}'!='${None}'    Input Text Into Visible Element    ${txt_merchant_phone_no}     ${merchant_phone_no}
    Run Keyword If    '${merchant_mobile_no}'!='${None}'    Input Text Into Visible Element    ${txt_merchant_mobile_no}     ${merchant_mobile_no}
    Run Keyword If    '${merchant_website}'!='${None}'    Input Text Into Visible Element    ${txt_merchant_website}    ${merchant_website}
    Run Keyword If    '${merchant_facebook}'!='${None}'    Input Text Into Visible Element    ${txt_merchant_facebook}    ${merchant_facebook}
    Run Keyword If    '${merchant_instagram}'!='${None}'    Input Text Into Visible Element    ${txt_merchant_instagram}    ${merchant_instagram}
    Run Keyword If    '${merchant_twitter}'!='${None}'    Input Text Into Visible Element    ${txt_merchant_twitter}    ${merchant_twitter}
    Run Keyword If    '${merchant_line}'!='${None}'    Input Text Into Visible Element    ${txt_merchant_line}    ${merchant_line}
    Click Visible Element     ${btn_save_update_merchant}
    Click Visible Element     ${btn_confirm}
    
Update Outlet Information On Edit Outlet Popup
    [Arguments]    ${outlet_name_th_for_update}=${None}    ${outlet_name_en_for_update}=${None}
    ...    ${outlet_contact_firstname_for_update}=${None}    ${outlet_contact_lastname_for_update}=${None}
    ...    ${outlet_description_for_update}=${None}    ${outlet_contact_email_for_update}=${None}
    ...    ${outlet_contact_phone_no_for_update}=${None}    ${outlet_contact_mobile_no_for_update}=${None}
    Run Keyword If    '${outlet_name_th_for_update}'!='${None}'    Input Text Into Visible Element    ${txa_outlet_name_th}    ${outlet_name_th_for_update}
    Run Keyword If    '${outlet_name_en_for_update}'!='${None}'    Input Text Into Visible Element    ${txa_outlet_name_en}    ${outlet_name_en_for_update}
    Run Keyword If    '${outlet_contact_firstname_for_update}'!='${None}'    Input Text Into Visible Element    ${txt_outlet_contact_first_name}    ${outlet_contact_firstname_for_update}
    Run Keyword If    '${outlet_contact_lastname_for_update}'!='${None}'    Input Text Into Visible Element    ${txt_outlet_contact_last_name}    ${outlet_contact_lastname_for_update}
    Run Keyword If    '${outlet_description_for_update}'!='${None}'    Input Text Into Visible Element    ${txt_outlet_description}    ${outlet_description_for_update}
    Run Keyword If    '${outlet_contact_email_for_update}'!='${None}'    Input Text Into Visible Element    ${txt_outlet_contact_email}    ${outlet_contact_email_for_update}
    Run Keyword If    '${outlet_contact_phone_no_for_update}'!='${None}'    Input Text Into Visible Element    ${txt_outlet_contact_phone_no}    ${outlet_contact_phone_no_for_update}
    Run Keyword If    '${outlet_contact_mobile_no_for_update}'!='${None}'    Input Text Into Visible Element    ${txt_outlet_contact_mobile_no}    ${outlet_contact_mobile_no_for_update}
    Click Visible Element     ${btn_save_update_outlet}
    Click Visible Element     ${btn_confirm}

Login BackOffice And Go To The Page Of Merchant Edit MySQL
    [Arguments]    ${page_name}
    Generate Gateway Header With Scope and Permission    ${ROLE_USER}    ${ROLE_USER_PASSWORD}    scope=merchantTx.create
    ...    permission_name=merchant.entityAudit.actAsAdmin,merchant.merchant.actAsAdmin,merchant.outlet.actAsAdmin
    Open Browser With Option    ${ADMIN_TOOLS_URL}    headless_mode=${False}
    Login Backoffice    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
    Run Keyword    Go To ${page_name} Page Of Merchant Edit MySQL