*** Settings ***
Documentation    Tests to verify that isAuthenticated api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/account_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_07841
    [Documentation]     [uaa][isAuthenticated] Request with logged in user returns 200
    [Tags]      Regression     Medium    Smoke
    Get Is Authenticated
    Response Correct Code    ${SUCCESS_CODE}