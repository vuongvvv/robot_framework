*** Settings ***
Documentation    Tests to verify that the outlet APIs is working properly
...              as expected. There are 4 methods that supported.
...              GET: Get the outlets profile
...              POST: Create new outlets profile
...              PUT: Update the outlets profile
...              DELETE: Delete the outlets profile
Resource         ../../../resources/init.robot
Resource         ../../../keywords/merchant/merchant_register_outlet_keywords.robot
Resource         ../../../keywords/merchant/merchant_register_merchant_keywords.robot
Suite Setup      Prepare Test Suite Data
Test Setup       Generate Access Token    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
${invalid_merchant_id}      5b2364e9960c51000647b2e1
${forbidden_title}          Forbidden
${deleted_status}           DELETED
${outlet_headQuarter}       true
${outlet_name}              outletName123a
${new_outlet_name}          outletNameNew
${outlet_status}            ACTIVE
${invalid-outlet_status}    ACTIVE123
${invalid_token_error}      invalid_token
${merchant_th_display}      ใช
${merchant_en_display}      test
${merchant_type}            INDIVIDUAL
${merchant_name}            test-name
${merchant_status}          INACTIVE
${bad_request_title}        Bad Request

*** Keywords ***
Create Valid Merchant And Outlet
    Create Merchant Profile   ${merchant_type}     ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Get Created ID
    Set Suite Variable        ${valid_merchant_id}    ${get_id}
    Create Outlet Profile     ${valid_merchant_id}     ${outlet_headQuarter}    ${outlet_name}        ${outlet_status}
    Get Created ID
    Set Suite Variable        ${valid_outlet_id}    ${get_id}

Prepare Test Suite Data
    Generate Access Token    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
    Create Valid Merchant And Outlet

*** Test Cases ***
TC_O2O_01050
    [Documentation]    [Outlet] Create new outlets information successful with the valid request
    [Tags]    Merchant    Regression    High
    Create Outlet Profile    ${valid_merchant_id}     ${outlet_headQuarter}    ${outlet_name}        ${outlet_status}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    merchantId    ${valid_merchant_id}
    Response Should Contain Property With Value    name          ${outlet_name}

TC_O2O_01051
    [Documentation]    [Outlet] Create new outlets information with the invalid status
    [Tags]    Merchant    Regression    Medium
    Create Outlet Profile    ${valid_merchant_id}     ${outlet_headQuarter}    ${outlet_name}        ${invalid-outlet_status}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title        ${bad_request_title}

TC_O2O_01054
    [Documentation]    [Outlet] Create new outlets information with the merchant not found
    [Tags]    Merchant    Regression    Medium
    Create Outlet Profile      ${invalid_merchant_id}     ${outlet_headQuarter}    ${outlet_name}        ${outlet_status}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}

TC_O2O_01055
    [Documentation]    [Outlet] Update the outlet profile by merchant ID
    [Tags]    Merchant    Regression    High
    Update Outlet Profile By Merchant ID      ${valid_merchant_id}    ${valid_outlet_id}    ${outlet_headQuarter}    ${new_outlet_name}        ${outlet_status}
    Response Should Contain Property With Value    merchantId    ${valid_merchant_id}
    Response Should Contain Property With Value    name          ${new_outlet_name}
    [Teardown]    Update Outlet Profile By Merchant ID      ${valid_merchant_id}    ${valid_outlet_id}    ${outlet_headQuarter}    ${outlet_name}        ${outlet_status}

TC_O2O_01060
    [Documentation]    [Outlet] Get outlets information with the valid merchant ID
    [Tags]    Merchant    Regression    High
    Get All Outlet Profile   ${valid_merchant_id}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_01062
    [Documentation]    [Outlet] Get outlets information with the invalid merchant ID
    [Tags]    Merchant    Regression    Medium
    Get All Outlet Profile      ${invalid_merchant_id}
    Response Correct Code       ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}

TC_O2O_01064
    [Documentation]    [Outlet] Get outlets information by the ID
    [Tags]    Merchant    Regression    High
    Get Outlet Profile By ID    ${valid_merchant_id}        ${valid_outlet_id}
    Response Correct Code       ${SUCCESS_CODE}
    Response Should Contain Property With Value    merchantId    ${valid_merchant_id}
    Response Should Contain Property With Value    id            ${valid_outlet_id}
    Response Should Contain Property With Value    name          ${outlet_name}

TC_O2O_01066
    [Documentation]    [Outlet] Delete outlets profile successful by changing the status to "DELETED"
    [Tags]    Merchant    Regression    High
    Delete Outlet Profile By ID    ${valid_merchant_id}        ${valid_outlet_id}
    Response Correct Code          ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    ${deleted_status}
    [Teardown]    Update Outlet Profile By Merchant ID      ${valid_merchant_id}    ${valid_outlet_id}    ${outlet_headQuarter}    ${outlet_name}        ${outlet_status}

TC_O2O_01068
    [Documentation]    [Outlet] Delete outlets profile with unavailable merchant ID
    [Tags]    Merchant    Regression    Medium
    Delete Outlet Profile By ID    ${invalid_merchant_id}        ${valid_outlet_id}
    Response Correct Code          ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}

TC_O2O_01069
    [Documentation]    [Outlet] Delete outlets profile with the invalid token
    [Tags]    Merchant    Regression    Medium
    Delete Outlet ID With Invalid Token    ${valid_merchant_id}        ${valid_outlet_id}
    Response Correct Code          ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_01058
    [Documentation]    [Outlet] Update the outlet with the invalid token
    [Tags]    Merchant    Regression    Medium
    Update Outlet ID With Invalid Token      ${valid_merchant_id}    ${valid_outlet_id}    ${outlet_headQuarter}    ${new_outlet_name}        ${outlet_status}
    Response Correct Code       ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_01053
    [Documentation]    [Outlet] Create new outlets information with the invalid token
    [Tags]    Merchant    Regression    Medium
    Create Outlet With Invalid Token       ${valid_merchant_id}     ${outlet_headQuarter}    ${outlet_name}        ${outlet_status}
    Response Correct Code       ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}
