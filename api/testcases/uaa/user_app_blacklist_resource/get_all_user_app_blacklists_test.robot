*** Settings ***
Documentation    Tests to verify that getAllUserAppBlacklists api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_app_blacklist_resource_keywords.robot

# permission: uaa.user-app-blacklist.actAsAdmin
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Variables ***
${regex_id}                 ^\\d+$
${regex_date}               ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d+Z$

*** Test Cases ***
TC_O2O_02678
    [Documentation]     [uaa][getAllUserAppBlacklists] Displayed all blacklist accounts - Admin Permission
    [Tags]      Regression     Blacklist     Admin     Medium        UAA    E2E
    Get All User App Blacklists
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Match Regex    .id     ${regex_id}
    Response Should Contain All Property Values Match Regex    .revocationDate    ${regex_date}
    Response Should Contain All Property Values Are Integer    .userId
    Response Should Contain All Property Values Are Number Or Null    .clientId