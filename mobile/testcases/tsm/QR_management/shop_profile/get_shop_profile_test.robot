*** Settings ***
Documentation       Verify user can access to shop profile and control shop online status.
Resource            ../../../../../api/resources/init.robot
Resource            ../../../../../api/keywords/cms/content_resource_keywords.robot
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/my_shop_keywords.robot
Test Setup          Run Keywords    Prepare Shop Content Data   AND    Open Apps   TSM
Test Teardown       Run Keywords    Delete Content      ${WESHOP_PROJECT_ID}      ${shop_alias}     ${content_id}    AND     Delete All Sessions     AND     Close Application

*** Variables ***
${thai_id}      1509901018351
${merchant_name}        ทดสอบ_ยอดขายรวม
${tsm_merchant_id}      0024934
${shop_alias}        shop
${address}      ชั้นGกาดหลวงเซ็นทรัลเชียงราย
${province}     กรุงเทพมหานคร
${district}     สวนหลวง
${post_code}    10260
${sub_district}     ในเมือง
${category_description}     อาหารและเครื่องดื่ม
${shop_location}        ${address} ${sub_district} ${district} ${province} ${post_code}

*** Keywords ***
Prepare Shop Content Data
    Generate Gateway Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
    Post Create Content     ${WESHOP_PROJECT_ID}      ${shop_alias}     {"data":{"shopNameEn":"Test Total Sale","geo_location":{"longitude":"100.2320531","latitude":"16.7940214","type":"POINT_LOCATION"},"address":"${address}","tsmMerchantId":"${tsm_merchant_id}","onlineStatus":"true","subCategoryId":"","subCategoryDescription":"","shopMobile":"66-802371084","categoryDescription":"${category_description}","shopTel":"66-802371084","province":"${province}","logoImage":null,"brandId":"5d6f35193c1239000170b502","district":"${district}","shopHighlight":"","postCode":"${post_code}","tsmOutletId":"00001","subDistrict":"${sub_district}","shopNameTh":"${merchant_name}","categoryId":"5948d60ee1382323583e31c7","publishStatus":"true"}}
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
TC_O2O_10542
    [Documentation]    Verify user can see what information of my shop will be presented in WeShop or online channel correctly
    [Tags]    Regression    High    Smoke    Sanity     E2E
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Shop Name Correctly        &{my_shop}[txt_merchant_name]      ${merchant_name}
    Show Shop Address Correctly     &{my_shop}[lbl_merchant_address]       ${shop_location}
    Show Shop Category Correctly    &{my_shop}[lbl_merchant_category]      ประเภทธุรกิจ : ${category_description}
    Show Shop Status Component Correctly
    Show Message From Shop Owner Component Correctly
    Capture Page Screenshot    filename=TC_O2O_10542_1.png
    Show Open Shop Date Time Correctly
    Show Transportation Component Correctly
    Show Facilities Component Correctly
    Show Save Button Component Correctly    &{my_shop}[btn_save]
    Capture Page Screenshot    filename=TC_O2O_10542_2.png


