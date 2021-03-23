*** Settings ***
Documentation    Tests to verify that the approve redeemed reward APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/estamp/estamp_common_keywords.robot
Resource        ../../../keywords/estamp/campaign_keywords.robot
Resource        ../../../keywords/estamp/stamp_account_keywords.robot
Resource        ../../../keywords/estamp/issue_stamp_keywords.robot
Resource        ../../../keywords/estamp/redeem_reward_keywords.robot
Test Setup          Prepare Generated Unique Code To Redeem Reward
Test Teardown       Delete All Sessions

*** Variables ***
${brand_code}                               0022281
${stamp_amount}                             3
${incorrect_uniquecode}                     124536788665675
${error_used_uniquecode}                    The code has been already used.

*** Keywords ***
Prepare Generated Unique Code To Redeem Reward
    Prepare E-Stamp Campaign Test Data
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}
    Login As Customer On TrueYou
    Generate RedeemCode To Redeem Reward    ${created_extra_reward_id}    ${created_stamp_account_id}

*** Test Cases ***
TC_O2O_04807
    [Documentation]    To verify that API will return error when uniqueCode is not existing
    [Tags]      EStamp      RegressionExclude      Medium
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${incorrect_uniquecode}
    Response Correct Code      ${NOT_FOUND_CODE}

TC_O2O_04810
    [Documentation]    To verify that API will retrun error when user want to redeem extra reward but uniqueCode already used
    [Tags]      EStamp      RegressionExclude      Medium
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value         title         ${error_used_uniquecode}

TC_O2O_04811
    [Documentation]    To verify that API will retrun error when user want to redeem main reward but uniqueCode already used
    [Tags]      EStamp      RegressionExclude      Medium
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Customer On TrueYou
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}
    Login As Customer On TrueYou
    Generate RedeemCode To Redeem Reward    ${created_main_reward_id}    ${created_stamp_account_id}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value         title         ${error_used_uniquecode}

TC_O2O_04814
    [Documentation]    To verify that API will return error when approve reward with merchants does not campaign's owner (check binding merchant)
    [Tags]      EStamp      RegressionExclude      High       Security
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value     title         Forbidden
    Response Should Contain Property With Value     detail        Access is denied

TC_O2O_04819
    [Documentation]    To verify that new stamp accounts will create when user already redeemed main reward
    [Tags]      EStamp      RegressionExclude      Medium
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Customer On TrueYou
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}
    Login As Customer On TrueYou
    Generate RedeemCode To Redeem Reward    ${created_main_reward_id}    ${created_stamp_account_id}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value         redeemedReward.stampAccount.status      INACTIVE
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value         status             ACTIVE
    Response Should Contain Property With Value         brandCode          ${brand_code}


