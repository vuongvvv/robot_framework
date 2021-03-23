*** Settings ***
Documentation    Tests to verify that the "Get Detail Voucher By VoucherCode" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/vouchers_keywords.robot
Test Setup    Run Keywords    Prepare Vouchers For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.voucher.read
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${bad_request_title}    Bad Request
${contraint_violation_title}    Constraint Violation
${regular_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/regular_voucher_data.json

*** Test Cases ***
TC_O2O_05473
    [Documentation]    Verify that user will get 403 when call Get Detail Campaign API if user does not have "campaign.voucher.read" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Vouchers For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Get Specific Voucher By Code    ${voucher_code}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/vouchers/${voucher_code}
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_05474
    [Documentation]    Verify that user can call API to get details voucher with correct voucherCode
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    Get Specific Voucher By Code    ${voucherCode}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    code    ${voucher_code}
    Response Should Contain Property With Value    status    ACTIVE
    Response Should Contain Property With Value    name    Tet_Holiday
    Response Should Contain Property With Value    campaignId    ${campaign_id}
    Response Should Contain Property Matches Regex    lastModifiedDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Response Should Contain Property Matches Regex    createdDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Response Should Contain Property With Value    used    ${FALSE}
    Response Should Contain Property With Value    lastModifiedBy    ${SUPER_ADMIN_USER}
    Response Should Contain Property With Value    createdBy    ${SUPER_ADMIN_USER}
    Response Should Contain Property With Value    voucherGroup    TETVUI
    Response Should Contain Property With Value    batchId    ${batch_id}
    Response Should Contain Property With Value    type    REGULAR
    Response Should Contain Property Matches Regex    id    \\w+