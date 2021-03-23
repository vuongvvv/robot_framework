*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/shop_profile/transportation_locators.robot

*** Keywords ***
Transportation Page Should Be Opened
    Wait Until Page Contains        &{transportation_text}[lbl_title]