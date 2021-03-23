*** Settings ***
Documentation    Tests to verify that updateNotificationType api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/notification_type_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${5}
${update_term}    RobotAutomation
${type_name}    SMS_Marketing1
${not_exist_type_id}    ${999999}

*** Test Cases ***
TC_O2O_01612
    [Documentation]     [notification][updateNotificationType] Verify Update Notification type api with correct request will return valid response and "notification.notification_type" table will be updated
    [Tags]      Regression     High    Smoke    UnitTest
    Put Update Notification Type    { "id": ${type_id}, "name": "${type_name}", "quotaLimit":300, "terms": "${update_term}", "rule":"EGG_SMS" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${type_id}
    Response Should Contain Property With Value    name    ${type_name}
    Response Should Contain Property With Number String    quotaLimit
    Response Should Contain Property With Value    terms    ${update_term}
    Response Should Contain Property With Value    rule    EGG_SMS

TC_O2O_01614
    [Documentation]    [notification][updateNotificationType] Verify Update Notification type api with non existing Id will return TYPE_ID_NOT_FOUND
    [Tags]      Regression     High    Smoke    UnitTest
    Put Update Notification Type    { "id": ${not_exist_type_id}, "name": "${type_name}", "quotaLimit":300, "terms": "${update_term}", "rule":"EGG_SMS" }
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    errorKey    notificationIdNotFound
    Response Should Contain Property With Value    message    error.notificationIdNotFound
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Empty Value    params
    Response Should Contain Property With Value    title    NON_EXISTED_ID
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message