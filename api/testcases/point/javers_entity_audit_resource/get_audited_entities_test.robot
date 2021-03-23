*** Settings ***
Documentation    Tests to verify that getAuditedEntities api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/point/javers_entity_audit_resource_keywords.robot

# permission_name=point.entityAudit.actAsAdmin
Test Setup    Generate Robot Automation Header    ${POINT_USERNAME}    ${POINT_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_02800
    [Documentation]     [Point][getAuditedEntities] API return status 200 and return all entity correctly
    [Tags]      Regression     Medium    Smoke
    Get Audited Entities
    Response Correct Code    ${SUCCESS_CODE}