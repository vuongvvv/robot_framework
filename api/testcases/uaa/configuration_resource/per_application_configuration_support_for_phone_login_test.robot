*** Settings ***
Documentation    User can create, update OTP configuration, Per application configuration and request OTP, and validate OTP APIs works correctly with the created OTP configuration
...    EPIC LINK: https://truemoney.atlassian.net/browse/ASCO2O-8104
...    EPIC NAME: [UAA] Per-application configuration support for phone login

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/client_configuration_resource_keywords.robot
Resource    ../../../keywords/uaa/signin_resource_keywords.robot
Resource    ../../../keywords/eggdigital/eggdigital_keywords.robot
Resource    ../../../keywords/uaa/account_resource_keywords.robot

# scope: uaa.client-config.write,signin.sms-otp,account.update
# permission: uaa.client-config.write
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_13700
    [Documentation]     [UAA] User can create, update OTP configuration, Per application configuration and request OTP, and validate OTP APIs works correctly with the created OTP configuration
    [Tags]    Regression     High    SmokeExclude    E2EExclude
    Post Create Or Update Client Configuration    ${TEST NAME}    ${UAA_CONFIGURATION_VALID_PROJECT_ID_AND_PASSWORD_FOR_EGGDIGITAL}
    Response Correct Code    ${SUCCESS_CODE}
    Post Generate Signin Sms Otp    { "msisdn": "${MOBILE_NUMBER_OF_USER_IPHONEX}" }
    Response Correct Code    ${SUCCESS_CODE}
    signin_resource_keywords.Fetch Reference And Transaction Id From Egg Digital
    Fetch Otp Code    ${MOBILE_NUMBER_OF_USER_IPHONEX}    ${TEST_DATA_TRANSACTION_ID_FROM_EGG_DIGITAL}
    Post Validate Sms Signin Otp    { "msisdn": "${MOBILE_NUMBER_OF_USER_IPHONEX}", "otp": "${TEST_DATA_OTP_FROM_EGGDIGITAL}", "reference": "${TEST_DATA_REFERENCE_ID_FROM_EGG_DIGITAL}", "transactionId": "${TEST_DATA_TRANSACTION_ID_FROM_EGG_DIGITAL}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    scope    uaa.client-config.write signin.sms-otp account.update
    Generate Not Existing Phone Number On Uaa
    Post Request Change Mobile Phone    { "msisdn": "${TEST_DATA_NOT_EXISTING_PHONE_NUMBER_ON_UAA}" }
    account_resource_keywords.Fetch Reference And Transaction Id From Egg Digital
    Fetch Otp Code    ${TEST_DATA_NOT_EXISTING_PHONE_NUMBER_ON_UAA}    ${TEST_DATA_TRANSACTION_ID_FROM_EGG_DIGITAL}
    Post Verify Otp For Change Mobile Phone    { "msisdn": "${TEST_DATA_NOT_EXISTING_PHONE_NUMBER_ON_UAA}", "otp": "${TEST_DATA_OTP_FROM_EGGDIGITAL}", "reference": "${TEST_DATA_REFERENCE_ID_FROM_EGG_DIGITAL}", "transactionId": "${TEST_DATA_TRANSACTION_ID_FROM_EGG_DIGITAL}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    mobile    ${TEST_DATA_NOT_EXISTING_PHONE_NUMBER_ON_UAA}