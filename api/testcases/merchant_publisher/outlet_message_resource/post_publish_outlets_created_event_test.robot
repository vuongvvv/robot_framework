*** Settings ***
Documentation    Tests to verify that publishOutletsCreatedEvent api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/merchant_publisher/outlet_message_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${MERCHANT_PUBLISHER_USERNAME}    ${MERCHANT_PUBLISHER_PASSWORD}    merchantTx.create
Test Teardown     Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_03476
    [Documentation]    [merchant-publisher][publishOutletsCreatedEvent] Request with empty body returns 400
    [Tags]    Regression    Medium    E2E    Sanity    Smoke
    Post Publish Outlets Created Event    ${EMPTY}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With String Value    detail
	Response Should Contain Property With Value     message    error.http.400
	Response Should Contain Property With Value     path    /api/outlets
	Response Should Contain Property With Value     status    ${${BAD_REQUEST_CODE}}
	Response Should Contain Property With Value     title    Bad Request
	Response Should Contain Property With Value     type    https://www.jhipster.tech/problem/problem-with-message