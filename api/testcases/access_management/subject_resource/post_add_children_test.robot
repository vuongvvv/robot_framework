*** Settings ***
Documentation    Tests to verify that add children Subject api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/subject_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Delete All Sessions

*** Variables ***
${project_id}    testProjectId
${parent_key}    tc-o2o-18211-parent-
${child_key}    tc-o2o-18211-child-

*** Test Cases ***
TC_O2O_18211
    [Documentation]     Request with any scope, without permission, existing projectId, existing parent subject key, existing child subject key returns 200
    [Tags]    Regression    Smoke    accessmanagement
    Generate Subject Key From Current Date Time
    Post Create Subject    ${project_id}    { "key":"${parent_key}${KEY}", "description":"automate subject" }
    Post Create Subject    ${project_id}    { "key":"${child_key}${KEY}", "description":"automate subject" }
    Post Add Children    ${project_id}    ${parent_key}${KEY}    {"subjects":["${child_key}${KEY}"]}
    Create List Of Value To Verify    ${child_key}${KEY}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    projectId    ${project_id}
    Response Should Contain Property With Value    key    ${parent_key}${KEY}
    Response Should Contain Property With Value    description    automate subject
    Response Should Contain Property Value Include In List    children[*]    ${LIST_OF_EXPECTED_VALUE}