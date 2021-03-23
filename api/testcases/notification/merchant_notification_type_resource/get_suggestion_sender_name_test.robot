*** Settings ***
Documentation    Tests to verify that getSuggestionSenderName api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/merchant_notification_type_resource_keywords.robot

# permission_name=notification.message.approve,notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${1}

*** Test Cases ***
TC_O2O_02026
    [Documentation]     [notification][getSuggestionSenderName] User with notification.registration.approve or notification.message.approve permission can access getSuggestionSenderName API
    [Tags]      Regression     High    Smoke
    Get Suggestion Sender Name    ${type_id}    ${EXIST_O2O_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Or Null    senderName