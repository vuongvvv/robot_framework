*** Settings ***
Documentation    Tests to verify that updateUser api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_keywords.robot

Test Setup    Generate Robot Automation Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${not_exist_user_id}    999999

*** Test Cases ***
TC_O2O_08054
    [Documentation]     [uaa][updateUser] Request with ROLE_USER and without "uaa.user.list" permission returns 403
    [Tags]    Regression     Medium    Smoke
    Put Update User    { "id": ${not_exist_user_id}, "login": "${UAA_USERNAME}", "firstName": "robot_test", "lastName": "robot_test", "email": "robot_test@gmail.com", "mobile": "66639202325", "activated": false, "langKey": "en", "authorities": [ "ROLE_USER" ], "createdBy": null, "createdDate": null, "lastModifiedBy": null, "lastModifiedDate": null, "password": null }
    Response Correct Code    ${FORBIDDEN_CODE}
	Response Should Contain Property With Value     detail    Access is denied
	Response Should Contain Property With Value     message    error.http.403
	Response Should Contain Property With Value     path    /api/users
	Response Should Contain Property With Value     status    ${${FORBIDDEN_CODE}}
	Response Should Contain Property With Value     title    Forbidden
	Response Should Contain Property With Value     type    http://www.jhipster.tech/problem/problem-with-message