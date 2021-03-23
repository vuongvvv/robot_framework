*** Settings ***
Documentation    Tests to verify that getTemplate api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification_producer/notification_producer_keywords.robot

# permission_name=notification.template.read
Suite Setup    Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}
Suite Teardown     Delete All Sessions

*** Variables ***
${template_id}    ${1}
${invalid_template_id}    ${99999999}
@{status_list}    ACTIVE    INACTIVE

*** Test Cases ***
TC_O2O_06991
    [Documentation]    [NotificationProducer][getTemplate] Request with "notification.template.read" permission returns 200
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    Get Template    ${template_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${template_id}
    Response Should Contain Property With String Value    action
    Response Should Contain Property With String Value    .type
    Response Should Contain Property With String Value    .template
    Response Should Contain All Property Values Include In List    .status    ${status_list}

TC_O2O_06992
    [Documentation]    [NotificationProducer][getTemplate] Request with not exist "id" returns 404 with empty body
    [Tags]    Regression    High    Smoke    UnitTest
    Get Template    ${invalid_template_id}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Be Empty Body