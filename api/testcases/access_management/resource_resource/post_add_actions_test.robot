*** Settings ***
Documentation    Tests to verify that add action(s) to resource api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/resource_resource_keywords.robot

Test Setup    Generate Gateway Header With Scope and Permission    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${project_id}    testProjectId

*** Test Cases ***
TC_O2O_16366
    [Documentation]     [accessManagement][addAction] /api/projects/{projectId}/resources/key/{resourceKey}/actions api returns Resource's information correctly
    [Tags]      Regression
    Generate Resource Key From Current Date Time
    Post Create Resource    ${project_id}    { "key":"${KEY}", "description":"read-write", "actions":[ "Read" ] }
    Post Add Action    ${project_id}    ${KEY}    { "actions":[ "write", "Read" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    projectId    ${project_id}
    Response Should Contain Property With Value    key    ${KEY}
    Response Should Contain Property With Value    actions[0]    read
    Response Should Contain Property With Value    actions[1]    write
