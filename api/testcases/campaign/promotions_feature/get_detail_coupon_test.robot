*** Settings ***
Documentation    Tests to verify that the "Get Detail Coupon By CouponCode" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/coupons_keywords.robot
Test Setup    Run Keywords    Prepare Coupons For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.coupon.read
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${coupon_dummy_data_file}    ../../resources/testdata/component/feature/campaign/coupon_data.json

*** Test Cases ***
TC_O2O_05976
    [Documentation]    Verify that user will get 403 when call Get Detail Coupon API if user does not have "campaign.coupon.read" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Coupons For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Get Specific Coupon By Code    ${coupon_code}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/coupons/${coupon_code}
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_05977
    [Documentation]    Verify that user can call API to get details coupon with correct couponCode
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    Get Specific Coupon By Code    ${coupon_code}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    ACTIVE
    Response Should Contain Property With Value    code    ${coupon_code}
    Response Should Contain Property With Value    name    Tet_Holiday
    Response Should Contain Property With Value    campaignId    ${campaign_id}
    Response Should Contain Property Matches Regex    lastModifiedDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Response Should Contain Property Matches Regex    createdDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Response Should Contain Property With Value    usedTimes    ${0}
    Response Should Contain Property With Value    lastModifiedBy    ${SUPER_ADMIN_USER}
    Response Should Contain Property With Value    maxUsePerUser    ${10}
    Response Should Contain Property With Value    createdBy    ${SUPER_ADMIN_USER}
    Response Should Contain Property With Value    totalUse    ${100}
    Response Should Contain Property With Value    couponGroup    TETVUI
    Response Should Contain Property Matches Regex    id    \\w+
