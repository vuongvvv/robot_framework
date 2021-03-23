*** Settings ***
Documentation    Tests to verify that the create stamp account APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/estamp/estamp_common_keywords.robot
Resource        ../../../keywords/estamp/stamp_account_keywords.robot
Resource        ../../../keywords/estamp/issue_stamp_keywords.robot
Resource        ../../../keywords/estamp/redeem_reward_keywords.robot
Test Teardown       Delete All Sessions

*** Variables ***
${incorrect_brand_code}             1022349
${incorrect_campaign_id}            999999999999999999
${error_campaign_not_published}     Campaign is not published
${error_incorrect_campaign}         Invalid campaign id
${error_incorrect_branchcode}       Invalid brand code
${error_total_amount_not_found}     Campaign reward total amount not found
${error_reward_not_found}           Campaign reward is not found
${error_incorrect_reward_benefit}   Cannot parse campaign reward benefit
${stamp_amount}                     6
${brand_code}                       0022281

*** Keywords ***
Prepare Approve Redeemed Main Reward
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
TC_O2O_04710
    [Documentation]    Verify that API will return error 403 when user do not have permission as estamp.stampAccount.create
    [Tags]      EStamp      RegressionExclude      High      Security
    Prepare E-Stamp Campaign Is Disabled Test Data
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value     title         Forbidden
    Response Should Contain Property With Value     detail        Access is denied

TC_O2O_04721
    [Documentation]    Verify that API will return error when campagin status is disabled
    [Tags]      EStamp      RegressionExclude      Medium
    Prepare E-Stamp Campaign Is Disabled Test Data
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value      error         ${error_campaign_not_published}

TC_O2O_04722
    [Documentation]    Verify that API will return error when send request before start issue stamp date
    [Tags]      EStamp      RegressionExclude      Medium
    Prepare E-Stamp Campaign Is Not Published Test Data
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value      error         ${error_campaign_not_published}

TC_O2O_04724
    [Documentation]    Verify that API will return error when campagin is not found
    [Tags]      EStamp      RegressionExclude      Medium
    Login As Customer On TrueYou
    Create Stamp Account     ${incorrect_campaign_id}      ${brand_code}
    Response Correct Code      ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value      detail         CampaignServiceClient#getCampaignPromotionById(String) failed and no fallback available.

TC_O2O_04725
    [Documentation]    Verify that API will return error when brand code is not found
    [Tags]      EStamp      RegressionExclude      Medium
    Prepare E-Stamp Campaign Test Data
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${incorrect_brand_code}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value      title         ${error_incorrect_branchcode}

TC_O2O_04729
    [Documentation]    Verify that API returns success created new stamp account when existing stamp account is inactive
    [Tags]      EStamp      RegressionExclude      Medium
    Prepare Approve Redeemed Main Reward
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value         status             ACTIVE
    Response Should Contain Property With Value         brandCode          ${brand_code}

TC_O2O_05676
    [Documentation]    Verify that API will return error when campaign reward total amount is not found
    [Tags]      EStamp      RegressionExclude      Medium
    Prepare E-Stamp Campaign With No Reward Total Amount
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value      error         ${error_total_amount_not_found}

TC_O2O_05678
    [Documentation]    Verify that API will return error when campaign reward is not found
    [Tags]      EStamp      RegressionExclude      Medium
    Prepare E-Stamp Campaign Reward Is Not Found
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value      error         ${error_reward_not_found}

TC_O2O_05677
    [Documentation]    Verify that API will return error when cannot parse campaign reward benefit
    [Tags]      EStamp      RegressionExclude      Medium
    Prepare E-Stamp Campaign Incorrect Reward Benefit
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value      error         ${error_incorrect_reward_benefit}