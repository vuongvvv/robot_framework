*** Settings ***
Documentation    Tests to verify that one-time OTP: Refund OTP api are works correctly

Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/truemoney_wallet_resource_keywords.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_onetime_otp
Test Teardown    Delete All Sessions
#Require Client Scope: payment.tmn.refund

*** Test Cases ***
TC_O2O_19182
    [Documentation]    [Onetime OTP] Allow to full refund when refund and charge within the same day (VOID)
    [Tags]    Medium    Regression    payment
    Prepare The Charge Transaction For Refund
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"VOID-${TRANSACTION_REFERENCE}","amount":"${amount}","userDefine1":"REGRESSION FOR REFUND","userDefine2":"AUTOMATION SCRIPT GENERATE","userDefine3":"ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    VOID-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    REGRESSION FOR REFUND
    Response Should Contain Property With Value    userDefine2    AUTOMATION SCRIPT GENERATE
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    REFUND
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19183
    [Documentation]    [Onetime OTP] Not allow to partial refund when refund and charge within the same day
    [Tags]    Medium    Regression    payment
    Prepare The Charge Transaction For Refund
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"VOID-${TRANSACTION_REFERENCE}","amount":"100","userDefine1":"REGRESSION FOR REFUND","userDefine2":"AUTOMATION SCRIPT GENERATE","userDefine3":"ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_partial_refund_error
    Response Should Contain Property With Value    errors..message    Partial refund is not allowed when payment is in cancel window.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_19186
    [Documentation]    [Onetime OTP] Not allow to refund when the transaction already full refund success
    [Tags]    Medium    Regression    payment
    Prepare The Charge Transaction For Refund
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"V01-${TRANSACTION_REFERENCE}","amount":"${amount}","userDefine1":"REGRESSION FOR REFUND","userDefine2":"AUTOMATION SCRIPT GENERATE","userDefine3":"ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"V02-${TRANSACTION_REFERENCE}","amount":"${amount}","userDefine1":"REGRESSION FOR REFUND","userDefine2":"AUTOMATION SCRIPT GENERATE","userDefine3":"ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_insufficient_fund
    Response Should Contain Property With Value    errors..message    Charge amount is not enough.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_19189
    [Documentation]    [Onetime OTP] Not allow to refund when input clientRefId over 50 charactors
    [Tags]    Medium    Regression    payment
    Prepare The Charge Transaction For Refund
    Generate Transaction Reference    46
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"VOID-${TRANSACTION_REFERENCE}","amount":"${amount}","userDefine1":"REGRESSION FOR REFUND","userDefine2":"AUTOMATION SCRIPT GENERATE","userDefine3":"ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId length must be less than or equal to 50
    Response Should Not Contain Property    errors..activityId

TC_O2O_19190
    [Documentation]    [Onetime OTP] Not allow to refund when input dupplicate clientRefId
    [Tags]    Medium    Regression    payment
    Prepare The Charge Transaction For Refund
    Generate Transaction Reference    46
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"VOID-DUPPLICATE","amount":"${amount}","userDefine1":"REGRESSION FOR REFUND","userDefine2":"AUTOMATION SCRIPT GENERATE","userDefine3":"ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_duplicate_transaction
    Response Should Contain Property With Value    errors..message    Duplicate External Transaction
    Response Should Not Contain Property    errors..activityId

TC_O2O_19191
    [Documentation]    [Onetime OTP] Not allow to refund when transaction not found
    [Tags]    Medium    Regression    payment
    Prepare The Charge Transaction For Refund
    Generate Transaction Reference    46
    Post Refund With Truemoney Wallet    invalid_transaction_id    {"clientRefId":"VOID-DUPPLICATE","amount":"${amount}","userDefine1":"REGRESSION FOR REFUND","userDefine2":"AUTOMATION SCRIPT GENERATE","userDefine3":"ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments/invalid_transaction_id/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_found
    Response Should Contain Property With Value    errors..message    Transaction Not Found
    Response Should Not Contain Property    errors..activityId

TC_O2O_19192
    [Documentation]    [Onetime OTP] Not allow to refund when transaction payment_method is credit_card
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_creditcard
    [Tags]    Medium    Regression    Smoke    payment
    Prepare The Charge Transaction
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"VOID-${TRANSACTION_ID}","amount":"${amount}","userDefine1":"REGRESSION FOR REFUND","userDefine2":"AUTOMATION SCRIPT GENERATE","userDefine3":"ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    1_invalid_payment_id
    Response Should Contain Property With Value    errors..message    Payment id does not exist.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_19845
    [Documentation]    [Onetime OTP] Not allow to refund when input html tag in clientRefId
    [Tags]    Medium    Regression    payment
    Prepare The Charge Transaction For Refund
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"<VOID>-${TRANSACTION_REFERENCE}","amount":"100","userDefine1":"REGRESSION FOR REFUND","userDefine2":"AUTOMATION SCRIPT GENERATE","userDefine3":"ONE TIME OTP EPIC"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/truemoney/payments/${TRANSACTION_ID}/refund
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId The HTML tag are not allowed
    Response Should Not Contain Property    errors..activityId
