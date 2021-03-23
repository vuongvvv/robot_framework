*** Settings ***
Documentation    Tests to verify that one-time OTP: request OTP api are works correctly

Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/truemoney_wallet_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_onetime_otp
Test Teardown    Delete All Sessions
#Require Client Scope: payment.tmn.otp

*** Test Cases ***
TC_O2O_19057
    [Documentation]    Not allow to request OTP when invalid client scope
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_19092
    [Documentation]    Not allow to request OTP when O2O merchant not found
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "2720","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found

TC_O2O_19093
    [Documentation]    Not allow to request OTP when customer mobile no. not found in TMT  (invalid mobile no.)
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","mobile": "0852221111"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_account
    Response Should Contain Property With Value    errors..message    Tmn account does not exist.

TC_O2O_19094
    [Documentation]    Not allow to request OTP when customer mobile no. is inactive (inactive account)
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","mobile": "0993265326"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_account
    Response Should Contain Property With Value    errors..message    User status does not active.

TC_O2O_19095
    [Documentation]    Not allow to request OTP when access client no merchant authority
    [Tags]    Medium    Regression    Smoke    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${WALLET_MERCHANT_ID} outlet: ${WALLET_ACTIVE_OUTLET}

TC_O2O_19096
    [Documentation]    Not allow to request OTP when tmnClientId is empty
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_TMN_CLIENT_USER}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message    Merchant information is incomplete

TC_O2O_19097
    [Documentation]    Not allow to request OTP when tmnSecret is empty
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_TMN_SECRET_PASSWORD}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message    Merchant information is incomplete

TC_O2O_19098
    [Documentation]    Allow to request OTP when tmnShopId is empty
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_SHOP_ID}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With String Value    linkingAgreement
    Response Should Contain Property With String Value    authCode

TC_O2O_19099
    [Documentation]    Allow to request OTP when tmnShopName is empty
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_SHOP_NAME}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With String Value    linkingAgreement
    Response Should Contain Property With String Value    authCode

TC_O2O_19100
    [Documentation]    Not allow to request OTP when Tmn_merchant_id is empty
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_TMN_MERCHANT_ID}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message    Merchant information is incomplete

TC_O2O_19101
    [Documentation]    Not allow to request OTP when trueyouMerchantId is empty
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${EMPTY}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouMerchantId must not be empty

TC_O2O_19102
    [Documentation]    Not allow to request OTP when trueyouMerchantId is null
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": null,"trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouMerchantId must not be empty

TC_O2O_19103
    [Documentation]    Not allow to request OTP when trueyouOutletId is empty
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${EMPTY}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouOutletId must not be empty

TC_O2O_19104
    [Documentation]    Not allow to request OTP when trueyouOutletId is null
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": null,"mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/request/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouOutletId must not be empty

TC_O2O_20768
    [Documentation]    [Onetime OTP] Allow request OTP when Tmn_onetime_otp_enable flag is empty
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_ONE_TIME_FLAG_EMPTY}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With String Value    linkingAgreement
    Response Should Contain Property With String Value    authCode

TC_O2O_20769
    [Documentation]    [Onetime OTP] Allow request OTP when Tmn_onetime_otp_enable flag is disable
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With String Value    linkingAgreement
    Response Should Contain Property With String Value    authCode
