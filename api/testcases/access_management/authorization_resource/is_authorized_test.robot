*** Settings ***
Documentation    Tests to verify that Authorized policy api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/access-management/authorization_resource_keywords.robot

Test Setup    Generate Gateway Header With Scope and Permission    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${project_id}    automate
${key_1}    automated-1-20200609053846367734
${key_2}    automated-2-20200609053846367734

*** Test Cases ***
TC_O2O_17253
    [Documentation]     Request with any scope, without permission, existing projectId on cashbin, valid subject, valid resource, valid action, and Projectid & Subject & Resource & Action not matched with Cashbin Policy returns 200
    [Tags]    Regression    Smoke    UnitTest    Robot
    Post Is Authorized    ${project_id}    {"subjects":["nonExistKey"],"resources":["nonExistKey"],"actions":["nonExistKey"]}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}

TC_O2O_17255
    [Documentation]     Request with any scope, without permission, existing projectId on cashbin, valid subjects, valid resources, valid actions, and 1 combination in all combination of ProjectId & Subjects & Resources & Actions not matched with Cashbin Policy returns 200
    [Tags]    Regression    Smoke    UnitTest    Robot
    Post Is Authorized    ${project_id}    {"subjects":["nonExistKey1","${key_1}"],"resources":["${key_2}","${key_1}"],"actions":["read","write"]}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}

TC_O2O_17256
    [Documentation]     Request with any scope, without permission, existing projectId on cashbin, valid subjects, valid resources, valid actions, and All combination of ProjectId & Subjects & Resources & Actions not matched with Cashbin Policy returns 200
    [Tags]    Regression    Smoke    UnitTest    Robot
    Post Is Authorized    ${project_id}    {"subjects":["nonExistKey1","nonExistKey2"],"resources":["nonExistKey1","nonExistKey2"],"actions":["nonExistAction1","nonExistAction2"]}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}