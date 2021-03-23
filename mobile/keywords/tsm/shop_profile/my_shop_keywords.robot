*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/shop_profile/my_shop_locators.robot

*** Keywords ***
Tab Back Button
    Run Keyword If    '${OS}' == 'android'    Go Back    ELSE    Click Element    &{my_shop}[btn_back]

Click To Close Popup
    Wait Until Element Is Visible      &{my_shop}[btx_close_popup_fyi]
    Click Element      &{my_shop}[btx_close_popup_fyi]

Ignore FYI WeShop Popup
    ${result_status}    Run Keyword And Return Status    Wait Until Page Contains Element    &{my_shop}[popup_fyi_weshop]
    Run Keyword If    ${result_status} == ${true}    Click To Close Popup
    Wait Until Page Does Not Contain Element    &{my_shop}[popup_fyi_weshop]

Shop Profile Page Should Be Opened
    Wait Until Page Contains        &{my_shop_text}[lbl_title]
    Wait Until Page Contains Element    &{my_shop}[btn_myshop]
    Wait Until Page Contains Element    &{my_shop}[btn_open_sale_online]
    Ignore FYI WeShop Popup

Show Shop Name Correctly
    [Arguments]     ${txt_merchant_name}    ${expected_value}
    ${actual_value}=    Get Text    ${txt_merchant_name}
    ${actual_value}=    Strip String    ${SPACE}${actual_value}${SPACE}     mode=both
    Should Be Equal    ${actual_value}    ${expected_value}

Show Shop Address Correctly
    [Arguments]     ${txt_merchant_address}    ${expected_value}
    ${actual_value}    Get Text    ${txt_merchant_address}
    ${actual_value}=    Strip String    ${SPACE}${actual_value}${SPACE}     mode=both
    Should Be Equal    ${actual_value}    ${expected_value}

Show Shop Category Correctly
    [Arguments]     ${txt_merchant_category}     ${expected_value}
    ${actual_value}    Get Text    ${txt_merchant_category}
    ${actual_value}=    Strip String    ${SPACE}${actual_value}${SPACE}     mode=both
    Should Be Equal    ${actual_value}    ${expected_value}

Show Open WeShop Button Correctly
    Run Keyword If      '${OS}' == 'ios'    Run Keyword And Ignore Error        Wait Until Page Contains    &{my_shop_text}[lbl_shop_online_on_we_shop]
    ...     ELSE     Wait Until Page Contains    &{my_shop_text}[lbl_shop_online_on_we_shop]

Tap On Open WeShop Button
    Click Element       &{my_shop}[btn_open_weshop]

Show Shop Status Component Correctly
    Element Text Should Be      &{my_shop}[lbl_open_shop_online]       &{my_shop_text}[lbl_open_shop_online]
    Element Text Should Be      &{my_shop}[lbl_website_link]       &{my_shop_text}[lbl_website_link]

Show Dialog Unpublish Shop Correctly
    Ignore FYI WeShop Popup
    Wait Until Page Contains     &{my_shop_text}[lbl_dialog_1]
    Wait Until Page Contains     &{my_shop_text}[lbl_dialog_2]
    ${btn_value}    Get Text    &{my_shop}[btn_back_home]
    Should Be Equal    ${btn_value}    &{my_shop_text}[btn_back_home]

Click To Go Back To Main EDC Screen
    Click Element       &{my_shop}[btn_back_home]

Show Message From Shop Owner Component Correctly
    Element Text Should Be      &{my_shop}[lbl_message_from_shop_owner]       &{my_shop_text}[lbl_message_from_shop_owner]

Show Open Shop Date Time Correctly
    Swipe Up
    Element Text Should Be      &{my_shop}[lbl_open_date]       &{my_shop_text}[lbl_open_date]
    Element Text Should Be      &{my_shop}[btn_date_sun]       &{my_shop_text}[btn_date_sun]
    Element Text Should Be      &{my_shop}[btn_date_mon]       &{my_shop_text}[btn_date_mon]
    Element Text Should Be      &{my_shop}[btn_date_tue]       &{my_shop_text}[btn_date_tue]
    Element Text Should Be      &{my_shop}[btn_date_wed]       &{my_shop_text}[btn_date_wed]
    Element Text Should Be      &{my_shop}[btn_date_thu]       &{my_shop_text}[btn_date_thu]
    Element Text Should Be      &{my_shop}[btn_date_fri]       &{my_shop_text}[btn_date_fri]
    Element Text Should Be      &{my_shop}[btn_date_sat]       &{my_shop_text}[btn_date_sat]
    Element Text Should Be      &{my_shop}[lbl_open_time]       &{my_shop_text}[lbl_open_time]
    Element Text Should Be      &{my_shop}[lbl_start_time]       &{my_shop_text}[lbl_start_time]
    Element Text Should Be      &{my_shop}[lbl_end_time]       &{my_shop_text}[lbl_end_time]
    Element Text Should Be      &{my_shop}[btn_save]       &{my_shop_text}[btn_save]

