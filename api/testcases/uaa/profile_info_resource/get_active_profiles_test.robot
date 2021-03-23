*** Settings ***
Documentation    Tests to verify that getActiveProfiles api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/profile_info_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
@{active_profiles_list}    prod    swagger

*** Test Cases ***
TC_O2O_08018
    [Documentation]     [uaa][getActiveProfiles] Request with ROLE_USER returns 200
    [Tags]      Regression     Medium    Smoke
    Get Active Profiles
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property Value Is List    activeProfiles    ${active_profiles_list}
	Response Should Contain Property With Null Value    ribbonEnv