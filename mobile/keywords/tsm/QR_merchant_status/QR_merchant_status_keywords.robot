*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/QR_merchant_status/QR_merchant_status_locators.robot

*** Keywords ***
QR Merchant Status Page Should Be Opened
    Wait Until Page Contains    &{QR_merchant_status_text}[qr_code_title]

Tap On Merchant Dashboard Bar
    Wait Until Element Is Visible    &{QR_merchant_status}[menu_total_sale_today_section]
    Click Element     &{QR_merchant_status}[menu_total_sale_today_section]

Display Advice Menu Correctly
    Swipe Up
    Swipe Up
    Page Should Contain Text    &{QR_merchant_status}[menu_advice]

Tap On Advice Menu
    Swipe Up
    Swipe Up
    Click Text    &{QR_merchant_status}[menu_advice]