*** Settings ***
Documentation    Tests to verify that recipient API - delete recipient api works correctly

Resource    ../../../../resources/init.robot
Resource    ../../../../keywords/payment/payment_account_resource/recipient_management_keyword.robot
Resource    ../../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
Test Teardown    Delete All Sessions
#Require Wepayment Client Scope: payment.recipient.delete

*** Test Cases ***
TC_O2O_25157
    [Documentation]    [Delete recipients] Verify response when request with invalid payment account id
    [Tags]    Medium    Regression    payment
    Prepare Recipient Id
    Delete Recipients From Payment Account    INVALID    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/payment-account/INVALID/recipient/${O2O_RECIPIPIENT_ID}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_found
    Response Should Contain Property With Value    errors..message    Payment Account Not Found

TC_O2O_25158
    [Documentation]    [Delete recipients] Verify response when request with invalid recipient id
    [Tags]    Medium    Regression    payment
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    INVALID
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient/INVALID
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recipient_not_found
    Response Should Contain Property With Value    errors..message    Recipient not found

TC_O2O_25159
    [Documentation]    [Delete recipients] Verify response when payment account status is inactive
    [Tags]    Medium    Regression    payment
    Prepare Recipient Id
    Delete Recipients From Payment Account    ${INACTIVE_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${INACTIVE_PAYMENT_ACCOUNT_ID}/recipient/${O2O_RECIPIPIENT_ID}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_active
    Response Should Contain Property With Value    errors..message    Payment Account is inactive

TC_O2O_25161
    [Documentation]    [Delete recipients][merchant authority] Verify response when no merchant authority
    [Tags]    Medium    Regression    payment
    Prepare Recipient Id
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_no_authority
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient/${O2O_RECIPIPIENT_ID}
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_25162
    [Documentation]    [Delete recipients][app client scope] Verify response when request with invalid client scope
    [Tags]    Medium    Regression    payment
    Prepare Recipient Id
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient/${O2O_RECIPIPIENT_ID}
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_25167
    [Documentation]    [Delete recipients] Verify response when marked_to_delete status is true
    [Tags]    Medium    Regression    payment
    Prepare Recipient Id
    #Start Get existing recipient and destroy
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body
    #End Pre-step
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient/${O2O_RECIPIPIENT_ID}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recipient_not_found
    Response Should Contain Property With Value    errors..message    Recipient not found

TC_O2O_26453
    [Documentation]    [Delete recipients] [wepayment app_client] Not allow to delete recipients when not found app client in wePayment
    [Tags]    Medium    Regression    payment
    Prepare Recipient Id
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_onetime_otp
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.unauthorized
    Response Should Contain Property With Value    status    ${401}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient/${O2O_RECIPIPIENT_ID}
    Response Should Contain Property With Value    message    error.unauthorized
    Response Should Contain Property With Value    errors..code    0_unauthorized
    Response Should Contain Property With Value    errors..message    unauthorized
