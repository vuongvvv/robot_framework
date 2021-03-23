*** Settings ***
Documentation    Tests to verify that delete Resource action api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/resource_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Delete All Sessions

*** Variables ***
${project_id}    testProjectId

*** Test Cases ***
TC_O2O_16356
    [Documentation]     [accessManagement][deleteResourceAction] DELETE /api/projects/{projectId}/resources/key/{resourceKey}/actions/{action} api returns Resource with no deleted action
    [Tags]      Regression    Smoke
    Generate Resource Key From Current Date Time
    Post Create Resource    ${project_id}    { "key":"${KEY}", "description":"read-write", "actions":[ "write", "Read" ] }
    Delete Resource Action    ${project_id}    ${KEY}    WRITE
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    $.[*].id
    Response Should Contain Property With Value    $.[*].projectId    ${project_id}
    Response Should Contain Property With Value    $.[*].key    ${KEY}
    Response Should Contain Property With Value    actions[0]    read