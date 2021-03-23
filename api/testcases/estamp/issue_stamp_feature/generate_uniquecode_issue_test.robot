*** Settings ***
Documentation    Tests to verify that the generate uniquecode for issue stamp APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/estamp/estamp_common_keywords.robot
Resource        ../../../keywords/estamp/campaign_keywords.robot
Resource        ../../../keywords/estamp/stamp_account_keywords.robot
Resource        ../../../keywords/estamp/issue_stamp_keywords.robot
Resource        ../../../keywords/estamp/redeem_reward_keywords.robot
Test Setup          Prepare Created Stamp Account
Test Teardown       Delete All Sessions

*** Variables ***
${incorrect_stamp_account_id}               2999999000
${stamp_amount}                             ${6}
${exceed_stamp_amount}                      10
${brand_code}                               0022281
${uniquecode_status}                        PENDING
${stamp_account_status}                     ACTIVE
${unuse_uniquecode}                         ${False}
${incorrect_stamp_amount}                   0
${error_incorrect_stamp_account_id}         stampAccount not exits
${error_campaign_expired}                   Campaign expired
${error_stamp_exceed}                       Stamp amount exceed maximum quantity
${error_stamp_account_inactive}             stampAccount not exits

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
TC_O2O_04748
    [Documentation]    To verify that API will return error when stamp account is not existing
    [Tags]      EStamp      RegressionExclude      Medium
    [Setup]     NONE
    Login As Customer On TrueYou
    Generate Unique Code To Issue Stamp     ${incorrect_stamp_account_id}      ${stamp_amount}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value         errorKey         ${error_incorrect_stamp_account_id}

TC_O2O_04754
    [Documentation]    To verify that API will return existing uniqueCode when send request and uniqueCode is not expired
    [Tags]      EStamp      RegressionExclude      Medium
    Login As Customer On TrueYou
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Response Correct Code      ${CREATED_CODE}
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value              status                     ${uniquecode_status}
    Response Should Contain Property With Value              stampAmount                ${stamp_amount}
    Response Should Contain Property With Value              stampAccount.id            ${created_stamp_account_id}
    Response Should Contain Property With Value              stampAccount.status        ${stamp_account_status}
    Response Should Contain Property With Value              uniqueCode.code            ${generate_uniquecode_code}
    Response Should Contain Property With Value              uniqueCode.used            ${unuse_uniquecode}

TC_O2O_04756
    [Documentation]    To verify that API will return error when user account is not matched with logged in token
    [Tags]      EStamp      RegressionExclude      High       Security
    Login As Merchants On TSM
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value     title         Forbidden
    Response Should Contain Property With Value     detail        Access is denied

TC_O2O_04759
    [Documentation]    To verify that API when user want to issue more than 1 stamp and exceed max position of stamp
    [Tags]      EStamp      RegressionExclude      Medium
    Login As Customer On TrueYou
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${exceed_stamp_amount}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value         title         ${error_stamp_exceed}

#Hide improvement test cases
#TC_O2O_04757
#    [Documentation]    To verify that API will return error when generate uniquecode with inactive stamp account
#    [Tags]      EStamp      Regression      Medium
#    [Setup]     NONE
#    Prepare Approve Redeemed Main Reward And Stamp Account Is Inactive
#    Login As Customer On TrueYou
#    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
#    Response Correct Code      ${BAD_REQUEST_CODE}
#    Response Should Contain Property With Value         title         ${error_stamp_account_inactive}