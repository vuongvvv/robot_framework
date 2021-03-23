*** Settings ***
Documentation    Tests to verify that updateOAuthClientDetails api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/oauth_client_details_keywords.robot

Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_00387
    [Documentation]     Verify non-admin user can not UPDATE any row into “OAuth Client Details” via api  so that when the user call put {url}/uaa/api/oauth-client-details/{id} , the response should be 403 Forbidden.
    [Tags]      Regression     Medium    Smoke
    Put Update OAuth Client Details    { "id": 13881, "clientId": "robot_automation_client", "name": "robot_automation_client", "resourceIds": null, "clientSecret": "robot_automation_client", "scope": "DEFAULT", "scopeValues": {}, "authorizedGrantTypes": "password", "webServerRedirectUri": null, "authorities": null, "accessTokenValidity": 300, "refreshTokenValidity": 604800, "additionalInformation": null, "autoApprove": true, "grantTypeList": [ "password" ], "owner": null, "description": null }
    Response Correct Code    ${FORBIDDEN_CODE}
	Response Should Contain Property With Value     type    http://www.jhipster.tech/problem/problem-with-message
	Response Should Contain Property With Value     title    Forbidden
	Response Should Contain Property With Value     status    ${${FORBIDDEN_CODE}}
	Response Should Contain Property With Value     detail    Access is denied
	Response Should Contain Property With Value     path    /api/oauth-client-details
	Response Should Contain Property With Value     message    error.http.403