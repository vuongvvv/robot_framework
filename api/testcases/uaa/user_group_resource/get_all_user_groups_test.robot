*** Settings ***
Documentation    Tests to verify that getAllUserGroups api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_group_keywords.robot

# permission: uaa.userGroup.list
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_05119
    [Documentation]     [UAA][getAllUserGroups] User with permission uaa.userGroup.list can send GET /api/user-groups
    [Tags]    Regression     Medium    Smoke
    Get All User Groups
    Response Correct Code    ${SUCCESS_CODE}
	Response Should Contain All Property Values Are String Or Null     .description
	Response Should Contain All Property Values Are Number     .id
	Response Should Contain All Property Values Are String     .name
	Response Should Contain All Property Values Are String Or Null     .permissionGroups
	Response Should Contain All Property Values Are String Or Null     .permissions
	Response Should Contain All Property Values Are String Or Null     .users