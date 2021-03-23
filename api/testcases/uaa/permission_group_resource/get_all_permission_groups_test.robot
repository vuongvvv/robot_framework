*** Settings ***
Documentation    Tests to verify that getAllPermissionGroups api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/permission_group_keywords.robot

# permission: uaa.permissionGroup.list
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_05109
    [Documentation]     [UAA][getAllPermissionGroups] User with permission uaa.permissionGroup.list can send GET /api/permissions-groups
    [Tags]      Regression     Medium    Smoke    UnitTest
    Get All Permission Groups
    Response Correct Code    ${SUCCESS_CODE}
	Response Should Contain All Property Values Are String Or Null     .description
	Response Should Contain All Property Values Are Number     .id
	Response Should Contain All Property Values Are String     .name
	Response Should Contain All Property Values Are String Or Null     .permissions