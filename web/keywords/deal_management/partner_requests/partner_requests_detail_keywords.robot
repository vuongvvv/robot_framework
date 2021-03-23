*** Settings ***
Resource    ../../../resources/locators/deal_management/partner_requests/partner_requests_detail_locator.robot

*** Keywords ***
Accept Popups
    Handle Alert    ACCEPT
    Handle Alert    ACCEPT

Get First Partner Id On Merchant Table
    ${TEST_DATA_PARTNER_ID}    Get Element Text    ${cel_first_cell_of_merchant_table}
    Set Test Variable    ${TEST_DATA_PARTNER_ID}

Verify Partner Requests Detail Information
    [Arguments]    ${ref_id}=${None}    ${mid}=${None}
    Run Keyword If    '${ref_id}'!='${None}'    Verify Store Information By Label    Ref ID:    ${ref_id}
    Run Keyword If    '${mid}'!='${None}'    Verify Store Information By Label    MID:    ${mid}
    
Verify Store Information By Label
    [Arguments]    ${label}    ${expected_value}
    ${element}    Generate Element From Dynamic Locator    ${lbl_store_information_by_label}    ${label}
    Verify Element Text    ${element}    ${expected_value}
    
Verify Shop Address
    [Arguments]    ${road}=${None}
    Run Keyword If    '${road}'!='${None}'    Verify Element Property Value    ${txt_shop_address_road}    value    ${road}
    
Verify CHRM Information
    [Arguments]    ${shop_picture_id}    ${menu_picture_id}    ${logo_picture_id}    ${shop_owner_picture_shop_id}
    ${element_shop_picture}    Generate Element From Dynamic Locator    ${lnk_chrm_information_pictures}    ${shop_picture_id}
    Verify Element Is Visible    ${element_shop_picture}
    Verify CHRM Image Review    ${element_shop_picture}
    ${element_menu_picture}    Generate Element From Dynamic Locator    ${lnk_chrm_information_pictures}    ${menu_picture_id}
    Verify Element Is Visible    ${element_menu_picture}
    Verify CHRM Image Review    ${element_menu_picture}
    ${element_logo_picture}    Generate Element From Dynamic Locator    ${lnk_chrm_information_pictures}    ${logo_picture_id}
    Verify Element Is Visible    ${element_logo_picture}
    Verify CHRM Image Review    ${element_logo_picture}
    ${element_shop_owner_picture}    Generate Element From Dynamic Locator    ${lnk_chrm_information_pictures}    ${shop_owner_picture_shop_id}
    Verify Element Is Visible    ${element_shop_owner_picture}
    Verify CHRM Image Review    ${element_shop_owner_picture}
    
Verify CHRM Image Review
    [Arguments]    ${image_element}
    Click Visible Element    ${image_element}
    Switch To New Window    NEW
    Verify Element Is Visible    ${img_chrm_information_image_review}
    Close Window
    Switch To New Window    MAIN
    
Update Merchant Status And Input Reason
    [Arguments]    ${action}    ${select_reason}    ${txt_reason}
    Click Visible Element    ${btn_${action}}
    Select Dropwdown List By Value    ${ddl_${action}_reason}    ${select_reason}
    Input Text Into Visible Element    ${${action}_reason_details}    ${txt_reason}
    Click Visible Element    ${btn_${action}_ok}

Validate Merchant Status
    [Arguments]    ${merchant_data}    ${status}
    Wait Until Page Contains    ${merchant_data}    timeout=10s
    ${ty_status}=    Get Text    ${row_first_cell_ty_status_of_merchant_table}
    run keyword and continue on failure  Should be equal as strings    ${ty_status}    ${status}
