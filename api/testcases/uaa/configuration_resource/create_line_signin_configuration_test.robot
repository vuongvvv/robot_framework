*** Settings ***
Documentation    Tests to verify that create line signin configuration api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/configuration_resource_keywords.robot

# scope: uaa.config.write    
# permission: uaa.config.write
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_13550
    [Documentation]    Request with "uaa.config.write" scope and "uaa.config.write" permission and "channelId" is String value returns 201
    [Tags]    Regression    Smoke    UnitTest    High
    Generate Random Line Channel Id
    Post Create Line Signin Configuration    { "channelId": "${RANDOM_CHANNEL_ID}" }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value    $.id
    Response Should Contain Property With Value    channelId    ${RANDOM_CHANNEL_ID}

TC_O2O_13554
    [Documentation]    Request with "channelId" already exists returns 201
    [Tags]    Regression    Smoke    UnitTest    High
    Generate Random Line Channel Id
    Post Create Line Signin Configuration    { "channelId": "${RANDOM_CHANNEL_ID}" }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value    $.id
    Response Should Contain Property With Value    channelId    ${RANDOM_CHANNEL_ID}
    Post Create Line Signin Configuration    { "channelId": "${RANDOM_CHANNEL_ID}" }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value    $.id
    Response Should Contain Property With Value    channelId    ${RANDOM_CHANNEL_ID}