*** Settings ***
Documentation    Tests to verify that getQuotaRemaining api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/quota_resource_keywords.robot

# permission_name=notification.type.get
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${1}

*** Test Cases ***
TC_O2O_01206
    [Documentation]    [notification][getQuotaRemaining] User with notification.type.list, notification.type.get, or notification.type.quotaUpdate permission can access the api
    [Tags]    Regression    High    UnitTest    Smoke
    Get Quota Remaining    ${type_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number String    remaining
    Response Should Contain Property With String Value    typeName