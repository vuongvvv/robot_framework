*** Settings ***
Documentation    Tests to verify that getAuditedEntities api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/javers_entity_audit_resource_keywords.robot

# permission_name=notification.entityAudit.actAsAdmin
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_01581
    [Documentation]    [API] [SMS] [History Activity Log] User with "notification.entityAudit.actAsAdmin" permission request "GET: /api/audits/entity/all" api returns 200
    [Tags]    Regression    Medium    Smoke
    Get Audited Entities
    Response Correct Code    ${SUCCESS_CODE}