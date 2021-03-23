*** Settings ***
Documentation    Tests to verify that the merchant APIs is working properly
...              as expected. There are 4 methods that supported.
...              GET: Get the merchants profile
...              POST: Create new merchants profile
...              PUT: Update the merchants profile
...              DELETE: Delete the merchants profile
Resource        ../../../resources/init.robot
Resource        ../../../keywords/merchant/merchant_register_merchant_keywords.robot
Resource        ../../../keywords/merchant/merchant_register_outlet_keywords.robot
Suite Setup     Prepare Test Suite Data
Test Setup      Generate Access Token    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
Test Teardown   Delete All Sessions

*** Variables ***
${invalid_merchant_id}      5b2364e9960c51000647b2e1
${merchant_type}            INDIVIDUAL
${merchant_invalid_type}    INDIVIDUAL123
${merchant_name}            test-name
${new_merchant_name}        test-name-new
${merchant_status}          ACTIVE
${merchant_invalid_status}  INACTIVE123
${invalid_token_error}      invalid_token
${forbidden_title}          Forbidden
${bad_request_title}        Bad Request
${organization_code}        TRUEYOU
${deleted_status}           DELETED
${merchant_th_display}      ใช
${merchant_en_display}      test

*** Keywords ***
Create Valid Merchant
    Create Merchant Profile   ${merchant_type}     ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Get Created ID
    Set Suite Variable        ${valid_merchant_id}    ${get_id}

Prepare Test Suite Data
    Generate Access Token    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
    Create Valid Merchant

*** Test Cases ***
TC_O2O_01078
    [Documentation]    [Merchant] Get all merchants information with the valid request
    [Tags]    Merchant    Regression    High
    Get All Merchants Profile
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_01080
    [Documentation]    [Merchant] Get merchant information by an ID with the valid request
    [Tags]    Merchant    Regression    High
    Get Merchant Profile By Merchant ID       ${valid_merchant_id}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_01082
    [Documentation]    [Merchant] Get merchant information by the invalid ID
    [Tags]    Merchant    Regression    High
    [Setup]    Generate Access Token    ${O2O_MERCHANT_USERNAME}      ${O2O_MERCHANT_PASSWORD}
    Get Merchant Profile By Merchant ID      ${invalid_merchant_id}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}

TC_O2O_01070
    [Documentation]    [Merchant] Create the new merchant profile with all valid information & default ORG that using is TRUEYOU
    [Tags]    Merchant    Regression    High
    Create Merchant Profile    ${merchant_type}     ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value    organizationCode    ${organization_code}

TC_O2O_01072
    [Documentation]    [Merchant] Create the new merchant profile successful & default outlet created automatically
    [Tags]    Merchant    Regression    High
    Create Merchant Profile    ${merchant_type}     ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Get All Outlet Profile     ${created_merchant_id}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value    .name   ${merchant_name}

TC_O2O_01074
    [Documentation]    [Merchant] Create new merchant with the empty type
    [Tags]    Merchant    Regression    High
    Create Merchant Profile    ${EMPTY}     ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}

TC_O2O_01075
    [Documentation]    [Merchant] Create new merchant with an invalid type
    [Tags]    Merchant    Regression    High
    Create Merchant Profile   ${merchant_invalid_type}     ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}

TC_O2O_01076
    [Documentation]    [Merchant] Create new merchant with the empty status
    [Tags]    Merchant    Regression    High
    Create Merchant Profile    ${merchant_type}     ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${EMPTY}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}

TC_O2O_01077
    [Documentation]    [Merchant] Create new merchant with an invalid status
    [Tags]    Merchant    Regression    High
    Create Merchant Profile     ${merchant_type}     ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_invalid_status}
    Response Correct Code       ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}

TC_O2O_01083
    [Documentation]    [Merchant] Delete the merchants successful by changing the status to "DELETED"
    [Tags]    Merchant    Regression    High
    Delete Merchant Profile By Merchant ID      ${valid_merchant_id}
    Response Correct Code       ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    ${deleted_status}
    [Teardown]    Update Merchant Profile By Merchant ID      ${valid_merchant_id}    ${merchant_type}    ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}

TC_O2O_01085
    [Documentation]    [Merchant] Delete the merchants by an invalid ID
    [Tags]    Merchant    Regression    High
    [Setup]    Generate Access Token    ${O2O_MERCHANT_USERNAME}      ${O2O_MERCHANT_PASSWORD}
    Delete Merchant Profile By Merchant ID      ${invalid_merchant_id}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}

TC_O2O_01086
    [Documentation]    [Merchant] Update the merchant successful profile by an ID
    [Tags]    Merchant    Regression    High
    Update Merchant Profile By Merchant ID      ${valid_merchant_id}    ${merchant_type}    ${new_merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    ${new_merchant_name}
    [Teardown]    Update Merchant Profile By Merchant ID      ${valid_merchant_id}    ${merchant_type}    ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}

TC_O2O_01088
    [Documentation]    [Merchant] Update the merchant profile by an invalid ID
    [Tags]    Merchant    Regression    Medium
    Update Merchant Profile By Merchant ID      ${invalid_merchant_id}    ${merchant_type}    ${new_merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}

TC_O2O_01089
    [Documentation]    [Merchant] Update the merchant profile by an invalid status
    [Tags]    Merchant    Regression    Medium
    Update Merchant Profile By Merchant ID      ${invalid_merchant_id}    ${merchant_type}    ${new_merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_invalid_status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}

TC_O2O_01073
    [Documentation]    [Merchant] Create the new merchant with the invalid token
    [Tags]    Merchant    Regression    Medium
    Create Merchant Profile With Invalid Token    ${merchant_type}    ${merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Response Correct Code      ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_01079
    [Documentation]    [Merchant] Get merchant information by the invalid token
    [Tags]    Merchant    Regression    Medium
    Get All Merchants With Invalid Token
    Response Correct Code      ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_01081
    [Documentation]    [Merchant] Get merchant information by ID with the invalid token
    [Tags]    Merchant    Regression    Medium
    Get Merchant ID With Invalid Token      ${valid_merchant_id}
    Response Correct Code      ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_01084
    [Documentation]    [Merchant] Delete the merchants with the invalid token
    [Tags]    Merchant    Regression    Medium
    Delete Merchant ID With Invalid Token      ${valid_merchant_id}
    Response Correct Code      ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_01087
    [Documentation]    [Merchant] Update the merchant profile by ID with the invalid token
    [Tags]    Merchant    Regression    Medium
    Update Merchant ID With Invalid Token      ${valid_merchant_id}    ${merchant_type}    ${new_merchant_name}    ${merchant_th_display}   ${merchant_en_display}   ${merchant_status}
    Response Correct Code      ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}
