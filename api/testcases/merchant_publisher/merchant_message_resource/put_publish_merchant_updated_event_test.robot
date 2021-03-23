*** Settings ***
Documentation    Tests to verify that publishMerchantUpdatedEvent api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/merchant_publisher/merchant_message_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${MERCHANT_PUBLISHER_USERNAME}    ${MERCHANT_PUBLISHER_PASSWORD}    merchantTx.create
Test Teardown     Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_08544
    [Documentation]    [merchant-publisher][publishMerchantUpdatedEvent] Request with empty body returns 400
    [Tags]    Regression    Medium    E2E    Sanity    Smoke
    Put Publish Merchant Updated Event    RPP_OUTLET_APPROVE    ${EMPTY}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With String Value    detail
	Response Should Contain Property With Value     message    error.http.400
	Response Should Contain Property With Value     path    /api/merchants
	Response Should Contain Property With Value     status    ${${BAD_REQUEST_CODE}}
	Response Should Contain Property With Value     title    Bad Request
	Response Should Contain Property With Value     type    https://www.jhipster.tech/problem/problem-with-message