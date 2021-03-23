*** Settings ***
Documentation    Tests to verify that signInWithSdk api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../../web/resources/init.robot
Resource    ../../../keywords/uaa/social_resource_keywords.robot
Resource    ../../../keywords/uaa/login_trueid_keywords.robot
Resource    ../../../keywords/common/sdk_authentication_common.robot
Resource    ../../../keywords/uaa/account_resource_keywords.robot

Test Setup    Generate Basic Authentication Header    robotautomationclient    robotautomationclient
Test Teardown     Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${trueid_username}    ${TRUE_ID_USER}
${trueid_password}    ${TRUE_ID_USER_PASSWORD}
${trueid_login_url}    ${API_HOST}/uaa/api/social/signin/${trueid_provider}
${trueid_provider}    trueid

*** Test Cases ***
TC_O2O_04927
    [Documentation]     [UAA][signInWithSdk] Request with existing user returns 200 with user information updated in UAA database
    [Tags]    Regression    High    Smoke    uaa    trueid
    Open Browser With Option    ${trueid_login_url}
    Login TrueID On Website    ${trueid_username}    ${trueid_password}
    Get Login Code And State
    Post Exchange UAA And TrueID Token    ${CODE_ID}
    Fetch True Id Access Token
    Post Sign In With Sdk    ${trueid_provider}    {"trueIdAccessToken": "${TEST_DATA_TRUE_ID_ACCESS_TOKEN}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value     access_token
    Response Should Contain Property With Number String     expires_in
    Response Should Contain Property With Number String     iat
    Response Should Contain Property With String Value     jti
    Response Should Contain Property With String Value     refresh_token
    Response Should Contain Property With String Value     scope
    Response Should Contain Property With Value     token_type    bearer
    Set True Id Access Token To O2O Gateway Header
    Get Account
    Format Mobile Number As Thai Format    ${TRUE_ID_USER}
    Response Should Contain Property With Value    mobile    ${TEST_DATA_MOBILE_NUMBER_AS_66_FORMAT}