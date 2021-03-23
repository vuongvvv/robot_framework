*** Settings ***
Documentation    Tests to verify that getUser api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_keywords.robot

Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${date_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[Z]$

*** Test Cases ***
TC_O2O_08052
    [Documentation]     [uaa][getUser] Request with ROLE_USER returns 200
    [Tags]    Regression     High    Smoke
    Get User    ${UAA_USERNAME}
    Response Correct Code    ${SUCCESS_CODE}
	Response Should Contain Property With Boolean     activated
	Response Should Contain Property Value Is String Or Empty List     authorities
	Response Should Contain Property With String Value     createdBy
	Response Should Contain Property Matches Regex     createdDate    ${date_regex}
	Response Should Contain Property With String Or Null     email
	Response Should Contain Property With String Or Null     firstName
	Response Should Contain Property With Number String     id
	Response Should Contain Property With String Or Null     .imageUrl
	Response Should Contain Property With String Or Null     .langKey
	Response Should Contain Property With String Value     .lastModifiedBy
	Response Should Contain Property Matches Regex Or Null     .lastModifiedDate    ${date_regex}
	Response Should Contain Property With String Or Null     .lastName
	Response Should Contain Property With String Value     .login
	Response Should Contain Property With Number String Or Null     .mobile