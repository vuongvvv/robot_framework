*** Settings ***
Documentation    Tests to verify that updateMerchantNotificationStatus api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification/merchant_notification_type_resource_keywords.robot

# permission_name=notification.registration.approve
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_USERNAME}    ${NOTIFICATION_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${type_id}    ${1}

*** Test Cases ***
TC_O2O_01310
    [Documentation]    API Update Status - To verify that API will returns error when send API without body
    [Tags]    Regression    High    UnitTest    Smoke
    Put Update Merchant Notification Status    ${type_id}    ${EXIST_O2O_MERCHANT_ID}    ${EMPTY}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    Bad Request
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/types/${type_id}/merchants/${EXIST_O2O_MERCHANT_ID}/update-status
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message