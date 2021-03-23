*** Settings ***
Documentation    Tests to verify that the "Verify Redeem Voucher" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/vouchers_keywords.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Test Setup    Run Keywords    Prepare Vouchers For Test    ${quantity_dummy_data_file}    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.voucher.read
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${regular_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/regular_voucher_data.json
${redeem_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/redeem_voucher_data.json

*** Test Cases ***
TC_O2O_06227
    [Documentation]    Verify that user cannot call API Verify Voucher without "campaign.voucher.read" scope
    [Tags]    BE-Campaign    RegressionExclude    High    SmokeExclude
    [Setup]    Run Keywords    Prepare Vouchers For Test    ${quantity_dummy_data_file}    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Read Dummy Json From File    ${redeem_voucher_dummy_data_file}
    Post Verify Voucher    ${voucher_code}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/vouchers/${voucher_code}
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_06228
    [Documentation]    Verify that user can call API to verify redeemable voucher which campaign has rules "Voucher" trigger type
    [Tags]    BE-Campaign    RegressionExclude    High    SmokeExclude
    Read Dummy Json From File    ${redeem_voucher_dummy_data_file}
    Post Verify Voucher    ${voucher_code}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Response Of Verify Voucher    FREE_ITEM    sku_003