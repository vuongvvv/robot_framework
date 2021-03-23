*** Settings ***
Resource    ../../../../web/resources/locators/audit_web/merchant_details/merchant_details_page_locators.robot
Resource    ../../../../web/keywords/common/locator_common.robot

*** Variables ***
${merchant_img_path}    ${CURDIR}/Merchant.jpg
${outlet_img_path}    ${CURDIR}/Outlet.jpeg
${identity_img_path}    ${CURDIR}/Identity.jpeg

*** Keywords ***
Upload Merchant Images
    Upload Merchant Image    img_owner_file    ${merchant_img_path}
    Upload Merchant Image    img_shop_file    ${outlet_img_path}
    Upload Merchant Image    img_thai_id_file    ${identity_img_path}
    Wait Element Is Visible    ${btn_show_upload_img_success_state}    20s
    Click Visible Element    ${btn_submit_merchant_imgs}

Upload Merchant Image
    [Arguments]    ${image_type}    ${file_path}
    Wait Element Is Visible    ${btn_show_upload_img_success_state}    20s
    ${btn_browse_img_locator}=    Generate Element From Dynamic Locator    ${btn_browse_img}    ${image_type}
    Choose File    ${btn_browse_img_locator}     ${file_path}

Select Merchant Registration Type
    [Arguments]    ${registration_type}
    Select from list by label    ${ddl_registration_type}    ${registration_type}
    Click Button    ${btn_update_registration_type}

Update TMN Status
    [Arguments]    ${status}
    Select From List By Label    ${ddl_true_money_status}    ${status}
    Click Button    ${btn_update_tmn_status}

Verify Merchant Detail Page Should Contain Information
    [Arguments]    ${label_verify}    ${value_verify}
    ${lbl_text_verify_locator} =    Generate Element From Dynamic Locator    ${lbl_text_verify}    ${label_verify}    ${value_verify}
    Verify Element Is Visible    ${lbl_text_verify_locator}    ${True}