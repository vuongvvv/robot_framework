*** Settings ***
Documentation    Tests to verify that remove children form Resource api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/resource_resource_keywords.robot

Test Setup    Generate Gateway Header With Scope and Permission    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${project_id}    testProjectId

*** Test Cases ***
TC_O2O_18204
    [Documentation]     Request with any scope, without permission, existing projectId, existing parent resource key, existing child resource key, and child resource key is the child of the parent resource returns 200
    [Tags]    Regression    Smoke    UnitTest    Robot
    Generate Resource Key From Current Date Time
    Post Create Resource    ${project_id}    { "key":"automated-parent-${KEY}", "description":"automate parent resource", "actions":[] }
    Post Create Resource    ${project_id}    { "key":"automated-child-${KEY}", "description":"automate child resource", "actions":[] }
    Post Add Children    ${project_id}    automated-parent-${KEY}    {"resources":["automated-child-${KEY}"]}
    Delete Children    ${project_id}    automated-parent-${KEY}    {"resources":["automated-child-${KEY}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    projectId    ${project_id}
    Response Should Contain Property With Value    key    automated-parent-${KEY}
    Response Should Contain Property With Value    description    automate parent resource
    Response Should Contain Property With Empty Value    actions
    Response Should Contain Property With Empty Value    children
