*** Settings ***
Documentation    Tests to verify that one-time OTP: verify OTP api are works correctly

Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/truemoney_wallet_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_onetime_otp
Test Teardown    Delete All Sessions
#Require Client Scope: payment.tmn.otp

*** Variables ***
@{validate_mobile_empty}    mobile must not be empty    mobile Invalid Format: Mobile No. must be in 10 digit

*** Test Cases ***
TC_O2O_19139
    [Documentation]    Not allow to verify OTP when trueyouMerchantId is empty
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19139","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouMerchantId must not be empty

TC_O2O_19140
    [Documentation]    Not allow to verify OTP when trueyouMerchantId is null
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": null,"trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19140","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouMerchantId must not be empty

TC_O2O_19141
    [Documentation]    Not allow to verify OTP when trueyouOutletId is empty
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "","clientUsername": "TC_O2O_19141","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouOutletId must not be empty

TC_O2O_19142
    [Documentation]    Not allow to verify OTP when trueyouOutletId is null
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": null,"clientUsername": "TC_O2O_19142","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouOutletId must not be empty

TC_O2O_19143
    [Documentation]    Not allow to verify OTP when clientUsername is empty and store is false
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientUsername must not be empty

TC_O2O_19144
    [Documentation]    Not allow to verify OTP when clientUsername is null and store is false
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": null,"mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientUsername must not be empty

TC_O2O_19145
    [Documentation]    Not allow to verify OTP when clientUsername is empty and store is true
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientUsername must not be empty

TC_O2O_19146
    [Documentation]    Not allow to verify OTP when clientUsername is null and store is true
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": null,"mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientUsername must not be empty

TC_O2O_19147
    [Documentation]    Not allow to verify OTP when mobile is empty
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19147","mobile": "","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property Value Include In List    errors..message    ${validate_mobile_empty}

TC_O2O_19148
    [Documentation]    Not allow to verify OTP when mobile is null
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19148","mobile": null,"store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    mobile must not be empty

TC_O2O_19149
    [Documentation]    Not allow to verify OTP when mobile is invalid (unmatched OTP request)
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19149","mobile": "0610095616","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_otp
    Response Should Contain Property With Value    errors..message    The requested otp is invalid.

TC_O2O_19150
    [Documentation]    Not allow to verify OTP when mobile format is invalid
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19150","mobile": "66610090735","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    mobile Invalid Format: Mobile No. must be in 10 digit

TC_O2O_19151
    [Documentation]    Not allow to input store flag by upper case
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19151","mobile": "${TMN_WALLET_MOBILE}","store": "TRUE","otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With String Value    detail
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.http.400

TC_O2O_19152
    [Documentation]    Verify default store flag should be false when input flag=null
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19152","mobile": "${TMN_WALLET_MOBILE}","store": null,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    paymentCode

TC_O2O_19153
    [Documentation]    Not allow to verify OTP when otpRef is empty
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19153","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    otpRef must not be empty

TC_O2O_19154
    [Documentation]    Not allow to verify OTP when otpRef is invalid
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19154","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "INVL","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_otp
    Response Should Contain Property With Value    errors..message    The requested otp is invalid.

TC_O2O_19155
    [Documentation]    Not allow to verify OTP when otpCode is empty
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19155","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    otpCode must not be empty

TC_O2O_19156
    [Documentation]    Not allow to verify OTP when otpCode is invalid
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19156","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "111110","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_otp
    Response Should Contain Property With Value    errors..message    The requested otp is invalid.

TC_O2O_19157
    [Documentation]    Not allow to verify OTP when authCode is empty
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19157","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": ""}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    authCode must not be empty

TC_O2O_19158
    [Documentation]    Not allow to verify OTP when authCode is invalid
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19158","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "ccb0d01c114552dbde83b14a8e0efc1a"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_auth_code
    Response Should Contain Property With Value    errors..message    The requested auth code is invalid.

TC_O2O_19160
    [Documentation]    Not allow to verify OTP when O2O merchant not found
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "2700","clientUsername": "TC_O2O_19160","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found

