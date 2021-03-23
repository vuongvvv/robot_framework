*** Settings ***
Documentation    Tests to verify that signInWithLineIdToken api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../../web/resources/init.robot
Resource    ../../../keywords/uaa/configuration_resource_keywords.robot
Resource    ../../../keywords/uaa/client_configuration_resource_keywords.robot
Resource    ../../../keywords/common/line_access_common.robot
Resource    ../../../keywords/uaa/social_resource_keywords.robot
Resource    ../../../../web/keywords/line_access/login_keyword.robot

# scope:signin.line,uaa.config.write,uaa.client-config.write    
# permission: uaa.config.write,uaa.client-config.write
Test Setup    Run Keywords    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}        
...    AND    Create Line Access Session
Test Teardown     Delete All Sessions

*** Variables ***
${testing_client_id}    robotautomationclient

*** Test Cases ***
TC_O2O_14435
    [Documentation]     Request with "signin.line" scope & Logging clientId match with LINE_SIGNIN client configuration exists on uaa.client_configurations MongoDb & LINE id token is valid & LINE UID not link to O2O-UAA account & no existing O2O-UAA account can be linked return 200
    [Tags]      Regression     High    Smoke    uaa    line
    # Create Line Signin configuration
    Post Create Line Signin Configuration    { "channelId": "${valid_line_channel_id}" }
    Fetch Configuration Id From Response Body
    #Create Line Client Configuration
    Post Create Or Update Client Configuration    ${testing_client_id}    ${TEST_DATA_CONFIGURATION_ID}
    Get Line Token Id    ${line_email}    ${line_password}
    #Call signInWithLineIdToken api
    Post Sign In With Line Id Token    { "idToken": "${LINE_ID_TOKEN}" }
    #Verify the response
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    scope

TC_O2O_14436
    [Documentation]     Request with LINE UID already link to O2O-UAA account return 200
    [Tags]      Regression     High    Smoke    uaa    line
    # Create Line Signin configuration
    Post Create Line Signin Configuration    { "channelId": "${valid_line_channel_id}" }
    Fetch Configuration Id From Response Body
    #Create Line Client Configuration
    Post Create Or Update Client Configuration    ${testing_client_id}    ${TEST_DATA_CONFIGURATION_ID}
    Get Line Token Id    ${line_email}    ${line_password}
    #Call signInWithLineIdToken api
    Post Sign In With Line Id Token    { "idToken": "${LINE_ID_TOKEN}" }
    Post Sign In With Line Id Token    { "idToken": "${LINE_ID_TOKEN}" }
    #Verify the response
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    scope