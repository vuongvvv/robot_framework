*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/QR_merchant_status/check_merchant_status_locators.robot

*** Keywords ***
Check Merchant Status Page Should Be Opened
    Run Keyword If      '${OS}' == 'android'    Accept Alert Popup
    Run Keyword If      '${OS}' == 'android'    Accept Alert Popup
    Wait Until Element Is Visible        &{check_merchant_status}[merchant_search_title]

Input Thai ID
    [Arguments]     ${thai_id}
    Wait Until Page Contains Element    &{check_merchant_status}[txt_thai_id]
    Input Text      &{check_merchant_status}[txt_thai_id]      ${thai_id}
    Hide The Keyboard

Submit Check Merchant Status
     Click On OK Button  &{check_merchant_status}[btn_ok]

Select On Any Merchants
    [Arguments]     ${merchant_name}
    Wait Until Element Is Visible        &{check_merchant_status}[list_merchants]
    Click Element     &{check_merchant_status}[list_merchants]

Input OTP Number
    [Arguments]     ${otp}
    Wait Until Page Contains Element        &{check_merchant_status}[txt_input_otp]
    Input Text      &{check_merchant_status}[txt_input_otp]      ${otp}

Submit OTP Number
    Click On OK Button  &{check_merchant_status}[btn_submit_otp]