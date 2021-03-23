*** Settings ***
Documentation    Tests to verify that deleteNotificationType api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/notification_type_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${not_exist_notification_type_id}    ${9999999}

*** Test Cases ***
TC_O2O_01627
    [Documentation]     [notification][deleteNotificationType] Verify Delete Notification type api with non existing Type ID will return TYPE_ID_NOT_FOUND
    [Tags]      Regression     Medium    Smoke
    Delete Notification Type    ${not_exist_notification_type_id}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    errorKey    notificationNotFound
    Response Should Contain Property With Value    title    NOTIFICATION_TYPE_NOT_FOUND
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    message    error.notificationNotFound
    Response Should Contain Property With Empty Value    params