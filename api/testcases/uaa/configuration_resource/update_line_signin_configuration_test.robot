*** Settings ***
Documentation    Tests to verify that update line signin configuration api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/configuration_resource_keywords.robot

# scope: uaa.config.write
# permission: uaa.config.write

Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_13574
    [Documentation]    Request with "uaa.config.write" scope and "uaa.config.write" permission and "channelId" is String value and "id" exists on uaa.configuration mongodb returns 200
    [Tags]    Regression    Smoke    UnitTest    High
    Put Update Line Signin Configuration    { "id": "${UAA_LINE_SIGNIN_CONFIGURATION_ID_1}", "channelId": "${UAA_LINE_SIGNIN_CONFIGURATION_ID_1_CHANNEL_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${UAA_LINE_SIGNIN_CONFIGURATION_ID_1}
    Response Should Contain Property With Value    channelId    ${UAA_LINE_SIGNIN_CONFIGURATION_ID_1_CHANNEL_ID}

TC_O2O_13575
    [Documentation]    Request with not exist "id" on uaa.configuration mongodb returns 404
    [Tags]    Regression    Smoke    UnitTest    High
    Set Non Existing Line Signin Configuration
    Put Update Line Signin Configuration    { "id": "${NON_EXISTING_CONFIGURATION_ID}", "channelId": "${UAA_LINE_SIGNIN_CONFIGURATION_ID_1_CHANNEL_ID}" }
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    entityName    configuration
    Response Should Contain Property With Value    errorKey    CONFIGURATION_NOT_FOUND
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Configuration not found
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    message    error.CONFIGURATION_NOT_FOUND
    Response Should Contain Property With Value    params    configuration

TC_O2O_13576
    [Documentation]    Request with "id" on uaa.configuration mongodb is SMS_OTP type returns 404
    [Tags]    Regression    Smoke    UnitTest    High
    Put Update Line Signin Configuration    { "id": "${UAA_SMS_OTP_CONFIGURATION_ID_1}", "channelId": "${UAA_LINE_SIGNIN_CONFIGURATION_ID_1_CHANNEL_ID}" }
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    entityName    configuration
    Response Should Contain Property With Value    errorKey    CONFIGURATION_NOT_FOUND
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Configuration not found
    Response Should Contain Property With Value    status    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    message    error.CONFIGURATION_NOT_FOUND
    Response Should Contain Property With Value    params    configuration