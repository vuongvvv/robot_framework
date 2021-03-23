*** Settings ***
Documentation     Tests to verify that updateTemplateStatus api works correctly
Resource          ../../../resources/init.robot
Resource          ../../../keywords/notification_producer/notification_producer_keywords.robot

# permission: notification.template.update
Suite Setup       Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}
Suite Teardown    Delete All Sessions

*** Variables ***
${valid_merchant_template_id}    1
${invalid_merchant_template_id}    9999999

*** Test Cases ***
TC_O2O_06893
    [Documentation]    [API][NotificationProducer][updateTemplateStatus] Request with "notification.template.update" permission returns 200
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    Put Update Template Status    { "id": ${valid_merchant_template_id}, "status": "INACTIVE" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${${valid_merchant_template_id}}
    Response Should Contain Property With String Value    action
    Response Should Contain Property With String Value    .type
    Response Should Contain Property With String Value    .template
    Response Should Contain Property With Value    status    INACTIVE

TC_O2O_06895
    [Documentation]    [API][NotificationProducer][updateTemplateStatus] Request with not exist template id returns 400
    [Tags]    Regression    High    UnitTest
    Put Update Template Status    { "id": ${invalid_merchant_template_id}, "status": "INACTIVE" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    entityName    template
    Response Should Contain Property With Value    errorKey    TEMPLATE_NOT_FOUND
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Not found an existing template
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.TEMPLATE_NOT_FOUND
    Response Should Contain Property With Value    params    template