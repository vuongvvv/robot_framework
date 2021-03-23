*** Settings ***
Documentation    Tests to verify that add children Resource api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/resource_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Delete All Sessions

*** Variables ***
${project_id}    testProjectId

*** Test Cases ***
TC_O2O_17887
    [Documentation]    Request with any scope, without permission, existing projectId, existing parent resource key, existing child resource key returns 200
    [Tags]    Regression    Smoke    UnitTest    Robot
    Generate Resource Key From Current Date Time
    Post Create Resource    ${project_id}    { "key":"automated-parent-${KEY}", "description":"automate parent resource", "actions":[] }
    Post Create Resource    ${project_id}    { "key":"automated-child-${KEY}", "description":"automate child resource", "actions":[] }
    Post Add Children    ${project_id}    automated-parent-${KEY}    {"resources":["automated-child-${KEY}"]}
    Create List Of Value To Verify    automated-child-${KEY}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    projectId    ${project_id}
    Response Should Contain Property With Value    key    automated-parent-${KEY}
    Response Should Contain Property With Value    description    automate parent resource
    Response Should Contain Property With Empty Value    actions
    Response Should Contain Property Value Include In List    children[*]    ${LIST_OF_EXPECTED_VALUE}

TC_O2O_17888
    [Documentation]     Request with child resource is the parent of another resource returns 200
    [Tags]    Regression    UnitTest
    Generate Resource Key From Current Date Time
    Post Create Resource    ${project_id}    { "key":"automated-parent-${KEY}", "description":"automate parent resource", "actions":[] }
    Post Create Resource    ${project_id}    { "key":"automated-child-${KEY}", "description":"automate child resource", "actions":[] }
    Post Create Resource    ${project_id}    { "key":"automated-grandchild-${KEY}", "description":"automate child resource", "actions":[] }
    Post Add Children    ${project_id}    automated-child-${KEY}    {"resources":["automated-grandchild-${KEY}"]}
    Post Add Children    ${project_id}    automated-parent-${KEY}    {"resources":["automated-child-${KEY}"]}
    Create List Of Value To Verify    automated-child-${KEY}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    projectId    ${project_id}
    Response Should Contain Property With Value    key    automated-parent-${KEY}
    Response Should Contain Property With Value    description    automate parent resource
    Response Should Contain Property With Empty Value    actions
    Response Should Contain Property Value Include In List    children[*]    ${LIST_OF_EXPECTED_VALUE}

TC_O2O_17889
    [Documentation]     Request with parent resource is the child of another resource returns 200
    [Tags]    Regression    UnitTest
    Generate Resource Key From Current Date Time
    Post Create Resource    ${project_id}    { "key":"automated-grandparent-${KEY}", "description":"automate child resource", "actions":[] }
    Post Create Resource    ${project_id}    { "key":"automated-parent-${KEY}", "description":"automate parent resource", "actions":[] }
    Post Create Resource    ${project_id}    { "key":"automated-child-${KEY}", "description":"automate child resource", "actions":[] }
    Post Add Children    ${project_id}    automated-grandparent-${KEY}    {"resources":["automated-parent-${KEY}"]}
    Post Add Children    ${project_id}    automated-parent-${KEY}    {"resources":["automated-child-${KEY}"]}
    Create List Of Value To Verify    automated-child-${KEY}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    projectId    ${project_id}
    Response Should Contain Property With Value    key    automated-parent-${KEY}
    Response Should Contain Property With Value    description    automate parent resource
    Response Should Contain Property With Empty Value    actions
    Response Should Contain Property Value Include In List    children[*]    ${LIST_OF_EXPECTED_VALUE}
