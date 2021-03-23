*** Settings ***
Documentation    Tests to verify that getAllPermissions api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/permission_resource_keywords.robot

# permission: uaa.permission.list
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_05099
    [Documentation]     [UAA][getAllPermissions] User with permission uaa.permission.list can send GET /api/permissions
    [Tags]      Regression     Medium    Smoke    UnitTest
    Get All Permissions
    Response Correct Code    ${SUCCESS_CODE}
	Response Should Contain All Property Values Are String Or Null     .description
	Response Should Contain All Property Values Are Number     .id
	Response Should Contain All Property Values Are String     .name