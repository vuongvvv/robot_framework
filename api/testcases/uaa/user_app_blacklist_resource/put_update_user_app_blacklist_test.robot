*** Settings ***
Documentation    Tests to verify that updateUserAppBlacklist api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_app_blacklist_resource_keywords.robot

# permission: uaa.user-app-blacklist.actAsAdmin
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Variables ***
${not_found_user_id}    999999999

*** Test Cases ***
TC_O2O_08019
    [Documentation]    [uaa][updateUserAppBlacklist] Request with not exist blacklist id returns 404
    [Tags]    RegressionExclude_O2O-5934     Medium    SmokeExclude
    Put Update User App Blacklist    { "id": ${not_found_user_id}, "clientId": null, "userId": 4 }
    Response Correct Code    ${NOT_FOUND_CODE}
	Response Should Contain Property With Value     entityName    userId
	Response Should Contain Property With Value     errorKey    USER_NOT_FOUND
	Response Should Contain Property With Value     type    http://www.jhipster.tech/problem/problem-with-message
	Response Should Contain Property With Value     title    user id not found
	Response Should Contain Property With Value     status    ${${NOT_FOUND_CODE}}
	Response Should Contain Property With Value     message    error.USER_NOT_FOUND
	Response Should Contain Property With Value     params    userId