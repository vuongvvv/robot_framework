*** Settings ***
Documentation    Tests to verify that getAuthorities api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_keywords.robot

# permission: uaa.user.list
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_08053
    [Documentation]     [uaa][getAuthorities] Request with "uaa.user.list" permission returns 200
    [Tags]    Regression     Medium    Smoke
    Get Authorities
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be String