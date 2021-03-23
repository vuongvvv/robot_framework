*** Settings ***
Documentation    Tests to verify that get policy api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/policy_resource_keywords.robot

Test Setup    Generate Gateway Header With Scope and Permission    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${project_id}    automate
${filter}    page=0&size=1&sort=ASC

*** Test Cases ***
TC_O2O_17259
    [Documentation]     Request with any scope, without permission, existing projectId, valid size, valid page, valid sort returns 200
    [Tags]      Regression    Smoke    UnitTest
    Get All Policies    ${project_id}    ${filter}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    $.[0].id
    Response Should Contain Property With String Value    $.[0].projectId
    Response Should Contain Property With String Value    $.[0].subjects[0]
    Response Should Contain Property With String Value    $.[0].subjects[1]
    Response Should Contain Property With String Value    $.[0].resources[0]
    Response Should Contain Property With String Value    $.[0].resources[1]
    Response Should Contain Property With String Value    $.[0].actions[0]
    Response Should Contain Property With String Value    $.[0].actions[1]
    Response Should Contain Property With String Value    $.[0].description