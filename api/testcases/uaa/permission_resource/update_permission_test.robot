*** Settings ***
Documentation    Tests to verify that updatePermission api in uaa microservice works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/permission_resource_keywords.robot
Suite Setup          Generate Gateway Header    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
Test Setup    Get First Existing Permission Information
Suite Teardown       Delete All Sessions

*** Variables ***
${unique_permission_name}    notification.config.refreshunique
${duplicated_permission_name}    notification.registration.approve

*** Test Cases ***
TC_O2O_05464
    [Documentation]     [API][updatePermission] Update permission with a unique name returns 200
    [Tags]      Regression     High
    Put Update Permission    { "description": "${EXISTING_PERMISSION_DESCRIPTION}", "name": "${unique_permission_name}", "id": ${EXISTING_PERMISSION_ID} }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    description    ${EXISTING_PERMISSION_DESCRIPTION}
    Response Should Contain Property With Value    name    ${unique_permission_name}
    Response Should Contain Property With Value    id    ${EXISTING_PERMISSION_ID}
    Put Update Permission    { "description": "${EXISTING_PERMISSION_DESCRIPTION}", "name": "${EXISTING_PERMISSION_NAME}", "id": ${EXISTING_PERMISSION_ID} }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    description    ${EXISTING_PERMISSION_DESCRIPTION}
    Response Should Contain Property With Value    name    ${EXISTING_PERMISSION_NAME}
    Response Should Contain Property With Value    id    ${EXISTING_PERMISSION_ID}
    [Teardown]    Revert Permission Name

TC_O2O_05465
    [Documentation]     [API][updatePermission] Update permission with a duplicated name returns 400
    [Tags]      Regression     Medium
    Put Update Permission    { "description": "${EXISTING_PERMISSION_DESCRIPTION}", "name": "${duplicated_permission_name}", "id": ${EXISTING_PERMISSION_ID} }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    entityName    permission
    Response Should Contain Property With Value    errorKey    nameexists
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    A permission cannot update due to name already exists
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    message    error.nameexists
    Response Should Contain Property With Value    params    permission
    
TC_O2O_05466
    [Documentation]     [API][updatePermission] Update permission with the same name returns 200
    [Tags]      Regression     Medium
    Put Update Permission    { "description": "${EXISTING_PERMISSION_DESCRIPTION}", "name": "${EXISTING_PERMISSION_NAME}", "id": ${EXISTING_PERMISSION_ID} }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    description    ${EXISTING_PERMISSION_DESCRIPTION}
    Response Should Contain Property With Value    name    ${EXISTING_PERMISSION_NAME}
    Response Should Contain Property With Value    id    ${EXISTING_PERMISSION_ID}