*** Settings ***
Documentation    Tests to verify that createOrUpdateClientConfiguration api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/client_configuration_resource_keywords.robot

# scope: uaa.client-config.write    
# permission: uaa.client-config.write
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${testing_client_id}    robotautomationclient

*** Test Cases ***
TC_O2O_13545
    [Documentation]    Requesting with clientId does not exist in UAA returns 404
    [Tags]    Regression    High    UnitTest     ASCO2O-9810
    Post Create Or Update Client Configuration    ${UAA_NOT_EXIST_CLIENT_ID}    ${UAA_SMS_OTP_CONFIGURATION_ID_1}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    entityName    configuration
    Response Should Contain Property With Value    errorKey    CONFIGURATION_NOT_FOUND
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Configuration not found
    Response Should Contain Property With Number Value    status    404
    Response Should Contain Property With Value    message    error.CONFIGURATION_NOT_FOUND
    Response Should Contain Property With Value    params    configuration

TC_O2O_13546
    [Documentation]    Requesting with configurationId does not exist in uaa.configurations mongodb returns 404
    [Tags]    Regression    High    UnitTest
    Post Create Or Update Client Configuration    ${UAA_CLIENT_ID_1}    ${UAA_NOT_EXIST_CONFIGURATION_ID}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    entityName    configuration
    Response Should Contain Property With Value    errorKey    CONFIGURATION_NOT_FOUND
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Configuration not found
    Response Should Contain Property With Number Value    status    404
    Response Should Contain Property With Value    message    error.CONFIGURATION_NOT_FOUND
    Response Should Contain Property With Value    params    configuration

TC_O2O_13547
    [Documentation]    Requesting with 2 different clientId and 1 configurationId returns 200 with 2 different client configurations
    [Tags]    Regression    High    UnitTest
    Post Create Or Update Client Configuration    ${UAA_CLIENT_ID_1}    ${UAA_SMS_OTP_CONFIGURATION_ID_1}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientId    ${UAA_CLIENT_ID_1}
    Response Should Contain Property With Value    smsOtpConfiguration.id    ${UAA_SMS_OTP_CONFIGURATION_ID_1}
    Response Should Contain Property With Value    smsOtpConfiguration.projectId    ${UAA_SMS_OTP_CONFIGURATION_ID_1_PROJECT_ID}
    Response Should Not Contain Property    smsOtpConfiguration.projectPassword
    Response Should Contain Property With Null Value    lineSigninConfiguration
    Post Create Or Update Client Configuration    ${UAA_CLIENT_ID_2}    ${UAA_SMS_OTP_CONFIGURATION_ID_1}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientId    ${UAA_CLIENT_ID_2}
    Response Should Contain Property With Value    smsOtpConfiguration.id    ${UAA_SMS_OTP_CONFIGURATION_ID_1}
    Response Should Contain Property With Value    smsOtpConfiguration.projectId    ${UAA_SMS_OTP_CONFIGURATION_ID_1_PROJECT_ID}
    Response Should Not Contain Property    smsOtpConfiguration.projectPassword
    Response Should Contain Property With Null Value    lineSigninConfiguration

TC_O2O_13548
    [Documentation]    Requesting with 1 clientId and 2 different configurationId with the same SMSOTP type returns 200
    [Tags]    Regression    High    UnitTest
    Post Create Or Update Client Configuration    ${UAA_CLIENT_ID_1}    ${UAA_SMS_OTP_CONFIGURATION_ID_1}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientId    ${UAA_CLIENT_ID_1}
    Response Should Contain Property With Value    smsOtpConfiguration.id    ${UAA_SMS_OTP_CONFIGURATION_ID_1}
    Response Should Contain Property With Value    smsOtpConfiguration.projectId    ${UAA_SMS_OTP_CONFIGURATION_ID_1_PROJECT_ID}
    Response Should Not Contain Property    smsOtpConfiguration.projectPassword
    Response Should Contain Property With Null Value    lineSigninConfiguration
    Post Create Or Update Client Configuration    ${UAA_CLIENT_ID_1}    ${UAA_SMS_OTP_CONFIGURATION_ID_2}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientId    ${UAA_CLIENT_ID_1}
    Response Should Contain Property With Value    smsOtpConfiguration.id    ${UAA_SMS_OTP_CONFIGURATION_ID_2}
    Response Should Contain Property With Value    smsOtpConfiguration.projectId    ${UAA_SMS_OTP_CONFIGURATION_ID_2_PROJECT_ID}
    Response Should Not Contain Property    smsOtpConfiguration.projectPassword
    Response Should Contain Property With Null Value    lineSigninConfiguration

TC_O2O_14286
    [Documentation]    Request to create client configuration with LINE_SIGNIN with clientId already has SMS_OTP config returns 200
    [Tags]    Regression    Smoke    UnitTest    High
    Post Create Or Update Client Configuration  ${testing_client_id}  ${UAA_SMS_OTP_CONFIGURATION_ID_1}
    Post Create Or Update Client Configuration  ${testing_client_id}  ${UAA_LINE_SIGNIN_CONFIGURATION_ID_1}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientId    ${testing_client_id}
    Response Should Contain Property With Value    smsOtpConfiguration.id    ${UAA_SMS_OTP_CONFIGURATION_ID_1}
    Response Should Contain Property With Value    smsOtpConfiguration.projectId    ${UAA_SMS_OTP_CONFIGURATION_ID_1_PROJECT_ID}
    Response Should Not Contain Property    smsOtpConfiguration.projectPassword
    Response Should Contain Property With Value    lineSigninConfiguration.id    ${UAA_LINE_SIGNIN_CONFIGURATION_ID_1}
    Response Should Contain Property With Value    lineSigninConfiguration.channelId    ${UAA_LINE_SIGNIN_CONFIGURATION_ID_1_CHANNEL_ID}

TC_O2O_14287
    [Documentation]    Request to create client configuration with LINE_SIGNIN without clientId already has SMS_OTP config returns 200
    [Tags]    Regression    Smoke    UnitTest    High
    Post Create Or Update Client Configuration  ${testing_client_id}  ${UAA_LINE_SIGNIN_CONFIGURATION_ID_1}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    clientId    ${testing_client_id}
    Response Should Contain Property With String Value    smsOtpConfiguration.id
    Response Should Contain Property With Number String    smsOtpConfiguration.projectId
    Response Should Contain Property With Value    lineSigninConfiguration.id    ${UAA_LINE_SIGNIN_CONFIGURATION_ID_1}
    Response Should Contain Property With Value    lineSigninConfiguration.channelId    ${UAA_LINE_SIGNIN_CONFIGURATION_ID_1_CHANNEL_ID}