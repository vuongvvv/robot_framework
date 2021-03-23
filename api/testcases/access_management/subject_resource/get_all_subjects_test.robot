*** Settings ***
Documentation    Tests to verify that get all Subjects api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/subject_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Delete All Sessions

*** Variables ***
${project_id}    testProjectId

*** Test Cases ***
TC_O2O_16310
    [Documentation]     [accessManagement][createResource] /api/projects/{projectId}/subjects api returns listing Subject by project Id
    [Tags]      Regression    Smoke
    Generate Subject Key From Current Date Time
    Post Create Subject    ${project_id}    { "key":"${KEY}", "description":"automated key" }
    Get All Subjects    ${project_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    $.[*].id
    Response Should Contain Property With Value    $.[*].projectId    ${project_id}
    Response Should Contain Property With String Value    $.[*].key
    Response Should Contain Property With Value    $.[*].description    automated key