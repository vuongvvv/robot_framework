*** Settings ***
Documentation    Tests to verify that the EDC approve issueed stamp APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/estamp/estamp_common_keywords.robot
Resource        ../../../keywords/estamp/campaign_keywords.robot
Resource        ../../../keywords/estamp/stamp_account_keywords.robot
Resource        ../../../keywords/estamp/issue_stamp_keywords.robot
Test Setup          Prepare Generated Unique Code To Issue Stamp
Test Teardown       Delete All Sessions

*** Variables ***
${brand_code}                               0022281
${outlet_id}                                00001
${terminal_id}                              69000702
${incorrect_merchant}                       0022349
${stamp_amount}                             1
${incorrect_uniquecode}                     124536788665675
${error_used_uniquecode}                    The code has been already used.
${error_invalid_merchant}                   Invalid brand code

*** Keywords ***
Prepare Generated Unique Code To Issue Stamp
    Prepare E-Stamp Campaign Test Data
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}

*** Test Cases ***
TC_O2O_05049
    [Documentation]    Verify that API will return error 403 when user do not have permission as estamp.edc.issue
    [Tags]      EStamp      RegressionExclude      High       Security
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value     title         Forbidden
    Response Should Contain Property With Value     detail        Access is denied

TC_O2O_05054
    [Documentation]    Verify that API when enter Unique code already used
    [Tags]      EStamp      RegressionExclude      Medium
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value         title         ${error_used_uniquecode}

TC_O2O_05056
    [Documentation]    Verify that API when enter not found Unique code
    [Tags]      EStamp      RegressionExclude      Medium
    [Setup]     NONE
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${incorrect_uniquecode}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${NOT_FOUND_CODE}

TC_O2O_05058
    [Documentation]    Verify that API error when incorrect merchant aprrove issue stamp (check binding merchant)
    [Tags]      EStamp      RegressionExclude      High       Security
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}     ${incorrect_merchant}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value     title         ${error_invalid_merchant}