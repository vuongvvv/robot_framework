*** Settings ***
Documentation    Tests to verify that the "Generate Vouchers" API can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/vouchers_keywords.robot
Test Setup    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.voucher.create
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${bad_request_title}    Bad Request
${contraint_violation_title}    Constraint Violation
${regular_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/regular_voucher_data.json
${collectible_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/collectible_voucher_data.json

*** Test Cases ***
TC_O2O_05483
    [Documentation]    Verify that Generate Voucher API cannot call without scope "campaign.voucher.create"
    [Tags]    BE-Campaign    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Read Dummy Json From File    ${regular_voucher_dummy_data_file}
    Post Generate List Of Voucher Code    ${campaign_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/${campaign_id}/vouchers
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_05486
    [Documentation]    Verify that user can get 201 when call "generate voucher API" with correct regular voucher
    [Tags]    BE-Campaign    RegressionExclude    High    SmokeExclude
    Read Dummy Json From File    ${regular_voucher_dummy_data_file}
    Post Generate List Of Voucher Code    ${campaign_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    campaignId    ${campaign_id}
    Response Should Contain Property With Value    totalCode    ${100}
    Response Should Contain Property With Value    type    REGULAR
    Response Should Contain Property Matches Regex    batchId    \\w+

TC_O2O_05487
    [Documentation]    Verify that user can get 201 when call "generate voucher API" with correct collectible voucher
    [Tags]    BE-Campaign    RegressionExclude    High
    Read Dummy Json From File    ${collectible_voucher_dummy_data_file}
    Post Generate List Of Voucher Code    ${campaign_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    campaignId    ${campaign_id}
    Response Should Contain Property With Value    totalCode    ${100}
    Response Should Contain Property With Value    type    COLLECTIBLE
    Response Should Contain Property Matches Regex    batchId    \\w+
