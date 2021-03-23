*** Settings ***
Documentation    Tests to verify that the "Get List Coupons" API can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/coupons_keywords.robot
Test Setup    Run Keywords    Prepare Coupons For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.coupon.list
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${coupon_dummy_data_file}    ../../resources/testdata/component/feature/campaign/coupon_data.json

*** Test Cases ***
TC_O2O_06143
    [Documentation]    Verify that GetListCoupon API cannot call without scope "campaign.coupon.list"
    [Tags]    BE-Campaign    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Coupons For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Get List Campaign Promotion Coupons
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/coupons
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_06144
    [Documentation]    Verify that GetListVoucher API can sucessfully call with scope "campaign.coupon.list" and no other parameters
    [Tags]    BE-Campaign    RegressionExclude    High
    Get List Campaign Promotion Coupons
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC

TC_O2O_06145
    [Documentation]    Verify that GetListVoucher API can sucessfully call with correct page and correct size
    [Tags]    BE-Campaign    RegressionExclude    High
    Get List Campaign Promotion Coupons    page=&size=
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC
    Get List Campaign Promotion Coupons    page=1&size=10
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC
    Get List Campaign Promotion Coupons    page=2&size=3
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC