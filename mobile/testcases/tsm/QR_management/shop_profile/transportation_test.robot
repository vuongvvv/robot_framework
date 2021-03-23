*** Settings ***
Documentation       Verify user can access to shop profile and update transportation information.
Resource            ../../../../../api/resources/init.robot
Resource            ../../../../../api/keywords/cms/content_resource_keywords.robot
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/my_shop_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/transportation_keywords.robot
Test Setup          Run Keywords    Prepare Shop Content Data     AND    Set Variable Attribute    AND    Open Apps   TSM
Test Teardown       Run Keywords    Delete Content      ${WESHOP_PROJECT_ID}      ${shop_alias}     ${content_id}    AND     Delete All Sessions     AND     Close Application

*** Variables ***
${thai_id}    1509901018351
${merchant_name}    ทดสอบ_ยอดขายรวม
${tsm_merchant_id}      0024934
${shop_alias}        shop
${transportation_suggest}     เดินทางมาทางเส้นทาง 4 แยกวังหิน ฝั่งไปทางโชคชัย 4

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

Set Variable Attribute
    ${attribute_value}    Set Variable If    '${OS}' == 'ios'    value    text
    Set Suite Variable    ${attribute}    ${attribute_value}

*** Test Cases ***
TC_O2O_12401
    [Documentation]    Verify menu Transportation on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Transportation Component Correctly
    Capture Page Screenshot    filename=TC_O2O_12401.png

TC_O2O_12402
    [Documentation]    Verify default Transportation screen on Shop Profile
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Transportation Component Correctly
    Tap On Transportation Menu
    Transportation Page Should Be Opened
    Show Shop Message Correctly As    &{transportation}[txt_transportation_suggest]    &{transportation_text}[lbl_placeholder]
    Show Save Button Component Correctly    &{facilities}[btn_save]
    Capture Page Screenshot    filename=TC_O2O_12402.png

TC_O2O_12404
    [Documentation]    Verify user can edit information and save in Transportation screen on Shop Profile
    [Tags]    Regression    High    Smoke   Sanity  E2E
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Swipe Up
    Show Transportation Component Correctly
    Tap On Transportation Menu
    Transportation Page Should Be Opened
    Show Shop Message Correctly As    &{transportation}[txt_transportation_suggest]    &{transportation_text}[lbl_placeholder]
    Input Shop Message    &{transportation}[txt_transportation_suggest]       ${transportation_suggest}
    Tap On Save Information     &{transportation}[btn_save]
    Get Content    ${WESHOP_PROJECT_ID}     ${shop_alias}     ${content_id}
    Response Should Contain Property With Value     .data.transporation       ${transportation_suggest}
    Capture Page Screenshot    filename=TC_O2O_12404.png
