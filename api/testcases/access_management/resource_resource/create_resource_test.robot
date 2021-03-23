*** Settings ***
Documentation    Tests to verify that create Resource api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/resource_resource_keywords.robot

Test Setup    Generate Gateway Header With Scope and Permission    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${project_id}    testProjectId

*** Test Cases ***
TC_O2O_16321
    [Documentation]     [accessManagement][createResource] /api/projects/{projectId}/resources api returns Resource's information correctly
    [Tags]      Regression    Smoke
    Generate Resource Key From Current Date Time
    Post Create Resource    ${project_id}    { "key":"${KEY}", "description":"read-write", "actions":[ "write", "Read" ] }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    projectId    ${project_id}
    Response Should Contain Property With Value    key    ${KEY}
    Response Should Contain Property With Value    description    read-write
    Response Should Contain Property With Value    actions[0]    read
    Response Should Contain Property With Value    actions[1]    write

TC_O2O_16322
    [Documentation]     [accessManagement][createResource] /api/projects/{projectId}/resources api returns Duplicate data
    [Tags]      Regression    Smoke
    Generate Resource Key From Current Date Time
    Post Create Resource    ${project_id}    { "key":"${KEY}", "description":"read-write", "actions":[ "write", "Read" ] }
    Post Create Resource    ${project_id}    { "key":"${KEY}", "description":"read-write", "actions":[ "write", "Read" ] }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Duplicate Data is not allowed
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/projects/${project_id}/resources
    Response Should Contain Property With Value    message    error.duplicateData
    Response Should Contain Property With Value    params    resource