TC_O2O_19161
    [Documentation]    Not allow to verify OTP when tmnClientId is empty in O2O merchant
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_TMN_CLIENT_USER}","clientUsername": "TC_O2O_19161","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message    Merchant information is incomplete

TC_O2O_19162
    [Documentation]    Not allow to verify OTP when tmnSecret is empty in O2O merchant
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_TMN_SECRET_PASSWORD}","clientUsername": "TC_O2O_19162","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message    Merchant information is incomplete

TC_O2O_19163
    [Documentation]    Allow to verify OTP when tmnShopId is empty in O2O merchant
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_SHOP_ID}","clientUsername": "TC_O2O_19163","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    authId

TC_O2O_19164
    [Documentation]    Allow to verify OTP when tmnShopName is empty in O2O merchant
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_SHOP_NAME}","clientUsername": "TC_O2O_19164","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    authId

TC_O2O_19165
    [Documentation]    Not allow to verify OTP when Tmn_merchant_id is empty in O2O merchant
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_TMN_MERCHANT_ID}","clientUsername": "TC_O2O_19165","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message    Merchant information is incomplete

TC_O2O_19166
    [Documentation]    Not allow to verify OTP when tmnClientId is invalid in O2O merchant
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_TMN_CLIENT}","clientUsername": "TC_O2O_19166","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_client
    Response Should Contain Property With Value    errors..message    The requested client is invalid.

TC_O2O_19167
    [Documentation]    Allow to verify OTP when tmnSecret is invalid in O2O merchant
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_TMN_SECRET_PASS}","clientUsername": "TC_O2O_19167","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    authId

TC_O2O_19173
    [Documentation]    Allow to verify OTP when Tmn_shop_id is invalid
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_SHOP_ID}","clientUsername": "TC_O2O_19173","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    paymentCode

TC_O2O_19174
    [Documentation]    Allow to verify OTP when Tmn_merchant_id is invalid
    [Tags]    Medium    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_TMN_MERCHANT_ID}","clientUsername": "TC_O2O_19174","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    authId

TC_O2O_20770
    [Documentation]    [Onetime OTP] Not allow to verify when Tmn_onetime_otp_enable flag is empty and store flag is true
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information    ${WALLET_MERCHANT_ID}    ${WALLET_OUTLET_ONE_TIME_FLAG_EMPTY}
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_ONE_TIME_FLAG_EMPTY}","clientUsername": "TC_O2O_20770","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_onetime_OTP_is_disable
    Response Should Contain Property With Value    errors..message    One Time OTP is disable

TC_O2O_20771
    [Documentation]    [Onetime OTP] Not allow to verify when Tmn_onetime_otp_enable flag is disable and store flag is true
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information    ${WALLET_MERCHANT_ID}    ${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}","clientUsername": "TC_O2O_20771","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/verify/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_onetime_OTP_is_disable
    Response Should Contain Property With Value    errors..message    One Time OTP is disable

TC_O2O_20772
    [Documentation]    [Onetime OTP] Allow to verify when Tmn_onetime_otp_enable flag is empty and store flag is false
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information    ${WALLET_MERCHANT_ID}    ${WALLET_OUTLET_ONE_TIME_FLAG_EMPTY}
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_ONE_TIME_FLAG_EMPTY}","clientUsername": "TC_O2O_20772","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    paymentCode

TC_O2O_20773
    [Documentation]    [Onetime OTP] Allow to verify when Tmn_onetime_otp_enable flag is disable and store flag is false
    [Tags]    Medium    Regression    Smoke    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information    ${WALLET_MERCHANT_ID}    ${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}","clientUsername": "TC_O2O_20773","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    paymentCode

TC_O2O_19168
    [Documentation]    [Onetime OTP] Allow to verify when Tmn_onetime_otp_enable flag is enable and store flag is true
    [Tags]    Low    Regression    payment
    Post Request Otp From Truemoney Wallet And Get Reference Information    ${WALLET_MERCHANT_ID}    ${WALLET_ACTIVE_OUTLET}
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "TC_O2O_19168","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    authId