Tap On Date As
    [Arguments]     ${btn_date}
    Click Element       ${btn_date}

Show Transportation Component Correctly
    Element Text Should Be      &{my_shop}[lbl_transprotation]       &{my_shop_text}[lbl_transprotation]

Show Facilities Component Correctly
    Element Text Should Be      &{my_shop}[lbl_facilities]       &{my_shop_text}[lbl_facilities]

Show Save Button Component Correctly
    [Arguments]     ${btn_save}
    Element Text Should Be      ${btn_save}       &{my_shop_text}[btn_save]

Tap On Transportation Menu
    Click Element       &{my_shop}[btn_transprotation]

Tap On Facilities Menu
    Click Element       &{my_shop}[btn_facilities]

Tap Switch Online Shop Status
    Click Element       &{my_shop}[switch_status_shop_online]

Show Online Shop Status Turn On Correctly
    Run Keyword If      '${OS}' == 'ios'    Run Keyword And Ignore Error        Wait Until Page Contains    &{my_shop_text}[online_status_on]
    ...     ELSE     Wait Until Page Contains    &{my_shop_text}[online_status_on]

Show Online Shop Status Turn Off Correctly
    Run Keyword If      '${OS}' == 'ios'    Run Keyword And Ignore Error        Wait Until Page Contains    &{my_shop_text}[online_status_off]
    ...     ELSE     Wait Until Page Contains    &{my_shop_text}[online_status_off]

Tap On Save Information
    [Arguments]     ${btn_save}
    Click Element      ${btn_save}

Input Shop Message
    [Arguments]     ${txt_message}      ${message}
    Input Text    ${txt_message}    ${message}

Show Shop Message Correctly As
    [Arguments]     ${txt_message}      ${expected_message}
    ${actual_message}    Get Element Attribute    ${txt_message}     ${attribute}
    Should Be Equal    ${expected_message}    ${actual_message}

Show Open Shop Time Correctly As
    [Arguments]     ${field}    ${expected_time}
    ${verify_field}    Convert To Uppercase    ${field}
    ${verify_field}    Run Keyword If    '${verify_field}' == 'OPEN'    Set Variable    txt_open_time    ELSE IF    '${verify_field}' == 'CLOSE'    Set Variable    txt_close_time    ELSE    Fail    msg=Field is invalid !!
    ${actual_time}    Get Element Attribute    &{my_shop}[${verify_field}]    value
    Should Be Equal As Strings    ${expected_time}    ${actual_time}

Show Passer By Visitors Main Saction Correctly
    Wait Until Page Contains Element     &{my_shop}[lbl_section_title_passer_by_visitors]
    Wait Until Page Contains Element     &{my_shop}[lbl_number_passer_by_visitors]
    Wait Until Page Contains Element     &{my_shop}[lbl_seen_your_shop]
    Wait Until Page Contains Element     &{my_shop}[lbl_number_visit_shop]
    Wait Until Page Contains Element     &{my_shop}[lbl_visit_your_shop]
    Wait Until Page Contains Element    &{my_shop}[btn_expand]

Show Passer By Visitors Expand Saction Correctly
    Wait Until Page Contains Element     &{my_shop}[lbl_section_title_total_of_week]
    Wait Until Page Contains Element     &{my_shop}[lbl_number_passer_by_visitors_total_week]
    Wait Until Page Contains Element     &{my_shop}[lbl_seen_your_shop_total_week]
    Wait Until Page Contains Element     &{my_shop}[lbl_number_visit_your_shop_total_week]
    Wait Until Page Contains Element     &{my_shop}[lbl_visit_your_shop_total_week]
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element   &{my_shop}[btn_unexpand]
    Run Keyword If    ${status} == ${False}    Run Keywords    Swipe Up To Element    &{my_shop}[btn_unexpand]    AND    Wait Until Page Contains Element    &{my_shop}[btn_unexpand]

Tab To Expand Passer By Visitors
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    &{my_shop}[btn_expand]
    Run Keyword If    ${status} == ${False}    Swipe Up To Element    &{my_shop}[btn_expand]
    Click Element    &{my_shop}[btn_expand]
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    &{my_shop}[lbl_section_title_passer_by_visitors]
    Run Keyword If    ${status} == ${False}    Swipe Down To Element    &{my_shop}[lbl_section_title_passer_by_visitors]

Tab To Unxpand Passer By Visitors
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    &{my_shop}[btn_unexpand]
    Run Keyword If    ${status} == ${False}    Swipe Up To Element    &{my_shop}[btn_unexpand]
    Click Element    &{my_shop}[btn_unexpand]
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    &{my_shop}[lbl_section_title_passer_by_visitors]
    Run Keyword If    ${status} == ${False}    Swipe Down To Element    &{my_shop}[lbl_section_title_passer_by_visitors]
