*** Settings ***
Documentation    Tests to verify that getUserAppBlacklist api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/user_app_blacklist_resource_keywords.robot

# permission: uaa.user-app-blacklist.actAsAdmin
Test Setup    Run Keywords    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
...    AND    Get Blacklist Id
Test Teardown     Delete All Sessions

*** Variables ***
${regex_date}               ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d+Z$

*** Test Cases ***
TC_O2O_02685
    [Documentation]    [uaa][getUserAppBlacklist] Displayed blacklist details - Admin Permission
    [Tags]      Regression     Blacklist     Admin     Medium        UAA      Getblacklist    Smoke
    Get User App Blacklist    ${BLACKLIST_ID}
    Response Correct Code                           ${SUCCESS_CODE}
	Response Should Contain Property With Number String     clientId
	Response Should Contain Property With String Value     createdBy
	Response Should Contain Property Matches Regex     createdDate    ${regex_date}
	Response Should Contain Property With Value    id    ${BLACKLIST_ID}
	Response Should Contain Property With String Value     lastModifiedBy
	Response Should Contain Property Matches Regex     lastModifiedDate    ${regex_date}
	Response Should Contain Property Matches Regex     revocationDate    ${regex_date}
	Response Should Contain Property With Number String     userId