*** Settings ***
Documentation    Tests to verify that deleteUserAppBlacklist api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_app_blacklist_resource_keywords.robot

# permission: uaa.user-app-blacklist.actAsAdmin
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Variables ***
${invalid_client_id}    999999999999

*** Test Cases ***
TC_O2O_02695
    [Documentation]    [uaa][deleteUserAppBlacklist] User delete blacklist account with invalid ID
    [Tags]    Regression    Revoke     Medium    UAA    SmokeExclude    O2O-5934
    Delete User App Blacklist    ${invalid_client_id}
    Response Correct Code    ${NOT_FOUND_CODE}
	Response Should Contain Property With Value     entityName    clientId
	Response Should Contain Property With Value     errorKey    CLIENT_NOT_FOUND
	Response Should Contain Property With Value     type    http://www.jhipster.tech/problem/problem-with-message
	Response Should Contain Property With Value     title    client id not found
	Response Should Contain Property With Value     status    ${${NOT_FOUND_CODE}}
	Response Should Contain Property With Value     message    error.CLIENT_NOT_FOUND
	Response Should Contain Property With Value     params    clientId