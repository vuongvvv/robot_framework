*** Settings ***
Documentation    Tests to verify API for update recurring plan
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    client_id_and_secret=robotautomationclientpayment_creditcard
Test Teardown     Delete All Sessions
#Require Client Scope: payment.recurring.update

*** Variables ***
${external_ref_id_length}    20
${update_recurring_interval}    5
${update_recurring_amount}    4810000
${update_recurring_count}    8
${update_accumulate_max_amount}    9620000
${userDefine1}    RECURRING UPDATE SUCCESS
${userDefine2}    CREATE BY AUTOMATION SCRIPT
${userDefine3}    NOTE!

*** Test Cases ***
TC_O2O_19981
    [Documentation]    Allow to update recurring when update the valid information from recurring plan interval to interval
    [Tags]    Medium    Regression    Smoke    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REC-UPDATE-${TRANSACTION_REFERENCE}
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
    Response Should Contain Property With Value    recurring.type    INTERVAL
    Response Should Contain Property With Value    recurring.interval.recurringInterval    ${update_recurring_interval}
    Response Should Contain Property With Value    recurring.interval.chargeNextDate    ${DESIRED_DATE}
    Response Should Not Contain Property    recurring.fixDate.chargeOnDate
    Response Should Contain Property With Value    recurring.recurringAmount    ${update_recurring_amount}
    Response Should Contain Property With Value    recurring.recurringCount    ${update_recurring_count}
    Response Should Contain Property With Value    recurring.accumulateMaxAmount    ${update_accumulate_max_amount}
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19982
    [Documentation]    Not allow to update recurring when update the valid information from recurring plan fixdate to interval
    [Tags]    Medium    Regression    Smoke    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    FIXDATE
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recurring_type_is_unavailable
    Response Should Contain Property With Value    errors..message    Update recurring type is unavailable
    Response Should Not Contain Property    errors..activityId

