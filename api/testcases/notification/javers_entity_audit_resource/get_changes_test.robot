*** Settings ***
Documentation    Tests to verify that getChanges api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/javers_entity_audit_resource_keywords.robot

# permission_name=notification.entityAudit.actAsAdmin
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_01582
    [Documentation]    [notification][getChanges] User with "notification.entityAudit.actAsAdmin" permission request "GET: /api/audits/entity/changes" api returns 200
    [Tags]    Regression    Medium    Smoke
    Get Changes    NotificationType    10
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .entityType    NotificationType
    Response Should Have Number Of Records    10    .entityId