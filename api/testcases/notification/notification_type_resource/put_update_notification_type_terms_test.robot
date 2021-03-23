*** Settings ***
Documentation    Tests to verify that updateNotificationTypeTerms api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/notification_type_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${5}
${update_term}    RobotAutomation
${not_exist_type_id}    ${999999}

*** Test Cases ***
TC_O2O_04047
    [Documentation]     [Notification][updateNotificationTypeTerms] Request with user has notification.registration.approve permission returns 200
    [Tags]      Regression     High    Smoke
    Put Update Notification Type Terms    ${type_id}    { "terms": "${update_term}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    terms    ${update_term}

TC_O2O_01048
    [Documentation]    [Notification][updateNotificationTypeTerms] Verify PUT SMS Marketing Service Terms & Conditions api with non exist TYPE ID will return NOTIFICATION_TYPE_NOT_EXISTS
    [Tags]      Regression     High    Smoke
    Put Update Notification Type Terms    ${not_exist_type_id}    { "terms": "${update_term}" }
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    errorKey    notificationIdNotFound
    Response Should Contain Property With Value    message    error.notificationIdNotFound
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Empty Value    params
    Response Should Contain Property With Value    title    NOTIFICATION_TYPE_NOT_FOUND
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message