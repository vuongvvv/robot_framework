*** Settings ***
Documentation    Tests to verify that APIGEE E2E flow works correctly

Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/apigee/apigee_privilege_keywords.robot
Resource    ../../../api/keywords/apigee/apigee_payment_keywords.robot
Resource    ../../../api/keywords/common/true_you_common.robot
Resource    ../../../api/keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../api/keywords/common/api_common.robot
Test Setup    Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${timestamp_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}([.]\\d+|)$
${void_transaction_timestamp_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}$
${fifteen_digits_regex}    ^\\d{15}$
${amount}    100
${true_money_wallet_code}    00007316442313
${payment_method}    WALLET
${description}    Automate Script for APIGEE

*** Test Cases ***
TC_O2O_07800
    [Documentation]    [Apigee] User can redeem by campaign and void the transaction
    [Tags]    Regression    High    Sanity    E2E    Smoke
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    brandId    ${BRAND_ID}
    Response Should Contain All Property Values Equal To Value    branchId    ${BRANCH_ID}
    Response Should Contain All Property Values Equal To Value    terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Number String    transaction.traceId
    Response Should Contain Property With Number String    transaction.batchId
    Response Should Contain Property With String Value    transaction.transactionReferenceId
    Response Should Contain Property Matches Regex    transaction.transactionDate    ${timestamp_regex}
    Response Should Contain Property Matches Regex    "trueYouId"    ${fifteen_digits_regex}
    Response Should Contain Property With Number String    customer.customerReferenceId
    Response Should Contain Property With Number String    customer.pointUsed
    Response Should Contain Property With Number String    customer.pointBalance
    Get Trace Id
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    account.type    ${ACCOUNT_TYPE}
    Response Should Contain Property With Value    account.value    ${ACCOUNT_VALUE}
    Response Should Contain Property With Value    payment.traceId    ${TEST_VARIABLE_TRACE_ID}
    Response Should Contain Property With Number String    payment.batchId
    Response Should Contain Property With String Value    payment.transactionReferenceId
    Response Should Contain Property Matches Regex     payment.transactionDate    ${void_transaction_timestamp_regex}
    Response Should Contain Property With Value     payment.amount    0
    Response Should Contain Property With String Or Null    payment.currency
    Response Should Contain Property With String Or Null     payment.code
    Response Should Contain Property With String Or Null     payment.method
    Response Should Contain Property With Value    campaign.name    ${CAMPAIGN_NAME}
    Response Should Contain Property With Value    brandId    ${BRAND_ID}
    Response Should Contain Property With Value    branchId    ${BRANCH_ID}
    Response Should Contain Property With Value    terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Value    transactionType    REDEEM_ROLLBACK
    Response Should Contain Property With String Or Null    point
    Response Should Contain Property With Number String    "trueYouId"

TC_O2O_07842
    [Documentation]    [Apigee] [Payment] User can create payment void and get the transaction status without clientTrxId
    [Tags]    Regression    High    Sanity    E2E    Smoke    payment
    #Step 1: Random payment code and send the request to create payment without clientTrxId
    Create Payment By Random Code     ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "method": "${payment_method}", "description": "${description}" } }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brandId    ${BRAND_ID}
	  Response Should Contain Property With Value    branchId    ${BRANCH_ID}
	  Response Should Contain Property With Value    terminalId    ${TERMINAL_ID}
	  Response Should Contain Property With Number String    payment.traceId
	  Response Should Contain Property With Number String    payment.batchId
	  Response Should Contain Property With String Value    payment.transactionReferenceId
	  Response Should Contain Property Matches Regex    payment.transactionDate    ${timestamp_regex}
	  Response Should Contain Property With Value    payment.currency    ${TH_CURRENCY}
	  Response Should Contain Property With Value    payment.amount    ${amount}
	  Response Should Contain Property With Value    payment.code    ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}
	  Response Should Contain Property With Value    payment.method    ${payment_method}
	  Response Should Contain Property With Number String    "trueYouId"
    Get Trace Id
    Get Transaction By Reference ID
    #Step 2: Post void transaction
    Post Void Payment    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Or Null    account.type
	  Response Should Contain Property With String Or Null    account.value
	  Response Should Contain Property With Value    payment.traceId    ${TEST_VARIABLE_TRACE_ID}
	  Response Should Contain Property With Number String    payment.batchId
	  Response Should Contain Property With String Value    payment.transactionReferenceId
	  Response Should Contain Property Matches Regex    payment.transactionDate    ${void_transaction_timestamp_regex}
	  Response Should Contain Property With Value    payment.amount    ${amount}
	  Response Should Contain Property With Value    payment.currency    ${TH_CURRENCY}
	  Response Should Contain Property With Value    payment.code    ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}
	  Response Should Contain Property With Value    payment.method    ${payment_method}
	  Response Should Contain Property With String Or Null    campaign.name
	  Response Should Contain Property With Value    brandId    ${BRAND_ID}
	  Response Should Contain Property With Value    branchId    ${BRANCH_ID}
	  Response Should Contain Property With Value    terminalId    ${TERMINAL_ID}
	  Response Should Contain Property With Value    transactionType    PAYMENT_CANCEL
    Response Should Contain Property With String Or Null    point
    Response Should Contain Property With Number String    "trueYouId"
    Response Should Contain Property With Value    payment.traceId    ${TEST_VARIABLE_TRACE_ID}
    #Step 3: Get Apigee Payment Status
    Get Apigee Payment Status    ${TEST_VARIABLE_TX_REF}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payment..status    SUCCESS
    Response Should Contain Property With Value    .payment..code    1_success
    Response Should Contain Property With Value    .payment..message    Success
    Response Should Contain Property With Value    .refund..status    SUCCESS
    Response Should Contain Property With Value    .refund..code    1_success
    Response Should Contain Property With Value    .refund..message    Success

