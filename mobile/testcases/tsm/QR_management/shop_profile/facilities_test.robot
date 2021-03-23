*** Settings ***
Documentation       Verify user can access to shop profile and update facilities information.
Resource            ../../../../../api/resources/init.robot
Resource            ../../../../../api/keywords/cms/content_resource_keywords.robot
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/my_shop_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/facilities_keywords.robot
Test Setup          Run Keywords    Prepare Shop Content Data   AND    Open Apps   TSM
Test Teardown       Run Keywords    Delete Content      ${WESHOP_PROJECT_ID}      ${shop_alias}     ${content_id}    AND     Delete All Sessions     AND     Close Application

*** Variables ***
${thai_id}    1509901018351
${merchant_name}    ทดสอบ_ยอดขายรวม
${tsm_merchant_id}      0024934
${shop_alias}        shop

*** Keywords ***
Prepare Shop Content Data
    Generate Gateway Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
    Post Create Content     ${WESHOP_PROJECT_ID}      ${shop_alias}     {"data":{"shopNameEn":"Test Total Sale","geo_location":{"longitude":"100.2320531","latitude":"16.7940214","type":"POINT_LOCATION"},"address":"ชั้นGกาดหลวงเซ็นทรัลเชียงราย","tsmMerchantId":"${tsm_merchant_id}","onlineStatus":"true","subCategoryId":"","subCategoryDescription":"","shopMobile":"66-802371084","categoryDescription":"อาหารและเครื่องดื่ม","shopTel":"66-802371084","province":"กรุงเทพมหานคร","logoImage":null,"brandId":"5d6f35193c1239000170b502","district":"สวนหลวง","shopHighlight":"","postCode":"10260","tsmOutletId":"00001","subDistrict":"ในเมือง","shopNameTh":"${merchant_name}","categoryId":"5948d60ee1382323583e31c7","publishStatus":"true"}}
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
TC_O2O_12169
    [Documentation]    Verify menu facilities on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Capture Page Screenshot    filename=TC_O2O_12169.png

TC_O2O_12170
    [Documentation]    Verify default facilities screen on Shop Profile - In case don't select facilities
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Show Save Button Component Correctly    &{facilities}[btn_save]
    Capture Page Screenshot    filename=TC_O2O_12170.png

TC_O2O_12172
    [Documentation]    Verify user can select and save facilities all button on Shop Profile - In case select all facilities
    [Tags]    Regression    High    Smoke   Sanity   E2E
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Select On Facilities "ที่จอดรถ"
    Select On Facilities "Free WiFi"
    Select On Facilities "ห้องส่วนตัว"
    Select On Facilities "บริการส่งสินค้า"
    Select On Facilities "จองล่วงหน้า"
    Select On Facilities "รับบัตรเครดิต"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       PARKING,FREE_WIFI,PRIVATE_ROOM,DELIVERY_SERVICE,RESERVATION,ACCEPT_CREDIT_CARD
    Capture Page Screenshot    filename=TC_O2O_12172.png

TC_O2O_12173
    [Documentation]    Verify user can select button "ที่จอดรถ" and save facilities button on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Select On Facilities "ที่จอดรถ"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       PARKING
    Capture Page Screenshot    filename=TC_O2O_12173.png

TC_O2O_12174
    [Documentation]    Verify user can select button "Free WiFi" and save facilities button on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Select On Facilities "Free WiFi"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       FREE_WIFI
    Capture Page Screenshot    filename=TC_O2O_12174.png

TC_O2O_12175
    [Documentation]    Verify user can select button "ห้องส่วนตัว" and save facilities button on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Select On Facilities "ห้องส่วนตัว"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       PRIVATE_ROOM
    Capture Page Screenshot    filename=TC_O2O_12175.png

TC_O2O_12176
    [Documentation]    Verify user can select button "บริการส่งสินค้า" and save facilities button on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Select On Facilities "บริการส่งสินค้า"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       DELIVERY_SERVICE
    Capture Page Screenshot    filename=TC_O2O_12176.png

TC_O2O_12177
    [Documentation]    Verify user can select button "จองล่วงหน้า" and save facilities button on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Select On Facilities "จองล่วงหน้า"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       RESERVATION
    Capture Page Screenshot    filename=TC_O2O_12177.png

TC_O2O_12178
    [Documentation]    Verify user can select button "รับบัตรเครดิต" and save facilities button on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Select On Facilities "รับบัตรเครดิต"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       ACCEPT_CREDIT_CARD
    Capture Page Screenshot    filename=TC_O2O_12178.png

TC_O2O_12179
    [Documentation]    Verify user can select and save facilities button on Shop Profile - In case select mare than 1 facilities (ที่จอดรถ/Free WiFi/จองล่วงหน้า/รับบัตรเครดิต)
    [Tags]    Regression    High    Smoke    Sanity     E2E
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Select On Facilities "ที่จอดรถ"
    Select On Facilities "Free WiFi"
    Select On Facilities "จองล่วงหน้า"
    Select On Facilities "รับบัตรเครดิต"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       PARKING,FREE_WIFI,RESERVATION,ACCEPT_CREDIT_CARD
    Capture Page Screenshot    filename=TC_O2O_12179.png

TC_O2O_12180
    [Documentation]    Verify user can unselect and save facilities button on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Facilities Component Correctly
    Tap On Facilities Menu
    Facilities Page Should Be Opened
    Show Facilities Elements Correctly
    Select On Facilities "ที่จอดรถ"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       PARKING
    Select On Facilities "ที่จอดรถ"
    Tap On Save Information     &{facilities}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.facilities       ${EMPTY}
    Capture Page Screenshot    filename=TC_O2O_12180.png
