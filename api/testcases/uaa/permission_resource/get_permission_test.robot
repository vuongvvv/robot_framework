*** Settings ***
Documentation    Tests to verify that getPermission api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/permission_resource_keywords.robot

# permission: uaa.permission.get,uaa.permission.list
Test Setup    Run Keywords    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
...    AND    Get First Existing Permission Information
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_05101
    [Documentation]     [UAA][getPermission] User with permission uaa.permission.get can send GET /api/permissions/{id}
    [Tags]      Regression     Medium    Smoke    UnitTest
    Get Permission    ${EXISTING_PERMISSION_ID}
    Response Correct Code    ${SUCCESS_CODE}
	Response Should Contain Property With Value     description    ${EXISTING_PERMISSION_DESCRIPTION}
	Response Should Contain Property With Value     id    ${EXISTING_PERMISSION_ID}
	Response Should Contain Property With Value     name    ${EXISTING_PERMISSION_NAME}