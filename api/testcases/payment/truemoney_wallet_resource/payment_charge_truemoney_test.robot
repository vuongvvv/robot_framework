*** Settings ***
Documentation    Tests to verify that one-time OTP: Charge OTP api are works correctly

Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/truemoney_wallet_resource_keywords.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_onetime_otp
Test Teardown    Delete All Sessions
#Require Client Scope: payment.tmn.charge

*** Test Cases ***
TC_O2O_19203
    [Documentation]    [Onetime OTP] Allow to charge when input valid payment_code
    [Tags]    Medium    Regression    payment
    Prepare Paymentcode For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    1TOTP-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REGRESSION TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19204
    [Documentation]    [Onetime OTP] Allow to charge when input valid auth_code
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    1TOTP-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REGRESSION TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19205
    [Documentation]    [Onetime OTP] Not allow to charge when authId is not found in database
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${invalid_auth_id}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Not Found
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.internal
    Response Should Contain Property With Value    errors..code    0_auth_id_not_found
    Response Should Contain Property With Value    errors..message    Auth Id Not Found
    Response Should Not Contain Property    errors..activityId

TC_O2O_19213
    [Documentation]    [Onetime OTP] Not allow to charge when payment_code already used
    [Tags]    Medium    Regression    payment
    Prepare Paymentcode For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "2TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_payment_code
    Response Should Contain Property With Value    errors..message    Payment code has been used or expired.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_19214
    [Documentation]    [Onetime OTP] Not allow to charge when payment_code is invalid
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${invalid_payment_code}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_payment_code
    Response Should Contain Property With Value    errors..message    Payment code has been used or expired.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_19215
    [Documentation]    [Onetime OTP] Not allow to charge when payment_code and auth_id is null
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": null,"authId": null,"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    paymentCode or authId is required
    Response Should Not Contain Property    errors..activityId

TC_O2O_19216
    [Documentation]    [Onetime OTP] Not allow to charge when payment_code and auth_id is empty
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "","authId": "","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    paymentCode or authId is required
    Response Should Not Contain Property    errors..activityId

TC_O2O_19217
    [Documentation]    [Onetime OTP] Not allow to charge when input payment_code and auth_id within the same request
    [Tags]    Medium    Regression    Smoke    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${invalid_payment_code}","authId": "${invalid_auth_id}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    paymentCode and authId can't request at the same time
    Response Should Not Contain Property    errors..activityId

TC_O2O_19218
    [Documentation]    [Onetime OTP] Not allow to charge when input payment_code into auth_id field
    [Tags]    Medium    Regression    payment
    Prepare Paymentcode For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Not Found
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.internal
    Response Should Contain Property With Value    errors..code    0_auth_id_not_found
    Response Should Contain Property With Value    errors..message    Auth Id Not Found
    Response Should Not Contain Property    errors..activityId

TC_O2O_19219
    [Documentation]    [Onetime OTP] Not allow to charge when input auth_id into payment_code field
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_payment_code
    Response Should Contain Property With Value    errors..message    Payment code has been used or expired.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_19220
    [Documentation]    [Onetime OTP] Not allow to charge when trueyouMerchantId is empty
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouMerchantId must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_19221
    [Documentation]    [Onetime OTP] Not allow to charge when trueyouOutletId is empty
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouOutletId must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_19222
    [Documentation]    [Onetime OTP] Not allow to charge when clientRefId is empty
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_19223
    [Documentation]    [Onetime OTP] Not allow to charge when amount is empty
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property Value Include In List    errors..message    ${validate_amount_empty}
    Response Should Not Contain Property    errors..activityId

TC_O2O_19224
    [Documentation]    [Onetime OTP] Not allow to charge when paymentMethod is empty
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    paymentMethod must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_19225
    [Documentation]    [Onetime OTP] Not allow to charge when currency is empty
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    currency must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_19226
    [Documentation]    [Onetime OTP] Not allow to charge when payment_method is not wallet
    [Tags]    Medium    Regression    Smoke    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "CREDIT_CARD","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_not_support
    Response Should Contain Property With Value    errors..message    Not support payment method
    Response Should Not Contain Property    errors..activityId

TC_O2O_19227
    [Documentation]    [Onetime OTP] Not allow to charge when input payment_method in lower case
    [Tags]    Medium    Regression    Smoke    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "wallet","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_not_support
    Response Should Contain Property With Value    errors..message    Not support payment method
    Response Should Not Contain Property    errors..activityId

TC_O2O_19228
    [Documentation]    [Onetime OTP] Not allow to charge when currency not in THB
    [Tags]    Medium    Regression    Smoke    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "wallet","currency": "CNY","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    currency Currency is invalid.
    Response Should Not Contain Property    errors..activityId

TC_O2O_19229
    [Documentation]    [Onetime OTP] Not allow to charge when amount with invalid format (.xx)
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "450.01","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    amount Amount is invalid.
    Response Should Not Contain Property    errors..activityId
#
TC_O2O_19230
    [Documentation]    [Onetime OTP] Not allow to charge when dupplicate client_ref
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "1TOTP-DUPP0001","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_duplicate_transaction
    Response Should Contain Property With Value    errors..message    Duplicate External Transaction
    Response Should Not Contain Property    errors..activityId

TC_O2O_19231
    [Documentation]    [Onetime OTP] Allow to charge when input valid payment_code
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${invalid_payment_code}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "2770","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    Data not found
    Response Should Not Contain Property    errors..activityId

