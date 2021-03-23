*** Settings ***
Documentation    Tests to verify that getFeatures api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/feature_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_01588
    [Documentation]     API return 404 when no feature toggle details for client that user login with.
    [Tags]      Regression     Medium    Smoke
    Get Features
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Be Empty Body