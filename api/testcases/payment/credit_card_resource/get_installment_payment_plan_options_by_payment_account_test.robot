*** Settings ***
Documentation    Tests to verify API for Get Installment Plan From Omise

Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment/credit_card_resource/get_installment_payment_plan_options_by_payment_account_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
Test Teardown     Delete All Sessions
#Require Wepayment_Client Scope: payment.installmentPlan.read

*** Test Cases ***
TC_O2O_24665
   [Documentation]    [wepayment][app_client_scope] Verify response when request with invalid scope
   [Tags]    Medium    Regression    UnitTest    payment
   [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
   Get Installment Payment Plan Option By Payment Account Id    ${VALID_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${FORBIDDEN_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    payment.internal.forbidden
   Response Should Contain Property With Value    status    ${403}
   Response Should Contain Property With Value    path    /api/v1/credit-card/installment-options/${VALID_PAYMENT_ACCOUNT_ID}
   Response Should Contain Property With Value    message    error.forbidden
   Response Should Contain Property With Value    errors..code     0_access_is_denied
   Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_24666
   [Documentation]    [wepayment][merchant_authority] Verify response when merchant didn't mapping with access app client
   [Tags]    Medium    Regression    UnitTest    payment
   [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_no_authority
   Get Installment Payment Plan Option By Payment Account Id    ${VALID_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${FORBIDDEN_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    payment.internal.forbidden
   Response Should Contain Property With Value    status    ${403}
   Response Should Contain Property With Value    path    /api/v1/credit-card/installment-options/${VALID_PAYMENT_ACCOUNT_ID}
   Response Should Contain Property With Value    message    error.forbidden
   Response Should Contain Property With Value    errors..code     0_access_is_denied
   Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_24667
   [Documentation]    [wepayment][payment_account_status] Verify response when payment_account status is inactive
   [Tags]    Medium    Regression    payment
   Get Installment Payment Plan Option By Payment Account Id    ${INACTIVE_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    External Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/installment-options/${INACTIVE_PAYMENT_ACCOUNT_ID}
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code     0_payment_account_not_active
   Response Should Contain Property With Value    errors..message    Payment Account is inactive

TC_O2O_24668
   [Documentation]    [wepayment][omise_account_status] Verify response when omise_account status is inactive
   [Tags]    Medium    Regression    payment
   Get Installment Payment Plan Option By Payment Account Id    ${INACTIVE_OMISE_ACCOUNT_ID}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    External Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/installment-options/${INACTIVE_OMISE_ACCOUNT_ID}
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code     0_omise_not_active
   Response Should Contain Property With Value    errors..message    Omise Account is inactive

TC_O2O_24669
   [Documentation]    [wepayment][payment_account_status][omise_account_status] Verify response when payment_account and omise_account_status status are inactive
   [Tags]    Medium    Regression    payment
   Get Installment Payment Plan Option By Payment Account Id    ${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}
   Response Correct Code    ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    type    ${API_HOST}/payment
   Response Should Contain Property With Value    title    External Bad Request
   Response Should Contain Property With Value    status    ${400}
   Response Should Contain Property With Value    path    /api/v1/credit-card/installment-options/${INACTIVE_OMISE_AND_PAYMENT_ACCOUNT_ID}
   Response Should Contain Property With Value    message    error.validation
   Response Should Contain Property With Value    errors..code     0_payment_account_not_active
   Response Should Contain Property With Value    errors..message    Payment Account is inactive
