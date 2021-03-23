*** Settings ***
Documentation    Tests to verify that the "Redeem Coupons" API can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/coupons_keywords.robot
Test Setup    Run Keywords    Prepare Coupons For Test    ${quantity_dummy_data_file}    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.coupon.update
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${coupon_dummy_data_file}    ../../resources/testdata/component/feature/campaign/coupon_data.json
${redeem_coupon_dummy_data_file}    ../../resources/testdata/component/feature/campaign/redeem_coupon_data.json
${quantity_dummy_data_file}    ../../resources/testdata/component/feature/campaign/quantity_campaign_promotions_data.json

*** Test Cases ***
TC_O2O_06203
    [Documentation]    Verify that user cannot call API update status of Coupon without "campaign.coupon.update" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High    SmokeExclude
    [Setup]    Run Keywords    Prepare Coupons For Test    ${quantity_dummy_data_file}    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Read Dummy Json From File    ${redeem_coupon_dummy_data_file}
    Put Redeem Coupon Code    ${coupon_code}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/coupons/${coupon_code}
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_06204
    [Documentation]    Verify that user can call API to redeem coupon with correct coupon code, customerId, total, merchantId and items
    [Tags]    BE-Campaign    RegressionExclude    High    SmokeExclude
    Read Dummy Json From File    ${redeem_coupon_dummy_data_file}
    Put Redeem Coupon Code    ${coupon_code}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    REDEEM_SUCCESS
    Response Should Contain Property With Value    couponDetail.code    ${coupon_code}
    Response Should Contain Property With Value    couponDetail.campaignId    ${campaignID}
    Response Should Contain Property With Value    couponDetail.name    Tet_Holiday
    Response Should Contain Property With Value    couponDetail.couponGroup    TETVUI
    Response Should Contain Property With Value    couponDetail.usedTimes    ${1}
    Response Should Contain Property With Value    couponDetail.status    ACTIVE
    Put Redeem Coupon Code    ${coupon_code}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    couponDetail.usedTimes    ${2}
    Response Should Contain Property With Value    status    REDEEM_SUCCESS
    Response Should Contain Property With Value    couponDetail.code    ${coupon_code}
    Response Should Contain Property With Value    couponDetail.campaignId    ${campaignID}
    Response Should Contain Property With Value    couponDetail.name    Tet_Holiday
    Response Should Contain Property With Value    couponDetail.couponGroup    TETVUI
    Response Should Contain Property With Value    couponDetail.status    ACTIVE