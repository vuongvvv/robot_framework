*** Settings ***
Documentation    Tests to verify that activateAccount api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/account_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${wrong_activation_key}    wrongActivationKey

*** Test Cases ***
TC_O2O_07840
    [Documentation]     [uaa][activateAccount] Request with wrong activation key returns 500
    [Tags]      Regression     Medium    Smoke
    Get Activate Account    ${wrong_activation_key}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
	Response Should Contain Property With Value     type    http://www.jhipster.tech/problem/problem-with-message
	Response Should Contain Property With Value     title    No user was found for this reset key
	Response Should Contain Property With Value     status    ${${INTERNAL_SERVER_CODE}}
	Response Should Contain Property With Value     message    error.null
	Response Should Contain Property With Empty Value    params