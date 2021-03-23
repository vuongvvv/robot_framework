*** Settings ***
Documentation       Verify user can access to shop profile and control shop online status.
Resource            ../../../../../api/resources/init.robot
Resource            ../../../../../api/keywords/cms/content_resource_keywords.robot
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/my_shop_keywords.robot
Test Setup          Run Keywords    Prepare Shop Content Data    ${turn_on_shop}     AND    Open Apps   TSM
Test Teardown       Run Keywords    Delete Content      ${WESHOP_PROJECT_ID}      ${shop_alias}     ${content_id}    AND     Delete All Sessions     AND     Close Application

*** Variables ***
${thai_id}      1509901018351
${merchant_name}        ทดสอบ_ยอดขายรวม
${tsm_merchant_id}      0024934
${shop_alias}        shop
${turn_on_shop}     true
${turn_off_shop}    false

*** Keywords ***
Prepare Shop Content Data
    [Arguments]     ${shop_status}
    Generate Gateway Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
    Post Create Content     ${WESHOP_PROJECT_ID}      ${shop_alias}     {"data":{"shopNameEn":"Test Total Sale","geo_location":{"longitude":"100.2320531","latitude":"16.7940214","type":"POINT_LOCATION"},"address":"ชั้นGกาดหลวงเซ็นทรัลเชียงราย","tsmMerchantId":"${tsm_merchant_id}","onlineStatus":"${shop_status}","subCategoryId":"","subCategoryDescription":"","shopMobile":"66-802371084","categoryDescription":"อาหารและเครื่องดื่ม","shopTel":"66-802371084","province":"กรุงเทพมหานคร","logoImage":null,"brandId":"5d6f35193c1239000170b502","district":"สวนหลวง","shopHighlight":"","postCode":"10260","tsmOutletId":"00001","subDistrict":"ในเมือง","shopNameTh":"${merchant_name}","categoryId":"5948d60ee1382323583e31c7","publishStatus":"true"}}
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
TC_O2O_10554
    [Documentation]    Verify user can see shop status turn on by default correctly when onlineStatus = true
    [Tags]    Regression    High    Smoke    Sanity     E2E
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Online Shop Status Turn On Correctly
    Capture Page Screenshot    filename=TC_O2O_10554.png

TC_O2O_10555
    [Documentation]    Verify user can turn off shop status then merchant disappear from WeShop correctly
    [Tags]    Regression    High    Smoke    Sanity     E2E
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Online Shop Status Turn On Correctly
    Tap Switch Online Shop Status
    Show Online Shop Status Turn Off Correctly
    Capture Page Screenshot    filename=TC_O2O_10555.png

TC_O2O_10556
    [Documentation]    Verify user can turn on shop status then merchant online to WeShop correctly
    [Tags]    Regression    High    Smoke    Sanity     E2E
    [Setup]     NONE
    Prepare Shop Content Data    ${turn_off_shop}
    Open Apps   TSM
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    SHow Online Shop Status Turn Off Correctly
    Tap Switch Online Shop Status
    Show Online Shop Status Turn On Correctly
    Capture Page Screenshot    filename=TC_O2O_10556.png