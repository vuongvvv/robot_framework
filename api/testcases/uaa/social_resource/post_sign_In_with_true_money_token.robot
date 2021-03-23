*** Settings ***
Documentation    Tests to verify that sign in with true money token api works correctly

Resource    ../../../resources/init.robot
Resource    ../../..//keywords/uaa/social_resource_keywords.robot

Test Setup    Generate Gateway Header For Client    scope=signin.truemoney
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${token_type_bearer}    bearer

*** Test Cases ***
TC_O2O_15208
    [Documentation]     Request with "signin.truemoney" scope and TrueMoney access token with user information and TMN account mobile number does not exist on O2O-UAA, and potential flag is OFF returns 200
    [Tags]      Regression    SmokeExclude    UnitTest
    Generate Truemoney Id
    Post Sign In With Truemoney Token    nameThEn-email:test@gmail.com-mobile:0912345678-tmn_id:${TMN_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    access_token
    Response Should Contain Property With Value    token_type    ${token_type_bearer}
    Response Should Contain Property With String Value    expires_in
    Response Should Contain Property With String Value    scope
    Response Should Contain Property With String Value    iat
    Response Should Contain Property With String Value    jti

TC_O2O_15210
    [Documentation]     Request with "signin.truemoney" scope and TrueMoney access token with user information and TMN account mobile number exists on O2O-UAA and TMN account already link to O2O-UAA account, and potential account match flag is OFF returns 200
    [Tags]      Regression    SmokeExclude    UnitTest
    Generate Truemoney Id
    Post Sign In With Truemoney Token    nameThEn-email:test@gmail.com-mobile:0912345678-tmn_id:${TMN_ID}
    Post Sign In With Truemoney Token    nameThEn-email:test@gmail.com-mobile:0911111111-tmn_id:${TMN_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    access_token
    Response Should Contain Property With Value    token_type    ${token_type_bearer}
    Response Should Contain Property With String Value    expires_in
    Response Should Contain Property With String Value    scope
    Response Should Contain Property With String Value    iat
    Response Should Contain Property With String Value    jti

TC_O2O_15209
    [Documentation]     Request with "signin.truemoney" scope and TrueMoney access token with user information and TMN account mobile number exists on O2O-UAA and TMN account not link to O2O-UAA account,and potential account match flag is OFF returns 200
    [Tags]      Regression    SmokeExclude    UnitTest
    Generate Truemoney Id
    Post Sign In With Truemoney Token    nameThEn-email:test@gmail.com-mobile:0912345678-tmn_id:${TMN_ID}
    Generate True Money Id
    Post Sign In With Truemoney Token    nameThEn-email:test@gmail.com-mobile:0912345678-tmn_id:${TMN_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    access_token
    Response Should Contain Property With Value    token_type    ${token_type_bearer}
    Response Should Contain Property With String Value    expires_in
    Response Should Contain Property With String Value    scope
    Response Should Contain Property With String Value    iat
    Response Should Contain Property With String Value    jti