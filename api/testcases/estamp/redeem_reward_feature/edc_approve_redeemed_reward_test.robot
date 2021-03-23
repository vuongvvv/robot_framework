*** Settings ***
Documentation    Tests to verify that the EDC approve redeemed reward APIs is return error properly as expected.
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
${outlet_id}                                00001
${terminal_id}                              69000702
${stamp_amount}                             3
${incorrect_uniquecode}                     124536788665675
${error_used_uniquecode}                    The code has been already used.
${error_invalid_merchant}                   Invalid brand code

*** Keywords ***
Prepare Generated Unique Code To Redeem Reward
    Prepare E-Stamp Campaign Test Data
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Login As Customer On TrueYou
    Generate RedeemCode To Redeem Reward    ${created_extra_reward_id}    ${created_stamp_account_id}

*** Test Cases ***
TC_O2O_05063
    [Documentation]    To verify that API will return error 403 when user do not have permission to approve redeemed reward
    [Tags]      EStamp      RegressionExclude      High       Security
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value     title         Forbidden
    Response Should Contain Property With Value     detail        Access is denied

TC_O2O_05066
    [Documentation]    To verify that API will return error when uinqieCode is not existing
    [Tags]      EStamp      RegressionExclude      Medium
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${incorrect_uniquecode}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${NOT_FOUND_CODE}

TC_O2O_05069
    [Documentation]    To verify that API will retrun error when user want to redeem extra reward but uniqueCode already used
    [Tags]      EStamp      RegressionExclude      Medium
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value         title         ${error_used_uniquecode}

TC_O2O_05070
    [Documentation]    To verify that API will retrun error when user want to redeem main reward but uniqueCode already used
    [Tags]      EStamp      RegressionExclude      Medium
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Customer On TrueYou
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp   ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Login As Customer On TrueYou
    Generate RedeemCode To Redeem Reward    ${created_main_reward_id}    ${created_stamp_account_id}
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value         title         ${error_used_uniquecode}

TC_O2O_05073
    [Documentation]    To verify that API will return error when approve reward with merchants does not campaign's owner (check binding merchant)
    [Tags]      EStamp      RegressionExclude      High       Security
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value     title         Forbidden
    Response Should Contain Property With Value     detail        Access is denied

TC_O2O_05078
    [Documentation]    To verify that new stamp accounts will create when user already redeemed main reward
    [Tags]      EStamp      RegressionExclude      Medium
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Customer On TrueYou
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Login As Customer On TrueYou
    Generate RedeemCode To Redeem Reward    ${created_main_reward_id}    ${created_stamp_account_id}
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward   ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value         redeemedReward.stampAccount.status      INACTIVE
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value         status             ACTIVE
    Response Should Contain Property With Value         brandCode          ${brand_code}
