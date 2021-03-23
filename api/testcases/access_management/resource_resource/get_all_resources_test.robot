*** Settings ***
Documentation    Tests to verify that get all Resources api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/resource_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Delete All Sessions

*** Variables ***
${project_id}    testProjectId
@{list_of_action}    read    write

*** Test Cases ***
TC_O2O_16344
    [Documentation]     [accessManagement][createResource] /api/projects/{projectId}/resources api returns listing Resource by project Id
    [Tags]      Regression    Smoke
    Generate Resource Key From Current Date Time
    Post Create Resource    ${project_id}    { "key":"${KEY}", "description":"read-write", "actions":[ "write", "Read" ] }
    Get All Resources    ${project_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    $.[*].id
    Response Should Contain Property With Value    $.[*].projectId    ${project_id}
    Response Should Contain Property With String Value    $.[*].key
    Response Should Contain Property With Value    $.[*].description    read-write
    Response Should Contain Property Value Include In List    $.[0].actions[*]    ${list_of_action}
    Response Should Contain Property With Empty Value    $.[0].children