TC_O2O_19983
    [Documentation]    Not allow to update recurring when update the valid information from recurring plan interval to fixdate
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m    1 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${update_recurring_amount}","recurringCount": "${update_recurring_count}","accumulateMaxAmount": "${update_accumulate_max_amount}"}}
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${update_recurring_amount}","recurringCount": "${update_recurring_count}","accumulateMaxAmount": "${update_accumulate_max_amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recurring_type_is_unavailable
    Response Should Contain Property With Value    errors..message    Update recurring type is unavailable
    Response Should Not Contain Property    errors..activityId

TC_O2O_19984
    [Documentation]    Not allow to update recurring when update the valid information from recurring plan fixdate to fixdate
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    FIXDATE
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m    15 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${update_recurring_amount}","recurringCount": "${update_recurring_count}","accumulateMaxAmount": "${update_accumulate_max_amount}"}}
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${update_recurring_amount}","recurringCount": "${update_recurring_count}","accumulateMaxAmount": "${update_accumulate_max_amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recurring_type_is_unavailable
    Response Should Contain Property With Value    errors..message    Update recurring type is unavailable
    Response Should Not Contain Property    errors..activityId

TC_O2O_19985
    [Documentation]    Not allow to update recurring when access client has invalid scope
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    Get Date With Format And Increment    %d%m%y%y    5 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_19987
    [Documentation]    Not allow to update recurring when No authority for merchant
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    3_bad_request
    Response Should Contain Property With Value    errors..message    No authority for merchant: ${SCB_MERCHANT_ID} outlet: ${SCB_ACTIVE_OUTLET}
    Response Should Not Contain Property    errors..activityId

TC_O2O_19990
    [Documentation]    Not allow to update recurring when CHARGE_SUBSCRIPTION transaction is fail
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Generate Transaction Reference    ${external_ref_id_length}
    Get Date With Format And Increment    %d%m%y%y    1 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}
    ...    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "RECURRING-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${reject_credit_card}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}}
    Post Payment Charge By Credit Card
    ...    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "RECURRING-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${reject_credit_card}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&clientRefId.equals=RECURRING-${TRANSACTION_REFERENCE}
    Fetch Property From Response    .transactionId    TRANSACTION_ID
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_no_authority
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recurring_information_not_found
    Response Should Contain Property With Value    errors..message    Recurring information is not found
    Response Should Not Contain Property    errors..activityId

TC_O2O_19991
    [Documentation]    Not allow to update recurring when dupplicate clientRefId
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": "RECURRING-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "RECURRING-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_duplicate_transaction
    Response Should Contain Property With Value    errors..message    Duplicate External Transaction
    Response Should Not Contain Property    errors..activityId

TC_O2O_19992
    [Documentation]    Not allow to update recurring when input html tag in clientRefId
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": "<RECURRING>-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "<RECURRING>-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId The HTML tag are not allowed
    Response Should Not Contain Property    errors..activityId

TC_O2O_19993
    [Documentation]    Not allow to update recurring when transaction_id not found
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    ${external_ref_id_length}
    Get Date With Format And Increment    %d%m%y%y    5 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "INVALID","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    INVALID
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/INVALID/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_found
    Response Should Contain Property With Value    errors..message    Transaction Not Found
    Response Should Not Contain Property    errors..activityId

TC_O2O_19995
    [Documentation]    Not allow to update recurring when clientRefId is empty
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": "","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_19996
    [Documentation]    Not allow to update recurring when clientRefId is null
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": null,"recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": null,"recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    clientRefId must not be empty
    Response Should Not Contain Property    errors..activityId

TC_O2O_19997
    [Documentation]    Allow to update recurring when chargeNextDate is less than today
    [Tags]    Medium    Regression    Smoke    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    -3 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    REC-UPDATE-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    0
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Null Value    userDefine1
    Response Should Contain Property With Null Value    userDefine2
    Response Should Contain Property With Null Value    userDefine3
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
    Response Should Contain Property With Value    recurring.type    INTERVAL
    Response Should Contain Property With Value    recurring.interval.recurringInterval    ${update_recurring_interval}
    Response Should Contain Property With Value    recurring.interval.chargeNextDate    ${DESIRED_DATE}
    Response Should Not Contain Property    recurring.fixDate.chargeOnDate
    Response Should Contain Property With Value    recurring.recurringAmount    ${update_recurring_amount}
    Response Should Contain Property With Value    recurring.recurringCount    ${update_recurring_count}
    Response Should Contain Property With Value    recurring.accumulateMaxAmount    ${update_accumulate_max_amount}
    Response Should Contain Property With Null Value    wpCardId

TC_O2O_19999
    [Documentation]    Not allow to update recurring when input recurringInterval not in 1-365
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": 366,"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": 366,"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": ${update_accumulate_max_amount}},"userDefine1": "${userDefine1}","userDefine2": "${userDefine2}","userDefine3": "${userDefine3}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.externalService
    Response Should Contain Property With Value    errors..code    2_11
    Response Should Contain Property With Value    errors..message    Invalid 'recurringInterval' value.
    Response Should Contain Property With String Value    errors..activityId

TC_O2O_20000
    [Documentation]    Not allow to update recurring when input recurringCount less than 0
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": "-1","accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": "-1","accumulateMaxAmount": ${update_accumulate_max_amount}}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    recurring.recurringCount is invalid.
    Response Should Not Contain Property    errors..activityId

TC_O2O_20001
    [Documentation]    Not allow to update recurring when input accumulateMaxAmount less than 0
    [Tags]    Medium    Regression    payment
    # START DATA PREPARATION
    Prepare The Transaction With Select Recurring Type    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    INTERVAL
    # END DATA PREPARATION
    Get Date With Format And Increment    %d%m%y%y    5 day
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","transactionId": "${TRANSACTION_ID}","clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": "-1"}}
    Set Gateway Header With Kms Security Header
    Post Update 2C2P Recurring Plan    ${TRANSACTION_ID}
    ...    {"clientRefId": "REC-UPDATE-${TRANSACTION_REFERENCE}","recurring": {"type": "INTERVAL","interval": {"recurringInterval": ${update_recurringInterval},"chargeNextDate": "${DESIRED_DATE}" },"recurringAmount": ${update_recurring_amount},"recurringCount": ${update_recurring_count},"accumulateMaxAmount": "-1"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    recurring.accumulateMaxAmount is invalid.
    Response Should Not Contain Property    errors..activityId
