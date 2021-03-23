*** Settings ***
Documentation    Tests to verify that the "Generate Coupon" API can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/coupons_keywords.robot
Test Setup    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.coupon.create
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${coupon_dummy_data_file}    ../../resources/testdata/component/feature/campaign/coupon_data.json

*** Test Cases ***
TC_O2O_06170
    [Documentation]    Verify that user cannot call API generate Coupon without "campaign.coupon.create" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High    SmokeExclude
    [Setup]    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Read Dummy Json From File    ${coupon_dummy_data_file}
    Post Generate Coupon Code    ${campaign_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/${campaign_id}/coupons
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_06173
    [Documentation]    Verify that user can call API generate Coupon with "campaign.coupon.create" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High    SmokeExclude
    Read Dummy Json From File    ${coupon_dummy_data_file}
    Post Generate Coupon Code    ${campaign_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    status    ACTIVE
    Response Should Contain Property Matches Regex    code    ^TET-\\w{8}-VUI$
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