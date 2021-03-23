*** Settings ***
Documentation    Tests to verify 2C2P payment merchant query recurring history
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_creditcard
Test Teardown     Delete All Sessions
#Require Client Scope: payment.recurring.read

*** Variables ***
${external_ref_id_length}    20
@{recurring_status}    SETTLED    SUCCESS
@{recurring_transaction_list}   8dkwGVkAk4WPAWY9ZuE3QLFI200001    8dkwGVkAk4WPAWY9ZuE3QLFI200002    8dkwGVkAk4WPAWY9ZuE3QLFI200003    8dkwGVkAk4WPAWY9ZuE3QLFI200004    8dkwGVkAk4WPAWY9ZuE3QLFI200005    8dkwGVkAk4WPAWY9ZuE3QLFI200006    8dkwGVkAk4WPAWY9ZuE3QLFI200007    8dkwGVkAk4WPAWY9ZuE3QLFI200008    8dkwGVkAk4WPAWY9ZuE3QLFI200009    8dkwGVkAk4WPAWY9ZuE3QLFI200010
@{recurring_ref_id_list}   yOhVSDvFNo00001    yOhVSDvFNo00002    yOhVSDvFNo00003    yOhVSDvFNo00004    yOhVSDvFNo00005    yOhVSDvFNo00006    yOhVSDvFNo00007    yOhVSDvFNo00008    yOhVSDvFNo00009    yOhVSDvFNo00010
@{recurring_seq_id_list}   00001    00002    00003    00004    00005    00006    00007    00008    00009    00010

*** Test Cases ***
TC_O2O_20459
    [Documentation]    [2C2P] Not allow to query recuring history when transaction not found
    [Tags]    Medium    Regression    UnitTest    payment
    Get Merchant Query Recurring History    trxn_invalid
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/trxn_invalid/recurring/history
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_transaction_not_found
    Response Should Contain Property With Value    errors..message    Transaction Not Found

TC_O2O_20460
    [Documentation]    [2C2P] Not allow to query recuring history by CHARGE transaction
    [Tags]    Medium    Regression    payment
    Prepare The Charge Transaction
    Get Merchant Query Recurring History    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/history
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recurring_information_not_found
    Response Should Contain Property With Value    errors..message    Recurring information is not found

TC_O2O_20462
    [Documentation]    [2C2P] Not allow to query recuring history by VOID transaction
    [Tags]    Medium    Regression    payment
    #Start prepare refund transactions
    Prepare The Charge Transaction
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "VOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "VOID-${TRANSACTION_REFERENCE}","userDefine1": "regression void","userDefine2": "automation script","userDefine3": "note"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    #End prepare refund transactions
    Get Merchant Query Recurring History    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/history
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recurring_information_not_found
    Response Should Contain Property With Value    errors..message    Recurring information is not found

