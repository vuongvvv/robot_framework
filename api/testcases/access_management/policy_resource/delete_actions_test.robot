*** Settings ***
Documentation    Tests to verify that delete actions from policy api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/policy_resource_keywords.robot
Resource    ../../../keywords/access-management/resource_resource_keywords.robot
Resource    ../../../keywords/access-management/subject_resource_keywords.robot

Test Setup    Generate Gateway Header With Scope and Permission    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${project_id}    automate

*** Test Cases ***
TC_O2O_18765
    [Documentation]    [deleteActions] Request with any scope, without permission, valid projectId, valid policy id, valid actions returns 200
    [Tags]    Regression    Smoke    UnitTest
    Generate Key From Current Date Time
    Post Create Subject    ${project_id}    { "key":"automated-1-${KEY}", "description":"automated subject" }
    Post Create Resource    ${project_id}    { "key":"automated-1-${KEY}", "actions":[], "description":"automated resource" }
    Post Create Policy    ${project_id}    { "subjects":[ "automated-1-${KEY}" ], "resources":[ "automated-1-${KEY}" ], "actions":[ "read", "write" ], "description":"This is automated policy" }
    Collect Policy Id From Response
    Delete Actions    ${project_id}    ${POLICY_ID}    {"actions":["write"]}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    projectId    ${project_id}
    Response Should Contain Property With Value    subjects[*]    automated-1-${KEY}
    Response Should Contain Property With Value    resources[*]    automated-1-${KEY}
    Response Should Contain Property With Value    actions[*]    read
    Response Should Contain Property With Value    description    This is automated policy
