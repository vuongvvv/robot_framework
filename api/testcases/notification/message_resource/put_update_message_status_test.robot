*** Settings ***
Documentation    Tests to verify that updateMessageStatus api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/message_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${not_exist_message_id}    999999

*** Test Cases ***
TC_O2O_01134
    [Documentation]    [notification][updateMessageStatus] To verify that API will return error when messageId does not exist
    [Tags]    Regression    High    UnitTest    Smoke
    Put Update Message Status    ${not_exist_message_id}    { "status": "CANCELED" }
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    errorKey    MESSAGE_ID_NOT_FOUND
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Message not found.
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    message    error.MESSAGE_ID_NOT_FOUND
    Response Should Contain Property With Empty Value    params