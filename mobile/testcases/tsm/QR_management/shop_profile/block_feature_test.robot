*** Settings ***
Documentation       Verify user can access to shop profile and control shop online status.
Resource            ../../../../../api/resources/init.robot
Resource            ../../../../../api/keywords/cms/content_resource_keywords.robot
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/my_shop_keywords.robot
Test Setup          Run Keywords    Prepare Shop Content Data    ${unpublish_shop}      AND    Open Apps   TSM
Test Teardown       Run Keywords    Delete Content      ${WESHOP_PROJECT_ID}      ${shop_alias}     ${content_id}    AND     Delete All Sessions     AND     Close Application

*** Variables ***
${thai_id}      1509901018351
${merchant_name}        ทดสอบ_ยอดขายรวม
${tsm_merchant_id}      0024934
${shop_alias}        shop
${unpublish_shop}    false

*** Keywords ***
Prepare Shop Content Data
    [Arguments]     ${publish_status}
    Generate Gateway Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
    Post Create Content     ${WESHOP_PROJECT_ID}      ${shop_alias}     {"data":{"shopNameEn":"Test Total Sale","geo_location":{"longitude":"100.2320531","latitude":"16.7940214","type":"POINT_LOCATION"},"address":"ชั้นGกาดหลวงเซ็นทรัลเชียงราย","tsmMerchantId":"${tsm_merchant_id}","onlineStatus":"true","subCategoryId":"","subCategoryDescription":"","shopMobile":"66-802371084","categoryDescription":"อาหารและเครื่องดื่ม","shopTel":"66-802371084","province":"กรุงเทพมหานคร","logoImage":null,"brandId":"5d6f35193c1239000170b502","district":"สวนหลวง","shopHighlight":"","postCode":"10260","tsmOutletId":"00001","subDistrict":"ในเมือง","shopNameTh":"${merchant_name}","categoryId":"5948d60ee1382323583e31c7","publishStatus":"${publish_status}"}}
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
TC_O2O_10572
    [Documentation]    Verify user can see pop up correctly when merchant publishStatus = false by clicking on shop profile
    [Tags]    Regression    High
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Shop Profile Section
    Show Dialog Unpublish Shop Correctly
    Capture Page Screenshot    filename=TC_O2O_10572.png
    Click To Go Back To Main EDC Screen

TC_O2O_10573
    [Documentation]    Verify user can see pop up correctly when merchant is not existing on CMS system by clicking on shop profile
    [Tags]    Regression    High
    [Setup]     NONE
    Open Apps   TSM
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Shop Profile Section
    Show Dialog Unpublish Shop Correctly
    Capture Page Screenshot    filename=TC_O2O_10573.png
    Click To Go Back To Main EDC Screen
    [Teardown]     Close Application

TC_O2O_10574
    [Documentation]    Verify user can see pop up correctly when merchant publishStatus = false by clicking on sell online
    [Tags]    Regression    High
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Show Dialog Unpublish Shop Correctly
    Click To Go Back To Main EDC Screen
    Capture Page Screenshot    filename=TC_O2O_10574.png

TC_O2O_10575
    [Documentation]    Verify user can see pop up correctly when merchant is not existing on CMS system by clicking on on sell online
    [Tags]    Regression    High
    [Setup]     NONE
    Open Apps   TSM
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Show Dialog Unpublish Shop Correctly
    Click To Go Back To Main EDC Screen
    Capture Page Screenshot    filename=TC_O2O_10575.png
    [Teardown]     Close Application
