*** Settings ***
Documentation    Test to verify user can create terminal successfully
Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/merchant/brand_resource_keywords.robot
Resource    ../../../api/keywords/merchant/shop_resource_keywords.robot
Resource    ../../../api/keywords/merchant/terminal_resource_keywords.robot

Test Setup    Generate Gateway Header With Scope and Permission    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}     brand.write,shop.write,terminal.write
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${brand_name_th}    ทดสอบ แบรนด์กรู๊ท @ทรูดิจิตอล 101
${brand_name_en}    Test brand Groot @Truedigital 101
${shop_name_th}    ทดสอบ ช้อปกรู๊ท @ทรูดิจิตอล 101
${shop_name_en}    Test Shop Groot @Truedigital 101
${terminal_name_th}    ชื่อเทอมินอลทดสอบ @ทรูดิจิตอล 101
${terminal_name_en}    Test create terminal @Truedigital 101
${brand_category}    TRAVEL_AND_TRANSPORTATION
${create_brand_json_body}    { "brandName": { "th" : "${EMPTY} ${brand_name_th}_TIME_STAMP_ ${EMPTY} ", "en" : "${EMPTY} ${brand_name_en} _TIME_STAMP_ ${EMPTY}", "default" : "en"} ,"description": "ร้านทดสอบ ออโตเมท","category":"FOOD_AND_DRINK","subCategory": "ออโตเมท" }
${create_shop_json_body}    { "shopAddresses": {"address": "5555/111","city": "BKK","country": "TH","district":"Bangna","geolocation":"13.6601781,100.6254328","postcode": "10260"},"shopCategories": ["FOOD","SERVICE"],"shopContacts": [{"email":"o2o.qatesting@gmail.com","fullName": "Thomas Anderson","phone": "0800000000"}],"shopDetails": {"description": "test","openHours": {"sun":"08:00-19:00","mon":"","tue":"08:00-19:00","wed":"08:00-19:00","thu":"08:00-19:00","fri":"08:00-19:00","sat":"08:00-19:00"}},"shopName": {"default": "th","en": "${EMPTY} ${shop_name_en}_TIME_STAMP_ ${EMPTY}","th": " ${EMPTY} ${shop_name_th} _TIME_STAMP_ สาขาที่ 1 ${EMPTY}"},"status": "ACTIVE","shopType": ["OFFLINE","ONLINE"]}
${create_terminal_json_body}    {"terminalName": { "th": "${empty} ${terminal_name_th} _TIME_STAMP_ ${empty}", "en": " ${terminal_name_en} _TIME_STAMP_ ${empty}${empty}", "default": "en"}, "terminalType" : "EDC", "description":"ทดสอบ&Test", "status":"ACTIVE"}

*** Test Cases ***
TC_O2O_15665
    [Documentation]    Verify API will trim space before and after terminal Name field and allow to create terminal
    [Tags]    Regression      Smoke    High
    Create Brand With Timestamp    ${create_brand_json_body}
    Response Correct Code    ${CREATED_CODE}
    Extract And Store Brand Mongo Id From Response
    Create Shop With Timestamp For Brand    ${BRAND_MONGO_ID}    ${create_shop_json_body}
    Response Correct Code    ${CREATED_CODE}
    Extract And Store Shop Mongo Id From Response
    Create Terminal With Timestamp For Shop    ${SHOP_MONGO_ID}    ${create_terminal_json_body}
    Response Correct Code    ${CREATED_CODE}
    Extract Terminal Id From Response
    Store First Terminal ID
    Extract Shop Id From Response
    Response Should Contain Property With Value    shopId    ${SHOP_ID}
    Response Should Contain Property With Value     terminalName.th    ${terminal_name_th} ${TIME_STAMP}
    Create Terminal With Timestamp For Shop    ${SHOP_MONGO_ID}    ${create_terminal_json_body}
    Extract Terminal Id From Response
    Verify The Latest Terminal ID Should More Than The First Terminal ID