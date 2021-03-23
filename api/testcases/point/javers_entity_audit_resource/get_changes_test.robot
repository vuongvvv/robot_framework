*** Settings ***
Documentation    Tests to verify that getChanges api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/point/javers_entity_audit_resource_keywords.robot

# permission_name=point.entityAudit.actAsAdmin
Test Setup    Generate Robot Automation Header    ${POINT_USERNAME}    ${POINT_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${entity_type}    Point
${limit}    10

*** Test Cases ***
TC_O2O_02801
    [Documentation]     [Point][getChanges] API return last change list for an entity class correctly
    [Tags]      Regression     Medium    Smoke
    Get Changes    ${entity_type}    ${limit}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .entityType    ${entity_type}
    Response Should Have Number Of Records    ${limit}    .entityId