*** Settings ***
Documentation    User can create configuration, client configuration and push notification message successfully

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/push_notification_configuration_resource_keywords.robot
Resource    ../../../keywords/notification/platform_push_notification_resource_keywords.robot

# scope=notification.push.create,push-notification.configuration.write,notification.push.register,push-notification.configuration.read
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Run Keywords    Delete Push Client    ${NOTIFICATION_WE_PLATFORM_PROJECT_ID}    ${TEST_DATA_PUSH_NOTIFICATION_CLIENTS_ID}
...    AND    Delete Push Notification Configuration    ${NOTIFICATION_WE_PLATFORM_PROJECT_ID}    ${TEST_DATA_PUSH_NOTIFICATION_CONFIGURATIONS_ID}
...    AND    Delete Created Client And User Group
...    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_13999
    [Documentation]     User can create configuration, client configuration and push notification message successfully
    [Tags]    Regression     High    Smoke
	Post Create Push Notification Configuration    ${NOTIFICATION_WE_PLATFORM_PROJECT_ID}    { "application": "${TEST NAME}", "firebaseProject": { "projectId": "${NOTIFICATION_FIREBASE_PROJECT_ID}", "serviceKey": "${NOTIFICATION_FIREBASE_SERVICE_KEY}" } }
	Response Correct Code    ${CREATED_CODE}
	Fetch Push Notification Configurations Id
	Get All Push Notification Configurations    ${NOTIFICATION_WE_PLATFORM_PROJECT_ID}
	Response Correct Code    ${SUCCESS_CODE}
	Post Create Push Client    ${NOTIFICATION_WE_PLATFORM_PROJECT_ID}    { "application": "${TEST NAME}", "deviceId": "${NOTIFICATION_ANDROID_DEVICE_ID}", "platform": "ANDROID", "token": "${NOTIFICATION_CLOUD_MESSAGE_TOKEN}", "username": "${ROLE_USER}" }
	Response Correct Code    ${CREATED_CODE}
	Fetch Push Notification Clients Id
	Get Current User Registrations    ${NOTIFICATION_WE_PLATFORM_PROJECT_ID}
	Response Correct Code    ${SUCCESS_CODE}	
	Post Push Notification    ${NOTIFICATION_WE_PLATFORM_PROJECT_ID}    { "channel": "${TEST NAME}", "message": "PUSH_NOTIFICATION_AUTOMATION_TEST", "payload": { "merchantName": "PUSH_NOTIFICATION_AUTOMATION_TEST", "merchantNo": "123456789" }, "title": "WELCOME", "username": "${ROLE_USER}" }
	Response Correct Code    ${ACCEPTED_CODE}