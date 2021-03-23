*** Settings ***
Documentation    RPP Merchant Migration to the O2O platform
...    https://truemoney.atlassian.net/browse/O2O-2934
Resource    ../../../resources/init.robot
Resource    ../../../keywords/merchant/brand_resource_keywords.robot

# scope: merchantv2.brand.read
# permission: merchantv2.brand.read
Test Setup   Generate Robot Automation Header    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_25290
    [Documentation]    [MerchantV2][GetBrandsByCriteria] Verify API get brands by criteria when sending the request without request parameter
    [Tags]    Smoke    o2o-merchant
    Get Brands By Criteria
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    .id
    Response Should Contain All Property Values Are Number String    .brandId
    Response Should Contain All Property Values Are String    .category
    Response Should Contain All Property Values Are String    .subCategory
    Response Should Contain All Property Values Are String Or Empty List    .serviceTypes