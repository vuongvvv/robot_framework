*** Settings ***
Documentation    Tests to verify that one-time OTP: get mobile list api are works correctly

Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/truemoney_wallet_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_onetime_otp
Test Teardown    Delete All Sessions
#Require Client Scope: payment.wallet.read

*** Test Cases ***
TC_O2O_19246
    [Documentation]    [Onetime OTP] Verify response when query with valid information
    [Tags]    Medium    Regression    payment
    Get Truemoney Wallet List    trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}&clientUsername=TC_O2O_19246
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .authId
    Response Should Contain Property With String Value    .mobile

TC_O2O_19247
    [Documentation]    [Onetime OTP] Verify response when query with invalid trueyouMerchantId
    [Tags]    Medium    Regression    payment
    Get Truemoney Wallet List    trueyouMerchantId=001110000100006&trueyouOutletId=${WALLET_ACTIVE_OUTLET}&clientUsername=TC_O2O_19246
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/wallets
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found

TC_O2O_19248
    [Documentation]    [Onetime OTP] [Onetime OTP] Verify response when query with invalid trueyouOutletId
    [Tags]    Medium    Regression    payment
    Get Truemoney Wallet List    trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=2770&clientUsername=TC_O2O_19246
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/wallets
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found

TC_O2O_19249
    [Documentation]    [Onetime OTP] Verify response when query with invalid clientUsername
    [Tags]    Medium    Regression    payment
    Get Truemoney Wallet List    trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}&clientUsername=TC_O2O_19249
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty

TC_O2O_19250
    [Documentation]    [Onetime OTP] Verify response when access client no merchant authority
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
    Get Truemoney Wallet List    trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}&clientUsername=TC_O2O_19246
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/wallets
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${WALLET_MERCHANT_ID} outlet: ${WALLET_ACTIVE_OUTLET}

TC_O2O_20767
    [Documentation]    [Onetime OTP] Not allow get TMN wallet list when Tmn_onetime_otp_enable flag is disable
    [Tags]    Medium    Regression    Smoke    payment
    Get Truemoney Wallet List    trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}&clientUsername=TC_O2O_20767
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/wallets
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_onetime_OTP_is_disable
    Response Should Contain Property With Value    errors..message    One Time OTP is disable
