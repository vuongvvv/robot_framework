*** Settings ***
Documentation    Tests to verify that create Subject api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/subject_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Delete All Sessions

*** Variables ***
${project_id}    testProjectId

*** Test Cases ***
TC_O2O_16297
    [Documentation]     [accessManagement][createSubject] /api/projects/{projectId}/subjects api returns Subject's information correctly
    [Tags]      Regression    Smoke
    Generate Subject Key From Current Date Time
    Post Create Subject    ${project_id}    { "key":"${KEY}", "description":"automated key" }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    projectId    ${project_id}
    Response Should Contain Property With Value    key    ${KEY}
    Response Should Contain Property With Value    description    automated key

TC_O2O_16298
    [Documentation]     [accessManagement][createSubject] /api/projects/{projectId}/subjects api returns Duplicate data
    [Tags]      Regression
    Generate Subject Key From Current Date Time
    Post Create Subject    ${project_id}    { "key":"${KEY}", "description":"automated key" }
    Post Create Subject    ${project_id}    { "key":"${KEY}", "description":"automated key" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Duplicate Data is not allowed
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/projects/${project_id}/subjects
    Response Should Contain Property With Value    message    error.duplicateData
    Response Should Contain Property With Value    params    subject