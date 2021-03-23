*** Settings ***
Documentation    Tests to verify that deleteOAuthClientDetails api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/oauth_client_details_keywords.robot

Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    
Test Teardown     Delete All Sessions

*** Variables ***
${client_id}    13881

*** Test Cases ***
TC_O2O_00389
    [Documentation]     Verify non-admin user can not DELETE any row from “OAuth Client Details”  via api so that when the user call delete {url}/uaa/api/oauth-client-details/{id} , the response should be 403 Forbidden.
    [Tags]      Regression     Medium    Smoke
    Delete OAuth Client Details    ${client_id}
    Response Correct Code    ${FORBIDDEN_CODE}
	Response Should Contain Property With Value     type    http://www.jhipster.tech/problem/problem-with-message
	Response Should Contain Property With Value     title    Forbidden
	Response Should Contain Property With Value     status    ${${FORBIDDEN_CODE}}
	Response Should Contain Property With Value     detail    Access is denied
	Response Should Contain Property With Value     path    /api/oauth-client-details/${client_id}
	Response Should Contain Property With Value     message    error.http.403