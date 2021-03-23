*** Settings ***
Documentation    Tests to verify that the coupon status can be activated/deactivated accordingly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/coupons_keywords.robot
Test Setup    Run Keywords    Prepare Coupons For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.coupon.update
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${coupon_dummy_data_file}    ../../resources/testdata/component/feature/campaign/coupon_data.json

*** Test Cases ***
TC_O2O_05838
    [Documentation]    Verify that user cannot call API update status of Coupon without "campaign.coupon.update" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High    SmokeExclude
    [Setup]    Run Keywords    Prepare Coupons For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    ${updated_status_data}    Create Dictionary    status=INACTIVE
    Update Coupon Status    ${coupon_id}    ${updated_status_data}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/coupons/${coupon_id}
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_05839
    [Documentation]    Verify that user can call API update status of Coupon with "campaign.coupon.update" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High    SmokeExclude
    ${updated_status_data}    Create Dictionary    status=INACTIVE
    Update Coupon Status    ${coupon_id}    ${updated_status_data}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    INACTIVE
    Response Should Contain Property With Value    code    ${coupon_code}
    Response Should Contain Property With Value    name    ${json_dummy_data["name"]}
    Response Should Contain Property With Value    campaignId    ${campaign_id}
    Response Should Contain Property Matches Regex    lastModifiedDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Response Should Contain Property Matches Regex    createdDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Response Should Contain Property With Value    usedTimes    ${0}
    Response Should Contain Property With Value    lastModifiedBy    ${SUPER_ADMIN_USER}
    Response Should Contain Property With Value    maxUsePerUser    ${json_dummy_data["maxUsePerUser"]}
    Response Should Contain Property With Value    createdBy    ${SUPER_ADMIN_USER}
    Response Should Contain Property With Value    totalUse    ${json_dummy_data["totalUse"]}
    Response Should Contain Property With Value    couponGroup    ${json_dummy_data["couponGroup"]}
    Response Should Contain Property Matches Regex    id    \\w+
    ${updated_status_data}    Create Dictionary    status=ACTIVE
    Update Coupon Status    ${coupon_id}    ${updated_status_data}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .status    ACTIVE
    Response Should Contain Property With Value    code    ${coupon_code}
    Response Should Contain Property With Value    name    ${json_dummy_data["name"]}
    Response Should Contain Property With Value    campaignId    ${campaign_id}
    Response Should Contain Property Matches Regex    lastModifiedDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Response Should Contain Property Matches Regex    createdDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Response Should Contain Property With Value    usedTimes    ${0}
    Response Should Contain Property With Value    lastModifiedBy    ${SUPER_ADMIN_USER}
    Response Should Contain Property With Value    maxUsePerUser    ${json_dummy_data["maxUsePerUser"]}
    Response Should Contain Property With Value    createdBy    ${SUPER_ADMIN_USER}
    Response Should Contain Property With Value    totalUse    ${json_dummy_data["totalUse"]}
    Response Should Contain Property With Value    couponGroup    ${json_dummy_data["couponGroup"]}