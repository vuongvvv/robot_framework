*** Settings ***
Documentation    Tests to verify API for Inactive 2C2P recurring plan
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    client_id_and_secret=robotautomationclientpayment_creditcard
Test Teardown     Delete All Sessions
#Require Client Scope: payment.recurring.cancel

*** Variables ***
${userDefine1}    RECURRING CANCEL SUCCESS
${userDefine2}    CREATE ACTIVITY BY AUTOMATION SCRIPT
${userDefine3}    NOTE!

*** Test Cases ***
TC_O2O_20017
    [Documentation]    Allow to do cancel recurring when recurring plan is FIXDATE
    [Tags]    Medium    Regression    Smoke    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    FIXDATE
    #Verify Inactive recurring plan before cancel
    Get Merchant Query Recurring Subscription Plan    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    recurringStatus    Y
    Response Should Contain Property With Value    type    FIXDATE
    # END DATA PREPARATION
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REC-CANCEL-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    0
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    ${userDefine1}
    Response Should Contain Property With Value    userDefine2    ${userDefine2}
    Response Should Contain Property With Value    userDefine3    ${userDefine3}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    transaction.recurringRefId
    Response Should Contain Property With Value    transaction.pan    530131XXXXXX0390
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    #Verify Inactive recurring plan after cancel
    Get Merchant Query Recurring Subscription Plan    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    recurringStatus    N
    Response Should Contain Property With Value    type    FIXDATE

TC_O2O_20018
    [Documentation]    Allow to do cancel recurring when recurring plan is INTERVAL
    [Tags]    Medium    Regression    Smoke    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    #Verify Inactive recurring plan before cancel
    Get Merchant Query Recurring Subscription Plan    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    recurringStatus    Y
    Response Should Contain Property With Value    type    INTERVAL
    # END DATA PREPARATION
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REC-CANCEL-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    0
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    ${userDefine1}
    Response Should Contain Property With Value    userDefine2    ${userDefine2}
    Response Should Contain Property With Value    userDefine3    ${userDefine3}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With Value    transaction.gatewayType    2C2P
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    transaction.recurringRefId
    Response Should Contain Property With String Value    transaction.pan
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    #Verify Inactive recurring plan after cancel
    Get Merchant Query Recurring Subscription Plan    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    recurringStatus    N
    Response Should Contain Property With Value    type    INTERVAL

TC_O2O_20020
    [Documentation]    Not allow to cancel recurring when access client has invalid scope
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/cancel
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_20021
    [Documentation]    Not allow to cancel recurring when access client No authority for merchan
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Set Gateway Header With Kms Security Header
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}","userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/cancel
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${2C2P_MERCHANT_ID} outlet: ${2C2P_ACTIVE_OUTLET}
    Response Should Not Contain Property    errors..activityId

TC_O2O_20024
    [Documentation]    Not allow to cancel recurring when recurring transaction status is fail
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Generate Transaction Reference    20
    Get Date With Format And Increment    %d%m%y%y    1 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}
    ...    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "RECURRING-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${reject_credit_card}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}}
    Post Payment Charge By Credit Card
    ...    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "RECURRING-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${reject_credit_card}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&clientRefId.equals=RECURRING-${TRANSACTION_REFERENCE}
    Fetch Property From Response    .transactionId    TRANSACTION_ID
    # END DATA PREPARATION
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/cancel
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recurring_information_not_found
    Response Should Contain Property With Value    errors..message    Recurring information is not found
    Response Should Not Contain Property    errors..activityId

TC_O2O_20025
    [Documentation]    Not allow to cancel recurring when dupplicate clientRefId
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    FIXDATE
    # END DATA PREPARATION
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "RECURRING-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "RECURRING-${TRANSACTION_REFERENCE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/cancel
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_duplicate_transaction
    Response Should Contain Property With Value    errors..message    Duplicate External Transaction
    Response Should Not Contain Property    errors..activityId

TC_O2O_20026
    [Documentation]    Not allow to cancel recurring when input html tag in clientRefId
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "<RECURRING>-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "<RECURRING>-${TRANSACTION_REFERENCE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/cancel
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId The HTML tag are not allowed
    Response Should Not Contain Property    errors..activityId

TC_O2O_20027
    [Documentation]    Not allow to cancel recurring when input clientRefId over 50 digits
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Generate Transaction Reference    45
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/cancel
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId length must be less than or equal to 50
    Response Should Not Contain Property    errors..activityId

TC_O2O_20028
    [Documentation]    Not allow to cancel recurring when input HTML tag in userDefine1
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}","userDefine1": "<${userDefine1}>"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/cancel
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    userDefine1 The HTML tag are not allowed
    Response Should Not Contain Property    errors..activityId

TC_O2O_20029
    [Documentation]    Not allow to cancel recurring when input HTML tag in userDefine2
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}","userDefine2": "<${userDefine2}>"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/cancel
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    userDefine2 The HTML tag are not allowed
    Response Should Not Contain Property    errors..activityId

TC_O2O_20030
    [Documentation]    Not allow to cancel recurring when input HTML tag in userDefine3
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}"}
    Post Cancel 2C2P Recurring Plan    ${TRANSACTION_ID}    {"clientRefId": "REC-CANCEL-${TRANSACTION_REFERENCE}","userDefine2": "${userDefine2}","userDefine3": "<${userDefine3}>"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/cancel
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    userDefine3 The HTML tag are not allowed
    Response Should Not Contain Property    errors..activityId
