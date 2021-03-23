*** Settings ***
Documentation    Tests to verify that the approve issueed stamp APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/estamp/estamp_common_keywords.robot
Resource        ../../../keywords/estamp/campaign_keywords.robot
Resource        ../../../keywords/estamp/stamp_account_keywords.robot
Resource        ../../../keywords/estamp/issue_stamp_keywords.robot
Test Setup          Prepare Generated Unique Code To Issue Stamp
Test Teardown       Delete All Sessions

*** Variables ***
${brand_code}                               0022281
${stamp_amount}                             1
${incorrect_uniquecode}                     124536788665675
${error_used_uniquecode}                    The code has been already used.

*** Keywords ***
Prepare Generated Unique Code To Issue Stamp
    Prepare E-Stamp Campaign Test Data
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}

*** Test Cases ***
TC_O2O_04769
    [Documentation]    Verify that API when enter Unique code already used
    [Tags]      EStamp      RegressionExclude      Medium
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}
    Response Correct Code      ${SUCCESS_CODE}
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value         title         ${error_used_uniquecode}

TC_O2O_04771
    [Documentation]    Verify that API when enter not found Unique code
    [Tags]      EStamp      RegressionExclude      Medium
    [Setup]     NONE
    Login As Merchants On TSM
    TSM Merchant Use Unique Code To Approve Issued Stamp    ${incorrect_uniquecode}
    Response Correct Code      ${NOT_FOUND_CODE}

TC_O2O_04773
    [Documentation]    Verify that API error when incorrect merchant aprrove issue stamp (check binding merchant)
    [Tags]      EStamp      RegressionExclude      High       Security
    TSM Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value     title         Forbidden
    Response Should Contain Property With Value     detail        Access is denied
