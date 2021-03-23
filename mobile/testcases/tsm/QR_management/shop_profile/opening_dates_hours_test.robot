*** Settings ***
Documentation       Verify user can access to shop profile and update open date & time.
Resource            ../../../../../api/resources/init.robot
Resource            ../../../../../api/keywords/cms/content_resource_keywords.robot
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/my_shop_keywords.robot
Test Setup          Run Keywords    Prepare Shop Content Data   ${open_date}    ${open_time}    ${close_time}    AND    Open Apps   TSM
Test Teardown       Run Keywords    Delete Content      ${WESHOP_PROJECT_ID}      ${shop_alias}     ${content_id}    AND     Delete All Sessions     AND     Close Application

*** Variables ***
${thai_id}    1509901018351
${merchant_name}    ทดสอบ_ยอดขายรวม
${tsm_merchant_id}      0024934
${shop_alias}        shop
${open_date}    Mon,Tue,Wed,Thu,Fri
${open_time}    08:00
${close_time}    20:00

*** Keywords ***
Prepare Shop Content Data
    [Arguments]     ${open_date}    ${open_time}    ${close_time}
    Generate Gateway Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
    Post Create Content     ${WESHOP_PROJECT_ID}      ${shop_alias}     {"data":{"shopNameEn":"Test Total Sale","geo_location":{"longitude":"100.2320531","latitude":"16.7940214","type":"POINT_LOCATION"},"address":"ชั้นGกาดหลวงเซ็นทรัลเชียงราย","tsmMerchantId":"${tsm_merchant_id}","onlineStatus":"true","subCategoryId":"","subCategoryDescription":"","shopMobile":"66-802371084","categoryDescription":"อาหารและเครื่องดื่ม","shopTel":"66-802371084","province":"กรุงเทพมหานคร","logoImage":null,"brandId":"5d6f35193c1239000170b502","district":"สวนหลวง","shopHighlight":"","postCode":"10260","tsmOutletId":"00001","subDistrict":"ในเมือง","shopNameTh":"${merchant_name}","categoryId":"5948d60ee1382323583e31c7","publishStatus":"true","OpenDate":"${open_date}","OpenTime":"${open_time}","CloseTime":"${close_time}"}}
    Get ID Of A Content From List Of Contents

Precondition QR Merchant Go To Main EDC Screen
    Tutorial Page Should Be Opened
    Tap On Check Merchant Status Menu
    Check Merchant Status Page Should Be Opened
    Input Thai ID       ${thai_id}
    Submit Check Merchant Status
    Select On Any Merchants     ${merchant_name}
    Input OTP Number    ${OTP_NUMBER}
    Submit OTP Number
    Main EDC Screen Should Be Opened

*** Test Cases ***
TC_O2O_10594
    [Documentation]    Verify default field "Open date & time"
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Open Shop Date Time Correctly
    Capture Page Screenshot    filename=TC_O2O_10594.png

TC_O2O_10597
    [Documentation]    Verify user can edit open date & time and save informaion - Select 1 day : Mon
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Tap On Date As  &{my_shop}[btn_date_mon]
    Tap On Save Information     &{my_shop}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.openDate       Mon
    Capture Page Screenshot    filename=TC_O2O_10597.png

TC_O2O_10598
    [Documentation]    Verify user can edit open date & time and save informaion - Select more than 1 day : Mon, Tue, Wed, Thu, Fri
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Tap On Date As  &{my_shop}[btn_date_mon]
    Tap On Date As  &{my_shop}[btn_date_tue]
    Tap On Date As  &{my_shop}[btn_date_wed]
    Tap On Date As  &{my_shop}[btn_date_thu]
    Tap On Date As  &{my_shop}[btn_date_fri]
    Tap On Save Information     &{my_shop}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.openDate       Mon,Tue,Wed,Thu,Fri
    Capture Page Screenshot    filename=TC_O2O_10598.png

TC_O2O_10601
    [Documentation]    Verify user can edit open date & time and save informaion - Select Open day : Mon, Tue, Wed, Thu, Fri - Select Start time : 11:00 - Select End time : 22.00
    [Tags]    Regression    High    Smoke   Sanity    E2E
    [Setup]     NONE
    Prepare Shop Content Data    Sat,Sun    11:00    22:00
    Open Apps   TSM
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Tap On Date As  &{my_shop}[btn_date_mon]
    Tap On Date As  &{my_shop}[btn_date_tue]
    Tap On Date As  &{my_shop}[btn_date_wed]
    Tap On Date As  &{my_shop}[btn_date_thu]
    Tap On Date As  &{my_shop}[btn_date_fri]
    Tap On Save Information     &{my_shop}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.openDate       Sun,Mon,Tue,Wed,Thu,Fri,Sat
    Response Should Contain Property With Value     .data.openTime       11:00
    Response Should Contain Property With Value     .data.closeTime       22:00
    Capture Page Screenshot    filename=TC_O2O_10601.png
