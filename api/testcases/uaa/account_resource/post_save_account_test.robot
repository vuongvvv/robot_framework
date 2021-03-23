*** Settings ***
Documentation    Tests to verify that saveAccount api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/account_resource_keywords.robot
Resource    ../../../keywords/uaa/user_keywords.robot
# permission: uaa.user.list
Test Setup    Run Keywords    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
...    AND    Get User Resource Test Data    .email
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_08051
    [Documentation]     [uaa][saveAccount] Request with already exist email returns 400
    [Tags]      Regression     Medium    Smoke
    Post Save Account    { "id": null, "login": "${UAA_USERNAME}", "firstName": "robot_test", "lastName": "robot_test", "email": "${USER_RESOURCE_TEST_DATA}", "mobile": "66639202325", "activated": false, "langKey": "en", "authorities": [ "ROLE_USER" ], "createdBy": null, "createdDate": null, "lastModifiedBy": null, "lastModifiedDate": null, "password": null }
    Response Correct Code    ${BAD_REQUEST_CODE}
	Response Should Contain Property With Value     entityName    userManagement
	Response Should Contain Property With Value     errorKey    emailexists
	Response Should Contain Property With Value     message    error.emailexists
	Response Should Contain Property With Value     params    userManagement
	Response Should Contain Property With Value     status    ${${BAD_REQUEST_CODE}}
	Response Should Contain Property With Value     title    Email address already in use