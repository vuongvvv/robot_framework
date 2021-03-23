*** Settings ***
Documentation    Tests to verify that the "Redeem Vouchers" API can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/vouchers_keywords.robot
Library    DateTime
Test Setup    Run Keywords    Prepare Vouchers For Test    ${quantity_dummy_data_file}    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.voucher.update
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${regular_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/regular_voucher_data.json
${collectible_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/collectible_voucher_data.json
${redeem_voucher_dummy_data_file}    ../../resources/testdata/component/feature/campaign/redeem_voucher_data.json
${quantity_dummy_data_file}    ../../resources/testdata/component/feature/campaign/quantity_campaign_promotions_data.json

*** Test Cases ***
TC_O2O_05598
    [Documentation]    Verify that user cannot redeem voucher code without "campaign.voucher.update" scope
    [Tags]    BE-Campaign    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Vouchers For Test    ${quantity_dummy_data_file}    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Read Dummy Json From File    ${redeem_voucher_dummy_data_file}
    Put Redeem Voucher    ${voucher_code}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/vouchers/${voucher_code}
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_05599
    [Documentation]    Verify that user can call API to redeem voucher with correct voucher code, customerId, total, merchantId and items
    [Tags]    BE-Campaign    RegressionExclude    High    SmokeExclude
    Read Dummy Json From File    ${redeem_voucher_dummy_data_file}
    Put Redeem Voucher    ${voucher_code}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Response Of Redeem Voucher    ${json_dummy_data}    ${SUPER_ADMIN_USER}
    Delete Created Client And User Group
    Prepare Vouchers For Test    ${quantity_dummy_data_file}    ${collectible_voucher_dummy_data_file}
    Read Dummy Json From File    ${redeem_voucher_dummy_data_file}
    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.voucher.update
    Put Redeem Voucher    ${voucher_code}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Response Of Redeem Voucher    ${json_dummy_data}    ${SUPER_ADMIN_USER}    COLLECTIBLE