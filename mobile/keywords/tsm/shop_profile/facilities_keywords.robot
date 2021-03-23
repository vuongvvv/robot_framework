*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/shop_profile/facilities_locators.robot

*** Keywords ***
Facilities Page Should Be Opened
    Wait Until Page Contains        &{facilities_text}[lbl_title]

Show Facilities Elements Correctly
    Element Text Should Be      &{facilities}[btn_parking]       &{facilities_text}[lbl_parking]
    Element Text Should Be      &{facilities}[btn_free_wifi]       &{facilities_text}[lbl_free_wifi]
    Element Text Should Be      &{facilities}[btn_private_room]       &{facilities_text}[lbl_private_room]
    Element Text Should Be      &{facilities}[btn_delivery_service]       &{facilities_text}[lbl_delivery_service]
    Element Text Should Be      &{facilities}[btn_reservation]       &{facilities_text}[lbl_reservation]
    Element Text Should Be      &{facilities}[btn_credit_card]       &{facilities_text}[lbl_credit_card]

Select On Facilities "ที่จอดรถ"
    Click Element       &{facilities}[btn_parking]

Select On Facilities "Free WiFi"
    Click Element       &{facilities}[btn_free_wifi]

Select On Facilities "ห้องส่วนตัว"
    Click Element       &{facilities}[btn_private_room]

Select On Facilities "บริการส่งสินค้า"
    Click Element       &{facilities}[btn_delivery_service]

Select On Facilities "จองล่วงหน้า"
    Click Element       &{facilities}[btn_reservation]

Select On Facilities "รับบัตรเครดิต"
    Click Element       &{facilities}[btn_credit_card]