TC_O2O_19232
    [Documentation]    [Onetime OTP] Not allow to charge when not found Tmn_client_id in O2O merchant
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${invalid_payment_code}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_TMN_CLIENT_USER}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message   Merchant information is incomplete
    Response Should Not Contain Property    errors..activityId

TC_O2O_19233
    [Documentation]    [Onetime OTP] Not allow to charge when not found Tmn_client_secret in O2O merchant
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${invalid_payment_code}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_TMN_SECRET_PASSWORD}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message   Merchant information is incomplete
    Response Should Not Contain Property    errors..activityId

TC_O2O_19234
    [Documentation]    [Onetime OTP] Allow to charge when not found Tmn_shop_id in O2O merchant
    [Tags]    Medium    Regression    payment
    Prepare Paymentcode For Charge Activity    ${WALLET_MERCHANT_ID}    ${WALLET_OUTLET_NO_SHOP_ID}
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_SHOP_ID}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    1TOTP-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Null Value    userDefine1
    Response Should Contain Property With Null Value    userDefine2
    Response Should Contain Property With Null Value    userDefine3
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_OUTLET_NO_SHOP_ID}
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19235
    [Documentation]    [Onetime OTP] Allow to charge when not found Tmn_shop_name in O2O merchant
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Request Otp From Truemoney Wallet And Get Reference Information    ${WALLET_MERCHANT_ID}    ${WALLET_OUTLET_NO_SHOP_NAME}
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_SHOP_NAME}","clientUsername": "AUTO_PREPARE","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Get PaymentCode From Truemoney
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_SHOP_NAME}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    1TOTP-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REGRESSION TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_OUTLET_NO_SHOP_NAME}
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19236
    [Documentation]    [Onetime OTP] Not allow to charge when Tmn_merchant_id is empty in O2O merchant
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${invalid_payment_code}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_NO_TMN_MERCHANT_ID}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_merchant_info_incomplete
    Response Should Contain Property With Value    errors..message   Merchant information is incomplete
    Response Should Not Contain Property    errors..activityId

TC_O2O_19238
    [Documentation]    [Onetime OTP] Allow to charge with valid payment_code when the input merchant has invalid Tmn_client_id and access_token not expire
    [Tags]    Medium    Regression    Smoke    payment
    Prepare Paymentcode For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_TMN_CLIENT}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    1TOTP-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REGRESSION TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_OUTLET_INVALID_TMN_CLIENT}
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19239
    [Documentation]    [Onetime OTP] Allow to charge with valid auth_id when the input merchant has invalid  Tmn_client_secret and access_token not expire
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_TMN_SECRET_PASS}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    1TOTP-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REGRESSION TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_OUTLET_INVALID_TMN_SECRET_PASS}
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19240
    [Documentation]    [Onetime OTP] Allow to charge with valid payment_code when the input merchant has invalid Tmn_client_secret and access_token not expire
    [Tags]    Medium    Regression    payment
    Prepare Paymentcode For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_TMN_SECRET_PASS}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    1TOTP-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REGRESSION TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_OUTLET_INVALID_TMN_SECRET_PASS}
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_20282
    [Documentation]    [Onetime OTP] Not allow to charge when not own merchant auth_id
    [Tags]    Medium    Regression    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_TMN_CLIENT}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.internal
    Response Should Contain Property With Value    errors..code    0_authId_invalid
    Response Should Contain Property With Value    errors..message    Auth Id is not valid for this merchant

TC_O2O_20824
    [Documentation]     [Onetime OTP] Not allow to charge when Tmn_shop_id is not match with tmn_portal and valid auth_id
    [Tags]    Medium    Regression    Smoke    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_SHOP_ID}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SERVICE_UNAVAILABLE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Service Error
    Response Should Contain Property With Value    status    ${503}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_service_unavailable
    Response Should Contain Property With Value    errors..message    Service Unavailable.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_20825
    [Documentation]     [Onetime OTP] Not allow to charge when Tmn_shop_id is not match with tmn_portal and valid payment_code
    [Tags]    Medium    Regression    Smoke    payment
    Prepare Paymentcode For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_INVALID_SHOP_ID}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SERVICE_UNAVAILABLE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Service Error
    Response Should Contain Property With Value    status    ${503}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_service_unavailable
    Response Should Contain Property With Value    errors..message    Service Unavailable.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_20758
    [Documentation]     [Onetime OTP] Not allow to charge by auth_id when Tmn_onetime_otp_enable flag is empty
    [Tags]    Medium    Regression    Smoke    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_ONE_TIME_FLAG_EMPTY}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_onetime_OTP_is_disable
    Response Should Contain Property With Value    errors..message    One Time OTP is disable
    Response Should Not Contain Property    errors..activityId

TC_O2O_20759
    [Documentation]     [Onetime OTP] Not allow to charge by auth_id when Tmn_onetime_otp_enable flag is disable
    [Tags]    Medium    Regression    Smoke    payment
    Prepare Auth Id For Charge Activity
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_onetime_OTP_is_disable
    Response Should Contain Property With Value    errors..message    One Time OTP is disable
    Response Should Not Contain Property    errors..activityId

TC_O2O_21093
    [Documentation]    [Onetime OTP] Allow to charge by payment_code when Tmn_onetime_otp_enable flag is disable
    [Tags]    Medium    Regression    Smoke    payment
    Prepare Paymentcode For Charge Activity    ${WALLET_MERCHANT_ID}    ${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}","clientRefId": "1TOTP-${TRANSACTION_REFERENCE}","amount": "${amount}","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REGRESSION TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    1TOTP-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REGRESSION TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
