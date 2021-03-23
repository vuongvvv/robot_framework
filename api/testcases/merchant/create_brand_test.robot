*** Settings ***
Documentation    Test to verify user can create brand successfully
Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/merchant/brand_resource_keywords.robot
Resource    ../../../api/keywords/merchant/common_merchant_keywords.robot

# scope: brand.write
Test Setup   Generate Robot Automation Header    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
${brand_name_th}    ทดสอบ แบรนด์กรู๊ท @ทรูดิจิตอล 101
${brand_name_en}    Test brand Groot @Truedigital 101
${create_brand_json_body}    { "brandName": { "th" : "${EMPTY} ${brand_name_th}_TIME_STAMP_ ${EMPTY} ", "en" : "${EMPTY} ${brand_name_en} _TIME_STAMP_ ${EMPTY}", "default" : "en"} ,"description": "ร้านทดสอบ ออโตเมท","category":"FOOD_AND_DRINK","subCategory": "ออโตเมท" }

*** Test Cases ***
########## POST Create Brand ##########
TC_O2O_14985
    [Documentation]    Verify create Brand data at O2O Merchant
    [Tags]    Regression    Groot    Smoke
    Create Brand With Timestamp    ${create_brand_json_body}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Number String    brandId
    Response Should Contain Property With Value    brandName.th    ${brand_name_th}${TIME_STAMP}
    Extract Brand Id From Response
    Store First Brand ID
    Create Brand With Timestamp    ${create_brand_json_body}
    Extract And Store Brand Mongo Id From Response
    Response Correct Code    ${CREATED_CODE}
    Extract Brand Id From Response
    Verify The Latest Brand ID Should More Than The First Brand ID

########## GET BRAND ##########
TC_O2O_18368
    [Documentation]    Ensure user cannot GET brand if client has scope but user is not an owner
    [Tags]    Regression    Groot
    Generate Gateway Header With Scope and Permission    ${MERCHANT_V2_USERNAME}    ${MERCHANT_V2_PASSWORD}    merchantv2.brand.read
    Get Brand By ID    ${BRAND_MONGO_ID}
    Response Correct Code    ${FORBIDDEN_CODE}

TC_O2O_18370
    [Documentation]    Ensure user cannot GET brand if client no has scope and user is admin but no has permission
    [Tags]    Regression    Groot
    Generate Gateway Header With Scope and Permission    ${MERCHANT_V2_USERNAME}    ${MERCHANT_V2_PASSWORD}
    Get Brand By ID    ${BRAND_MONGO_ID}
    Response Correct Code    ${FORBIDDEN_CODE}

TC_O2O_18372
    [Documentation]    Ensure API will retrun all brand information match with search ID
    [Tags]    Regression    Groot
    Generate Gateway Header With Scope and Permission    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}    merchantv2.brand.read
    Get Brand By ID    ${BRAND_MONGO_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brandId    ${BRAND_ID}
    Response Should Contain All Property Values Contain    brandName.th    ${brand_name_th}
