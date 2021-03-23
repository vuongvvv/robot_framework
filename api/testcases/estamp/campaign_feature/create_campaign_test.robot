*** Settings ***
Documentation    Tests to verify that the create estamp campaign APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/estamp/estamp_common_keywords.robot
Resource        ../../../keywords/estamp/campaign_keywords.robot
Test Setup          Login As Merchants On TSM
Test Teardown       Delete All Sessions

*** Variables ***
${campaign_name}                    Automate Create E-Stamp Campaign Test
${brand_id}                         0022281
${outlet_id}                        00001
${terminal_id}                      69000702
${max_stamp}                        ${6}
${main_reward_stamp}                ${6}
${extra_reward_stamp}               ${3}
${status}                           ENABLE
${error_incorrect_start_date}       Start Date must not be in the past
${error_incorrect_end_date}         Start date should be before end date

*** Test Cases ***
TC_O2O_05688
    [Documentation]    Verify that API will return error 403 when user do not have permission scope as campaign.promotion.create
    [Tags]      EStamp      RegressionExclude      High       Security
    [Setup]     NONE
    Login As Customer On TrueYou
    Set E-Stamp Campaign Date Period
    Create E-stamp Campaign     ${campaign_name}     ${max_stamp}      ${extra_reward_stamp}     ${main_reward_stamp}     ${start_date}      ${end_date}     ${status}      ${brand_id}    ${outlet_id}    ${terminal_id}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value     title         Forbidden
    Response Should Contain Property With Value     detail        Access is denied

TC_O2O_05690
    [Documentation]    Verify that API return 400 when crate campaign with end date before start date
    [Tags]      EStamp      RegressionExclude      Medium
    Set E-Stamp Campaign End Date Is Expired
    Create E-stamp Campaign     ${campaign_name}     ${max_stamp}      ${extra_reward_stamp}     ${main_reward_stamp}     ${start_date}      ${end_date}     ${status}      ${brand_id}    ${outlet_id}    ${terminal_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value         violations..message         ${error_incorrect_end_date}