TC_O2O_00453
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee works as RPP api
    [Tags]    Regression    High    SanityExclude    E2EExclude    SmokeExclude
    Generate Reward Code By Campaign    ${CAMPAIGN_CODE}
    Post Redeem By Code    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "campaignCode": "${CAMPAIGN_CODE}", "rewardCode": "${TEST_DATA_REWARD_CODE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    brandId    ${BRAND_ID}
    Response Should Contain All Property Values Equal To Value    branchId    ${BRANCH_ID}
    Response Should Contain All Property Values Equal To Value    terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Number String    transaction.traceId
    Response Should Contain Property With Number String    transaction.batchId
    Response Should Contain Property With String Value    transaction.transactionReferenceId
    Response Should Contain Property Matches Regex    transaction.transactionDate    ${timestamp_regex}
    Response Should Contain Property Matches Regex    "trueYouId"    ${fifteen_digits_regex}
    Response Should Contain All Property Values Equal To Value    rewardCode    ${TEST_DATA_REWARD_CODE}

TC_O2O_09977
    [Documentation]    [Apigee] [Payment] User can create payment and get the transaction status with client_trx_id
    [Tags]    Regression    High    Sanity    E2E    Smoke    payment
    #Step 1: Random payment code and send the request to create payment without clientTrxId
    Create Payment By Random Code    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "method": "${payment_method}", "description": "${description}","clientTrxId": "RANDOM_TRANSACTION_REF_CODE" } }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brandId    ${BRAND_ID}
    Response Should Contain Property With Value    branchId    ${BRANCH_ID}
    Response Should Contain Property With Value    terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Value    payment.clientTrxId    ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Number String    payment.traceId
    Response Should Contain Property With Number String    payment.batchId
    Response Should Contain Property With String Value    payment.transactionReferenceId
    Response Should Contain Property Matches Regex    payment.transactionDate    ${timestamp_regex}
    Response Should Contain Property With Value    payment.currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    payment.amount    ${amount}
    Response Should Contain Property With Value    payment.code    ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}
    Response Should Contain Property With Value    payment.method    ${payment_method}
    Response Should Contain Property With Number String    "trueYouId"
    Get Trace Id
    #Step 2: Send the request for get status with clientTrxId before void
    Get Apigee Payment Status By ClientTrxId    ${TERMINAL_ID}    ${TRANSACTION_REFERENCE}      ${BRAND_ID}      ${BRANCH_ID}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payment..status    SUCCESS
    Response Should Contain Property With Value    .payment..code    1_success
    Response Should Contain Property With Value    .payment..message    Success
    Response Should Contain Property With Empty Value    .refund
    #Step 3: Send the request for void
    Post Void Payment    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Or Null    account.type
    Response Should Contain Property With String Or Null    account.value
    Response Should Contain Property With Value    payment.traceId    ${TEST_VARIABLE_TRACE_ID}
    Response Should Contain Property With Number String    payment.batchId
    Response Should Contain Property With String Value    payment.transactionReferenceId
    Response Should Contain Property Matches Regex    payment.transactionDate    ${void_transaction_timestamp_regex}
    Response Should Contain Property With Value    payment.amount    ${amount}
    Response Should Contain Property With Value    payment.currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    payment.code    ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}
    Response Should Contain Property With Value    payment.method    ${payment_method}
    Response Should Contain Property With String Or Null    campaign.name
    Response Should Contain Property With Value    brandId    ${BRAND_ID}
    Response Should Contain Property With Value    branchId    ${BRANCH_ID}
    Response Should Contain Property With Value    terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Value    transactionType    PAYMENT_CANCEL
    Response Should Contain Property With String Or Null    point
    Response Should Contain Property With Number String    "trueYouId"
    Response Should Contain Property With Value    payment.traceId    ${TEST_VARIABLE_TRACE_ID}
    #Step 4: Send the request for get status with clientTrxId after void
    Get Apigee Payment Status By ClientTrxId    ${TERMINAL_ID}    ${TRANSACTION_REFERENCE}      ${BRAND_ID}      ${BRANCH_ID}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payment..status    SUCCESS
    Response Should Contain Property With Value    .payment..code    1_success
    Response Should Contain Property With Value    .payment..message    Success
    Response Should Contain Property With Value    .refund..status    SUCCESS
    Response Should Contain Property With Value    .refund..code    1_success
    Response Should Contain Property With Value    .refund..message    Success