TC_O2O_20468
    [Documentation]    [2C2P] Not allow to query recuring history when access client has invalid scope
    [Tags]    Low    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    Get Merchant Query Recurring History    trxn_invalid
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/v1/transactions/trxn_invalid/recurring/history
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_20471
    [Documentation]    [2C2P] Not allow to query recuring history when charge_subscription transaction is fail
    [Tags]    Medium    Regression    payment
    #Start prepare charge transactions
    Generate Transaction Reference    ${external_ref_id_length}
    Get Date With Format And Increment    %d%m%y%y    -1 day
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}
    ...    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${reject_credit_card}","recurring": {"type": "INTERVAL","interval" : {"recurringInterval": "10","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${reject_credit_card}","recurring": {"type": "INTERVAL","interval" : {"recurringInterval": "10","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    # Prepare The Encrypt Message With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval" : {"recurringInterval": "10","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
    # Post Payment Charge By Credit Card With Recurring Plan    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    "recurring": {"type": "INTERVAL","interval" : {"recurringInterval": "10","chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Get Payment By Client Ref Id    clientRefId=PREPARE-${TRANSACTION_REFERENCE}&trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    #End prepare refund transactions
    Get Merchant Query Recurring History    ${TRANSACTION_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/transactions/${TRANSACTION_ID}/recurring/history
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_recurring_information_not_found
    Response Should Contain Property With Value    errors..message    Recurring information is not found

TC_O2O_23660
    [Documentation]    [2C2P] Allow to query recuring history by CHARGE_SUBSCRIPTION case 2C2P Recurring Count =Current Count and recurring status is inactive
    [Tags]    Medium    Regression    payment
    Get Merchant Query Recurring History    trxn_d3532b514aba49f2bcbd06a6f7813e7b
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    subscription.transaction.recurringRefId    yOhVSDvFNo
    Response Should Contain Property With Value    subscription.transaction.transactionId    trxn_d3532b514aba49f2bcbd06a6f7813e7b
    Response Should Contain Property With Value    subscription.transaction.status    SETTLED
    Response Should Contain Property With Value    subscription.transaction.'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    subscription.transaction.'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With Value    subscription.transaction.'trueyouTerminalId'    -
    Response Should Contain Property With Value    subscription.transaction.paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    subscription.transaction.createdDate
    Response Should Contain Property With String Value    subscription.transaction.lastModifiedDate
    Response Should Contain Property With String Value    subscription.transaction.activities..activityId
    Response Should Contain Property With String Value    subscription.transaction.activities..clientRefId
    Response Should Contain Property With Value    subscription.transaction.activities..amount    2222
    Response Should Contain Property With Value    subscription.transaction.activities..action    CHARGE_SUBSCRIPTION
    Response Should Contain Property With Value    subscription.transaction.activities..status    SUCCESS
    Response Should Contain Property With Value    subscription.transaction.activities..statusDescription    SUCCESS
    Response Should Contain Property With Value    subscription.transaction.activities..paymentRefId    20200804083551188800
    Response Should Contain Property With Value    subscription.transaction.activities..recurringType    INTERVAL
    Response Should Contain Property With Value    subscription.transaction.activities..recurringInterval    1
    Response Should Contain Property With Value    subscription.transaction.activities..chargeNextDate    05082020
    Response Should Contain Property With Value    subscription.transaction.activities..recurringAmount    2222
    Response Should Contain Property With String Value    subscription.transaction.activities..recurringCount
    Response Should Contain Property With String Value    subscription.transaction.activities..accumulateMaxAmount
    Response Should Contain Property With String Value    subscription.transaction.activities..userDefine1
    Response Should Contain Property With String Value    subscription.transaction.activities..userDefine2
    Response Should Contain Property With String Value    subscription.transaction.activities..userDefine3
    Response Should Contain Property With String Value    subscription.transaction.activities..createdDate
    Response Should Contain Property With String Value    subscription.transaction.activities..lastModifiedDate
    Response Should Contain Property With Value    recurring.transactions..recurringRefId    yOhVSDvFNo
    Response Should Contain Property With String Value    recurring.transactions..transactionId
    Response Should Contain Property Value Include In List    recurring.transactions..status    ${recurring_status}
    Response Should Contain Property With Value    recurring.transactions..'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    recurring.transactions..'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With Value    recurring.transactions..'trueyouTerminalId'    -
    Response Should Contain Property With Value    recurring.transactions..paymentMethod    CREDIT_CARD
    Response Should Contain Property With String Value    recurring.transactions..createdDate
    Response Should Contain Property With String Value    recurring.transactions..lastModifiedDate
    Response Should Contain Property With String Value    recurring.transactions..activities..activityId
    Response Should Contain Property Value Include In List    recurring.transactions..activities..clientRefId    ${recurring_transaction_list}
    Response Should Contain Property With Value    recurring.transactions..activities..amount    2222
    Response Should Contain Property With Value    recurring.transactions..activities..action    CHARGE_RECURRING
    Response Should Contain Property With Value    recurring.transactions..activities..status    SUCCESS
    Response Should Contain Property With Value    recurring.transactions..activities..statusDescription    SUCCESS
    Response Should Contain Property Value Include In List    recurring.transactions..activities..paymentRefId    ${recurring_ref_id_list}
    Response Should Contain Property Value Include In List    recurring.transactions..activities..recurringSequenceNo    ${recurring_seq_id_list}
    Response Should Contain Property With String Value    recurring.transactions..activities..userDefine1
    Response Should Contain Property With String Value    recurring.transactions..activities..userDefine2
    Response Should Contain Property With String Value    recurring.transactions..activities..userDefine3
    Response Should Contain Property With String Value    recurring.transactions..activities..createdDate
    Response Should Contain Property With String Value    recurring.transactions..activities..lastModifiedDate
