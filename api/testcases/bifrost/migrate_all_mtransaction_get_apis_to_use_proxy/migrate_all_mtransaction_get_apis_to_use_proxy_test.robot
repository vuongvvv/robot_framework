*** Settings ***
Documentation    [Tag29 Merchant] Migrate all Mtransaction's GET API to use proxy
...    https://truemoney.atlassian.net/browse/ASCO2O-24113
...    [Tag39 merchant] Migrate all GET API to use proxy
...    https://truemoney.atlassian.net/browse/ASCO2O-24115

Resource    ../../../resources/init.robot
Resource    ../../../keywords/bifrost/routing_resource_keywords.robot
Resource    ../../../keywords/cms/content_resource_keywords.robot
Resource    ../../../resources/testdata/${ENV}/bifrost/bifrost_data.robot

# Scope: merchant-transaction.r
Test Setup    Generate Robot Automation Header    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER_PASSWORD}    gateway=we-platform
Test Teardown    Delete All Sessions

*** Test Cases ***
migration_001_tag29_39
    [Documentation]     https://truemoney.atlassian.net/browse/ASCO2O-24025
    [Tags]    Regression    Smoke     High    bifrost    rpp-merchanttransaction-ms-api    rpp-merchant-bs-api    rpp-merchant    o2o-merchant    ASCO2O-25928
    # merchant tag 29
    Get Merchant    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    tmn_status=WAITING&recomend_channel=SELF_REGISTER
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Merchant Id    data    TEST_DATA_QR29_MERCHANT_ID
    
    Get Merchant Details    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    id=${TEST_DATA_QR29_MERCHANT_ID}&edit=true
    Fetch Property From Response    data.."trueyou".merchant_id    TEST_DATA_MERCHANT_TAG29_TRUEYOU_MERCHANT_ID
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number String    data..store.address.address_id
    Response Should Contain Property With String Value    data..store.address.address
    Response Should Contain Property With Number String    data..store.address.district_id
    Response Should Contain Property With String Value    data..store.address.district_name
    Response Should Contain Property With Number String    data..store.address.post_code
    Response Should Contain Property With Number String    data..store.address.province_id
    Response Should Contain Property With String Value    data..store.address.province_name
    Response Should Contain Property With Number String    data..store.address.subdistrict_id
    Response Should Contain Property With String Value    data..store.address.subdistrict_name
    Response Should Contain Property With Number String    data..merchant_detail.address.address_id
    Response Should Contain Property With String Value    data..merchant_detail.address.address
    Response Should Contain Property With Number String    data..merchant_detail.address.district_id
    Response Should Contain Property With String Value    data..merchant_detail.address.district_name
    Response Should Contain Property With Number String    data..merchant_detail.address.post_code
    Response Should Contain Property With Number String    data..merchant_detail.address.province_id
    Response Should Contain Property With String Value    data..merchant_detail.address.province_name
    Response Should Contain Property With Number String    data..merchant_detail.address.subdistrict_id
    Response Should Contain Property With String Value    data..merchant_detail.address.subdistrict_name
    
    Get Merchant Description    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    id=${TEST_DATA_QR29_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    data..id    ${TEST_DATA_QR29_MERCHANT_ID}
    
    Get Count Merchant    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    tmn_status=WAITING&recomend_channel=SELF_REGISTER
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number String    data
    
    Get Merchant    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    trueyou_merchant_id=${TEST_DATA_MERCHANT_TAG29_TRUEYOU_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    data
    
    # merchant tag 39
    # get truemoney merchant id test data
    Get All Content    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    brand-truemoney    sort=createdDate,desc
    Fetch Property From Response With Exclusion Value    .data.tmnBrandId    TEST_DATA_MERCHANT_TAG39_TRUEMONEY_MERCHANT_ID
    
    # get merchant id on mtransaction by truemoney merchant id test data
    Get Merchant    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    tmn_merchant_id=${TEST_DATA_MERCHANT_TAG39_TRUEMONEY_MERCHANT_ID}
    Fetch Merchant Id    data    TEST_DATA_QR39_MERCHANT_ID
    
    Get Merchant Details    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    id=${TEST_DATA_QR39_MERCHANT_ID}&edit=true
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    data..tmn.merchant_id    ${TEST_DATA_MERCHANT_TAG39_TRUEMONEY_MERCHANT_ID}
    Response Should Contain Property With Number String    data..store.address.address_id
    Response Should Contain Property With String Value    data..store.address.address
    Response Should Contain Property With String Value    data..store.address.district_name
    Response Should Contain Property With Number String    data..store.address.post_code
    Response Should Contain Property With String Value    data..store.address.province_name
    Response Should Contain Property With String Value    data..store.address.subdistrict_name
    Response Should Contain Property With Number String    data..merchant_detail.address.address_id
    Response Should Contain Property With String Value    data..merchant_detail.address.address
    Response Should Contain Property With Number String    data..merchant_detail.address.district_id
    Response Should Contain Property With String Value    data..merchant_detail.address.district_name
    Response Should Contain Property With Number String    data..merchant_detail.address.post_code
    Response Should Contain Property With Number String    data..merchant_detail.address.province_id
    Response Should Contain Property With String Value    data..merchant_detail.address.province_name
    Response Should Contain Property With Number String    data..merchant_detail.address.subdistrict_id
    Response Should Contain Property With String Value    data..merchant_detail.address.subdistrict_name
    
    Get Merchant Description    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    id=${TEST_DATA_QR39_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    
    # get trueyou merchant id test data
    Get All Content    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    brand-trueyou    sort=createdDate,desc
    Fetch Property From Response With Exclusion Value    .data."trueYouBrandId"    TEST_DATA_MERCHANT_TAG39_TRUEYOU_MERCHANT_ID    ${null}
    
    # get merchant id on mtransaction by trueyou merchant id test data
    Get Merchant    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    trueyou_merchant_id=${TEST_DATA_MERCHANT_TAG39_TRUEYOU_MERCHANT_ID}
    Fetch Merchant Id    data    TEST_DATA_QR39_MERCHANT_ID
    Response Correct Code    ${SUCCESS_CODE}
    
    Get Merchant Details    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    id=${TEST_DATA_QR39_MERCHANT_ID}&edit=true
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    data.."trueyou".merchant_id    111${TEST_DATA_MERCHANT_TAG39_TRUEYOU_MERCHANT_ID}00001
    Response Should Contain Property With Value    data..merchant_id    ${TEST_DATA_MERCHANT_TAG39_TRUEYOU_MERCHANT_ID}
    Response Should Contain Property With Number String    data..store.address.address_id
    Response Should Contain Property With String Value    data..store.address.address
    Response Should Contain Property With String Value    data..store.address.district_name
    Response Should Contain Property With Number String    data..store.address.post_code
    Response Should Contain Property With String Value    data..store.address.province_name
    Response Should Contain Property With String Value    data..store.address.subdistrict_name
    Response Should Contain Property With Number String    data..merchant_detail.address.address_id
    Response Should Contain Property With String Value    data..merchant_detail.address.address
    Response Should Contain Property With Number String    data..merchant_detail.address.district_id
    Response Should Contain Property With String Value    data..merchant_detail.address.district_name
    Response Should Contain Property With Number String    data..merchant_detail.address.post_code
    Response Should Contain Property With Number String    data..merchant_detail.address.province_id
    Response Should Contain Property With String Value    data..merchant_detail.address.province_name
    Response Should Contain Property With Number String    data..merchant_detail.address.subdistrict_id
    Response Should Contain Property With String Value    data..merchant_detail.address.subdistrict_name
    
    Get Merchant Description    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    id=${TEST_DATA_QR39_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    
    # ASCO2O-25084: [Proxy] Enhance mtran proxy after sync QR39 to mtran database
    Get Merchant    ${TEST_DATA_CMS_BRAND_PROJECT_ID}    trueyou_merchant_id=${TEST_DATA_MERCHANT_TAG29_TRUEYOU_MERCHANT_ID},${TEST_DATA_MERCHANT_TAG39_TRUEYOU_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    data    ${TEST_DATA_QR29_MERCHANT_ID},${TEST_DATA_QR39_MERCHANT_ID}
