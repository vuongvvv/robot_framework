*** Settings ***
Documentation    Tests to verify that createUserGroup api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_group_keywords.robot

# permission: uaa.userGroup.create,uaa.userGroup.list
Test Setup    Run Keywords    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
...    AND    Get User Group Id    name.equals=robot_automation_test_user_group_uaa
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_08042
    [Documentation]     [UAA][createUserGroup] Request with duplicated "name" returns 400
    [Tags]    Regression     Medium    Smoke
    Post Create User Group    { "id": ${USER_GROUP_ID},"name": "${PROD_TEST_USER_GROUP}", "description": null, "permissions": [], "users": [] }
    Response Correct Code    ${BAD_REQUEST_CODE}
	Response Should Contain Property With Value     entityName    userGroup
	Response Should Contain Property With Value     errorKey    idexists
	Response Should Contain Property With Value     message    error.idexists
	Response Should Contain Property With Value     params    userGroup
	Response Should Contain Property With Value     status    ${${BAD_REQUEST_CODE}}
	Response Should Contain Property With Value     title    A new userGroup cannot already have an ID
	Response Should Contain Property With Value     type    http://www.jhipster.tech/problem/problem-with-message