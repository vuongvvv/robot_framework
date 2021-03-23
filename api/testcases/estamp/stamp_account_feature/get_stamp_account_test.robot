*** Settings ***
Documentation    Tests to verify that the get stamp account detail APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/estamp/estamp_common_keywords.robot
Resource        ../../../keywords/estamp/stamp_account_keywords.robot
Resource        ../../../keywords/estamp/issue_stamp_keywords.robot
Resource        ../../../keywords/estamp/redeem_reward_keywords.robot
Test Setup          Login As Customer On TrueYou
Test Teardown       Delete All Sessions

*** Variables ***
${incorrect_stamp_account_id}           88999999
${error_stamp_account_id}               Stamp account not found.
${stamp_amount}                         ${6}
${brand_code}                           0022281

*** Keywords ***
Prepare Created Stamp Account
    Prepare E-Stamp Campaign Test Data
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}

Prepare Approve Redeemed Main Reward And Stamp Account Is Inactive
    Prepare E-Stamp Campaign Test Data
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}
    Login As Customer On TrueYou
    Generate RedeemCode To Redeem Reward    ${created_main_reward_id}    ${created_stamp_account_id}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value         redeemedReward.stampAccount.status      INACTIVE

*** Test Cases ***
TC_O2O_04733
    [Documentation]    Verify that API returns 404 when stamp account is not found
    [Tags]      EStamp      RegressionExclude      Medium
    Prepare Created Stamp Account
    Get Stamp Account Detail By ID      ${incorrect_stamp_account_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${error_stamp_account_id}

TC_O2O_04736
    [Documentation]    Verify that API when send request inactive stamp account
    [Tags]      EStamp      RegressionExclude      Medium
    Prepare Approve Redeemed Main Reward And Stamp Account Is Inactive
    Login As Customer On TrueYou
    Get Stamp Account Detail By ID      ${created_stamp_account_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${error_stamp_account_id}