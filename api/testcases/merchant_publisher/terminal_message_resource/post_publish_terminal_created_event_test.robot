*** Settings ***
Documentation    Tests to verify that publishTerminalCreatedEvent api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/merchant_publisher/terminal_message_resource_keywords.robot

# scope: merchantTx.create
Test Setup    Generate Robot Automation Header    ${MERCHANT_PUBLISHER_USERNAME}    ${MERCHANT_PUBLISHER_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_03502
    [Documentation]    [merchant-publisher][publishTerminalCreatedEvent] Request with empty body returns 400
    [Tags]    Regression    Medium    Smoke
    Post Publish Terminal Created Event    RPP_OUTLET_APPROVE    ${EMPTY}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With String Value    detail
	Response Should Contain Property With Value     message    error.http.400
	Response Should Contain Property With Value     path    /api/terminals
	Response Should Contain Property With Value     status    ${${BAD_REQUEST_CODE}}
	Response Should Contain Property With Value     title    Bad Request
	Response Should Contain Property With Value     type    https://www.jhipster.tech/problem/problem-with-message