*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/shop_profile/weshop_web_locators.robot

*** Keywords ***
WeShop Web Should Be Opened
    Wait Until Page Contains    &{weshop_webview_text}[lbl_title]

Show WeShop Merchant Mobile Correctly
    [Arguments]     ${expected_value}
    ${actual_value}    Get Text    &{weshop_webview}[lbl_shop_mobile]
    ${actual_value}=    Strip String    ${SPACE}${actual_value}${SPACE}     mode=both
    Should Be Equal    ${actual_value}    ${expected_value}