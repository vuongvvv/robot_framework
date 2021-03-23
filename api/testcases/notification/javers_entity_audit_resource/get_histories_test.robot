*** Settings ***
Documentation    Tests to verify that getHistories api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/javers_entity_audit_resource_keywords.robot

# permission_name=notification.entityAudit.actAsAdmin
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${change_property}    lastModifiedBy
${entity_id}    1
${entity_type}    NotificationType

*** Test Cases ***
TC_O2O_01697
    [Documentation]    [notification][getHistories] Entity Historical for Registration Status's change API returns correct data
    [Tags]    Regression    Medium    Smoke
    Get Histories    ${change_property}    ${entity_id}    ${entity_type}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .entityId    ${entity_id}
    Response Should Contain All Property Values Equal To Value    .entityType    ${entity_type}