*** Settings ***
Documentation    Tests to verify that the "Get List Vouchers" API can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/vouchers_keywords.robot
Test Setup    Run Keywords    Prepare Vouchers For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.voucher.list
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${regular_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/regular_voucher_data.json
${collectible_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/collectible_voucher_data.json

*** Test Cases ***
TC_O2O_05543
    [Documentation]    Verify that GetListVoucher API cannot call without scope "campaign.voucher.list"
    [Tags]    BE-Campaign    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Vouchers For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Get List Campaign Promotion Vouchers
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/vouchers
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_05544
    [Documentation]    Verify that GetListVoucher API can sucessfully call with scope "campaign.voucher.list" and no other parameters
    [Tags]    BE-Campaign    RegressionExclude    High
    Get List Campaign Promotion Vouchers
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC

TC_O2O_05545
    [Documentation]    Verify that GetListVoucher API can sucessfully call with correct page and correct size
    [Tags]    BE-Campaign    RegressionExclude    High
    Get List Campaign Promotion Vouchers    page=&size=
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC
    Get List Campaign Promotion Vouchers    page=1&size=10
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC
    Get List Campaign Promotion Vouchers    page=2&size=3
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC
    Get List Campaign Promotion Vouchers    page=2&size=0
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC

TC_O2O_05583
    [Documentation]    Verify that GetListVoucher API can sucessfully call with correct batchId
    [Tags]    BE-Campaign    RegressionExclude    High
    Get List Campaign Promotion Vouchers    batchId=${batch_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC
    Response Should Contain Property With Value    .batchId    ${batch_id}
    Get List Campaign Promotion Vouchers    batchId=
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC
    Response Should Contain Property Matches Regex    .batchId    \\w+