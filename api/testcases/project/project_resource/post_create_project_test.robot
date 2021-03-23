*** Settings ***
Documentation    Tests to verify that create project api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/gateway_common.robot
Resource    ../../../keywords/project/project_resource_keywords.robot

# scope: proj.proj.w
Test Setup    Generate Robot Automation Header   ${PROJECT_USERNAME}    ${PROJECT_PASSWORD}
Test Teardown     Run Keywords    Delete Project  ${project_id}
...    AND    Delete All Sessions

*** Variables ***
${project_name}    WeMall API Test
${project_code}    WeMall_API
${project_description}     Test for WeMall

*** Test Cases ***
TC_O2O_07078
    [Documentation]  To verify response and result when user create a new project by API
    [Tags]    Hawkeye-2019S01  Regression    High    E2E
    Post Create Project     {"name": "${project_name}","code": "${project_code}","description": "${project_description}"}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.name   ${project_name}
    Response Should Contain Property With Value  $.code   ${project_code}
    Response Should Contain Property With Value  $.description    ${project_description}
    Get Created ProjectID From Response