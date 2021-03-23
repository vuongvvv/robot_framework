*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/main_edc/main_edc_locators.robot

*** Keywords ***
Receive Notification Popup Should Be Opened
    Wait Until Element Is Visible       &{main_edc}[popup_recieve_notification]

Click To Close Receive Notification Popup
    Click Element      &{main_edc}[btn_close_notification]

Main EDC Screen Should Be Opened
    ${result_status}    Run Keyword And Return Status    Receive Notification Popup Should Be Opened
    Run Keyword If    ${result_status} == ${true}    Click To Close Receive Notification Popup
    Wait Until Page Does Not Contain Element    &{main_edc}[popup_recieve_notification]
    Wait Until Element Is Visible    &{main_edc}[menu_total_sale_today_section]    30s

Tap On Merchant Dashboard
    Wait Until Element Is Visible    &{main_edc}[menu_total_sale_today_section]
    Click Element     &{main_edc}[menu_total_sale_today_section]

Tap On Shop Profile Section
    Run Keyword If    '${OS}' == 'ios'     Click Element      &{main_edc}[lbl_merchant_name]
    ...     ELSE    Click Element      &{main_edc}[shop_profile_section]

Tap On Advice Menu
    Swipe Up To Element    &{main_edc}[btn_advice]
    Click Element      &{main_edc}[btn_advice]

Tap On Sell Online Menu
    Run Keyword If    '${OS}' == 'android'    Run Keywords    Swipe Up To Element    &{main_edc}[btn_shop_profile]    AND    Click Element      &{main_edc}[btn_shop_profile]
    Run Keyword If    '${OS}' == 'ios'    Run Keywords    Swipe Up To Element    &{main_edc}[btn_shop_profile]    AND    Click Element      &{main_edc}[btn_shop_profile]
