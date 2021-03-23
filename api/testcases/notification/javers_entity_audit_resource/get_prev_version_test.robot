*** Settings ***
Documentation    Tests to verify that getPrevVersion api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/javers_entity_audit_resource_keywords.robot

# permission_name=notification.entityAudit.actAsAdmin
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${commit_version}    ${2}
${entity_id}    1
${entity_type}    NotificationType
*** Test Cases ***
TC_O2O_01579
    [Documentation]    [notification][getPrevVersion] User with "notification.entityAudit.actAsAdmin" permission can access the APIs to query the activity log on JV_SNAPSHOT table
    [Tags]    Regression    Medium    Smoke
    Get Prev Version    ${commit_version}    ${entity_id}    ${entity_type}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    commitVersion    ${${commit_version-1}}
    Response Should Contain Property With Value    entityId    ${entity_id}
    Response Should Contain Property With Value    entityType    ${entity_type}