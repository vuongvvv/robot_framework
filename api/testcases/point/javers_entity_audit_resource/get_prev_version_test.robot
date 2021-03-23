*** Settings ***
Documentation    Tests to verify that getPrevVersion api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/point/javers_entity_audit_resource_keywords.robot

# permission_name=point.entityAudit.actAsAdmin
Test Setup    Run Keywords    Generate Robot Automation Header    ${POINT_USERNAME}    ${POINT_PASSWORD}
...    AND    Prepare Entity Id    ${entity_type}
Test Teardown     Delete All Sessions

*** Variables ***
${commit_version}    ${2}
${entity_type}    Point

*** Test Cases ***
TC_O2O_02802
    [Documentation]    [point][getPrevVersion] When request API with commitVersion, entityId, entityType, API return previous version correctly.
    [Tags]    Regression    Medium    Smoke    ASCO2O-19150
    Get Prev Version    commitVersion=${commit_version}&entityId=${ENTITY_ID}&entityType=${entity_type}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    commitVersion    ${${commit_version-1}}
    Response Should Contain Property With Value    entityId    ${ENTITY_ID}
    Response Should Contain Property With Value    entityType    com.ascendcorp.o2o.point.domain.${entity_type}