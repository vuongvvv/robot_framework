*** Settings ***
Documentation    Tests to verify that linkAccount api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../../web/resources/init.robot
Resource    ../../../keywords/uaa/configuration_resource_keywords.robot
Resource    ../../../keywords/uaa/client_configuration_resource_keywords.robot
Resource    ../../../keywords/common/line_access_common.robot
Resource    ../../../keywords/uaa/account_resource_keywords.robot
Resource    ../../../keywords/common/database_common.robot
Resource    ../../../../web/keywords/line_access/login_keyword.robot

# scope=account.update,signin.line,uaa.config.write,uaa.client-config.write
# permission_name=uaa.config.write,uaa.client-config.write
Test Setup    Run Keywords    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
...    AND    Create Line Access Session
Test Teardown     Delete All Sessions

*** Variables ***
${provider_id}    line
${client_id}    robotautomationclient

*** Test Cases ***
#Remove Link Account API should be done to make this test passed
TC_O2O_15187
    [Documentation]     Request with LINE id token is valid and LINE uid not exist on O2O-UAA and O2O-UAA account not link with another LINE account returns 201
    [Tags]      Regression     High    SmokeExclude
    # Create Line Signin configuration
    Post Create Line Signin Configuration    { "channelId": "${valid_line_channel_id}" }
    Fetch Configuration Id From Response Body
    #Create Line Client Configuration
    Post Create Or Update Client Configuration    ${client_id}    ${TEST_DATA_CONFIGURATION_ID}
    Get Line Token Id    ${line_email}    ${line_password}
    #Call linkAccount API
    Post Link Account    ${provider_id}    { "providerToken": "${LINE_ID_TOKEN}" }
    #Verify the response
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Number String    userId
    Response Should Contain Property With Value    providerId    ${provider_id}
    Response Should Contain Property With String Value    providerUserId

#Remove Link Account API should be done to make this test passed
TC_O2O_15188
    [Documentation]    Request with O2O-UAA account link with another LINE account returns 400
    [Tags]      Regression     High    SmokeExclude
    # Create Line Signin configuration
    Post Create Line Signin Configuration    { "channelId": "${valid_line_channel_id}" }
    Fetch Configuration Id From Response Body
    #Create Line Client Configuration
    Post Create Or Update Client Configuration    ${client_id}    ${TEST_DATA_CONFIGURATION_ID}
    Get Line Token Id    ${line_email}    ${line_password}
    Post Link Account    ${provider_id}    { "providerToken": "${LINE_ID_TOKEN}" }
    #Get LINE id token
    Get Line Token Id    ${line_email_1}    ${line_password_1}
    Post Link Account    ${provider_id}    { "providerToken": "${LINE_ID_TOKEN}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    message    error.ACCOUNT_ALREADY_LINKED_WITH_LINE

TC_O2O_15189
    [Documentation]    Request with LINE uid exists on O2O-UAA returns 400
    [Tags]      Regression     High    Smoke    uaa    line
    # Create Line Signin configuration
    Post Create Line Signin Configuration    { "channelId": "${valid_line_channel_id}" }
    Fetch Configuration Id From Response Body
    #Create Line Client Configuration
    Post Create Or Update Client Configuration    ${client_id}    ${TEST_DATA_CONFIGURATION_ID}
    Get Line Token Id    ${line_email}    ${line_password}
    Post Link Account    ${provider_id}    { "providerToken": "${LINE_ID_TOKEN}" }
    Post Link Account    ${provider_id}    { "providerToken": "${LINE_ID_TOKEN}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    message    error.LINE_ACCOUNT_ALREADY_USED