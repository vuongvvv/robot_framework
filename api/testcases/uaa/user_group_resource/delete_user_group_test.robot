*** Settings ***
Documentation    Tests to verify that deleteUserGroup api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_group_keywords.robot

# permission: uaa.userGroup.delete
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Variables ***
${not_exist_user_group_id}    999999
*** Test Cases ***
TC_O2O_08043
    [Documentation]     [UAA][deleteUserGroup] User with permission uaa.userGroup.delete can send DELETE /api/user-groups/{id}
    [Tags]    Regression     Medium    Smoke
    Delete User Group    ${not_exist_user_group_id}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
	Response Should Contain Property With Value     detail    No class com.ascend.o2o.domain.UserGroup entity with id ${not_exist_user_group_id} exists!
	Response Should Contain Property With Value     message    error.http.500
	Response Should Contain Property With Value     path    /api/user-groups/${not_exist_user_group_id}
	Response Should Contain Property With Value     status    ${${INTERNAL_SERVER_CODE}}
	Response Should Contain Property With Value     title    Internal Server Error
	Response Should Contain Property With Value     type    http://www.jhipster.tech/problem/problem-with-message