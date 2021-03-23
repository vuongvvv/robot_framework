*** Settings ***
Documentation    Tests to verify that one-time OTP: Delete mobile list api are works correctly

Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/truemoney_wallet_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_onetime_otp
Test Teardown    Delete All Sessions
#Require Client Scope: payment.wallet.delete

*** Test Cases ***
TC_O2O_19253
    [Documentation]    [Onetime OTP] Allow to delete auth_id when input valid auth_id and merchant information
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Get Auth Id From Truemoney
    Delete Truemoney Wallet List    ${AUTH_ID}    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body

TC_O2O_19254
    [Documentation]    [Onetime OTP] Not allow to delete auth_id when input invalid auth_id
    [Tags]    Medium    Regression    payment
    Delete Truemoney Wallet List    ${invalid_auth_id}    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}"}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Not Found
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/truemoney/wallets/${invalid_auth_id}
    Response Should Contain Property With Value    message    error.internal
    Response Should Contain Property With Value    errors..code    0_auth_id_not_found
    Response Should Contain Property With Value    errors..message    Auth Id Not Found

TC_O2O_19255
    [Documentation]    [Onetime OTP] Not allow to delete auth_id when input  valid auth_id but invalid trueyouMerchantId
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Get Auth Id From Truemoney
    Delete Truemoney Wallet List    ${AUTH_ID}    {"trueyouMerchantId": "001110000100006","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/wallets/${AUTH_ID}
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found

TC_O2O_19256
    [Documentation]    [Onetime OTP] Not allow to delete auth_id when input  valid auth_id but invalid trueyouOutletId
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Get Auth Id From Truemoney
    Delete Truemoney Wallet List    ${AUTH_ID}    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "2770"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/wallets/${AUTH_ID}
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found

TC_O2O_19257
    [Documentation]    [Onetime OTP] Not allow to delete auth_id when access client no merchant authority
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
    Delete Truemoney Wallet List    ${invalid_auth_id}    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/wallets/${invalid_auth_id}
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${WALLET_MERCHANT_ID} outlet: ${WALLET_ACTIVE_OUTLET}

TC_O2O_19251
    [Documentation]    [Onetime OTP] Verify response when access with invalid client scope
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    Delete Truemoney Wallet List    ${invalid_auth_id}    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/v1/truemoney/wallets/${invalid_auth_id}
    Response Should Contain Property With Value    message    error.http.403
