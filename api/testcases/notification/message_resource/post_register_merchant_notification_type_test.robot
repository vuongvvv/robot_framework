*** Settings ***
Documentation    Tests to verify that createMessage api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/message_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${1}

*** Test Cases ***
TC_O2O_01272
    [Documentation]    [notification][createMessage]To verify that create message API will return error 403 when user does not bind to the Merchant
    [Tags]    Regression    Medium    UnitTest    Smoke
    Post Create Message    { "condition": [ { "end": "2018-06-01T23:59:59.824Z", "start": "2018-06-01T00:01:00.824Z" } ], "merchantId": "${EXIST_O2O_MERCHANT_ID}", "messageBody":"To The World NCT", "title": "ทดสอบ", "typeId": ${type_id} }
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    entityName    merchantId
    Response Should Contain Property With Value    errorKey    permissiondenied
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Permission Denied
    Response Should Contain Property With Value    status    ${${FORBIDDEN_CODE}}
    Response Should Contain Property With Value    message    error.permissiondenied
    Response Should Contain Property With Value    params    merchantId
