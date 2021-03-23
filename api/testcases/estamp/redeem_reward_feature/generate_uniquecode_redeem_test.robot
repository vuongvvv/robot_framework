*** Settings ***
Documentation    To verify validation cases for the generate redeemcode APIs is return response as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/estamp/estamp_common_keywords.robot
Resource        ../../../keywords/estamp/campaign_keywords.robot
Resource        ../../../keywords/estamp/stamp_account_keywords.robot
Resource        ../../../keywords/estamp/issue_stamp_keywords.robot
Resource        ../../../keywords/estamp/redeem_reward_keywords.robot
Test Setup          Prepare Created Stamp Account
Test Teardown       Delete All Sessions

*** Variables ***
${brand_code}                               0022281
${stamp_amount_before_reward}               2
${stamp_amount_reward_position}             6
${stamp_amount}                             3
${error_reward_not_found}                   Reward not found on campaign
${error_stamp_not_enough}                   Issued stamp not enough(2)
${error_incorrect_stamp_account_id}         Stamp account not found
${error_redeemed_reward}                    Can not redeem reward, reward has been already redeemed.
${incorrect_reward_id}                      1212121212121212
${incorrect_stamp_account}                  2999999000

*** Keywords ***
Prepare Created Stamp Account
	Prepare E-Stamp Campaign Test Data
	Login As Customer On TrueYou
	Create Stamp Account     ${created_campaign_id}      ${brand_code}

Prepare Generate Issue Stamp
	[Arguments]       ${created_stamp_account_id}      ${stamp_amount}
	Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}

Prepare Approve Issue Stamp
	Login As Merchants On TSM
	TSM Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}

*** Test Cases ***

TC_O2O_04784
	[Documentation]    Verify that API will return error when stamp account is not existing
	[Tags]      EStamp      RegressionExclude      Medium
	Prepare Generate Issue Stamp    ${created_stamp_account_id}     ${stamp_amount_reward_position}
	Prepare Approve Issue Stamp
	Login As Customer On TrueYou
	Generate RedeemCode To Redeem Reward     ${created_main_reward_id}         ${incorrect_stamp_account}
	Response Correct Code      ${NOT_FOUND_CODE}
	Response Should Contain Property With Value         error         ${error_incorrect_stamp_account_id}

TC_O2O_04786
	[Documentation]    Verify that API will return error when reward is not existing
	[Tags]      EStamp      RegressionExclude      Medium
	Prepare Generate Issue Stamp    ${created_stamp_account_id}    ${stamp_amount_reward_position}
	Prepare Approve Issue Stamp
	Login As Customer On TrueYou
	Generate RedeemCode To Redeem Reward     ${incorrect_reward_id}    ${created_stamp_account_id}
	Response Correct Code      ${NOT_FOUND_CODE}
	Response Should Contain Property With Value      error      ${error_reward_not_found}

TC_O2O_04790
	[Documentation]    Verify that API will return error when user want to redeem extra reward but issued stamp is insufficient
	[Tags]      EStamp      RegressionExclude      Medium
	Prepare Generate Issue Stamp    ${created_stamp_account_id}     ${stamp_amount_before_reward}
	Prepare Approve Issue Stamp
	Login As Customer On TrueYou
	Generate RedeemCode To Redeem Reward     ${created_extra_reward_id}    ${created_stamp_account_id}
	Response Correct Code      ${BAD_REQUEST_CODE}
	Response Should Contain Property With Value      error         ${error_stamp_not_enough}

TC_O2O_04791
	[Documentation]    Verify that API will return error when user want to redeem main reward but issued stamp is insufficient
	[Tags]      EStamp      RegressionExclude      Medium
	Prepare Generate Issue Stamp    ${created_stamp_account_id}     ${stamp_amount_before_reward}
	Prepare Approve Issue Stamp
	Login As Customer On TrueYou
	Generate RedeemCode To Redeem Reward     ${created_main_reward_id}    ${created_stamp_account_id}
	Response Correct Code      ${BAD_REQUEST_CODE}
	Response Should Contain Property With Value      error         ${error_stamp_not_enough}

TC_O2O_04798
	[Documentation]     Verify that API will return error when user account is not matched with logged in token
	[Tags]      EStamp      RegressionExclude      High    Security
	Prepare Generate Issue Stamp    ${created_stamp_account_id}     ${stamp_amount}
	Prepare Approve Issue Stamp
	Login As Merchants On TSM
	Generate RedeemCode To Redeem Reward     ${created_main_reward_id}    ${created_stamp_account_id}
	Response Correct Code      ${FORBIDDEN_CODE}
	Response Should Contain Property With Value     title         Forbidden
	Response Should Contain Property With Value     detail        Access is denied

TC_O2O_04800
	[Documentation]    Verify that API will retrun error when generate uniquecode with extra reward that already redeemed
	[Tags]      EStamp      RegressionExclude      Medium
	Prepare Generate Issue Stamp    ${created_stamp_account_id}     ${stamp_amount}
	Prepare Approve Issue Stamp
	Login As Customer On TrueYou
	Generate RedeemCode To Redeem Reward     ${created_extra_reward_id}    ${created_stamp_account_id}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Customer On TrueYou
	Generate RedeemCode To Redeem Reward     ${created_extra_reward_id}    ${created_stamp_account_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
	Response Should Contain Property With Value      error         ${error_redeemed_reward}

TC_O2O_04801
	[Documentation]    Verify that API will retrun error when generate uniquecode with main reward that already redeemed
	[Tags]      EStamp      RegressionExclude      Medium
	Prepare Generate Issue Stamp    ${created_stamp_account_id}     ${stamp_amount}
	Prepare Approve Issue Stamp
	Login As Customer On TrueYou
	Generate RedeemCode To Redeem Reward     ${created_extra_reward_id}    ${created_stamp_account_id}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Customer On TrueYou
    Prepare Generate Issue Stamp    ${created_stamp_account_id}     ${stamp_amount}
	Prepare Approve Issue Stamp
    Login As Customer On TrueYou
	Generate RedeemCode To Redeem Reward     ${created_main_reward_id}    ${created_stamp_account_id}
	Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Customer On TrueYou
	Generate RedeemCode To Redeem Reward     ${created_main_reward_id}    ${created_stamp_account_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
	Response Should Contain Property With Value      error         ${error_redeemed_reward}