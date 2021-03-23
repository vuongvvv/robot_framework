*** Settings ***
Documentation    [EDCPayment] User can create payment void and get the transaction status
...              with clientTrxId and without clientTrxId
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/rpp_payment/rpp_payment_keywords.robot
Resource    ../../../keywords/rpp_payment/payment_edc_offline_keywords.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../keywords/common/rpp_common.robot
Test Setup       Create RPP Gateway Header
Test Teardown    Delete All Sessions

*** Variable ***
${amount}     100
${description}    Automation E2E Test For EDC Offline-Payment

*** Test Case ***
TC_O2O_13196
    [Documentation]    [EDCPayment] User can create payment void and get the transaction status without clientTrxId
    [Tags]    High    Regression    Sanity    E2E    payment
    Post Create Edc Payment By Random Code  { "tx_ref_id": "", "brand_id": "${BRAND_ID}", "tmn_merchant_id": "${TMN_MERCHANT_ID} ", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "payment_code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "payment_method" : "WALLET", "description": "${description}", "client_trx_id": ""}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id             ${BRAND_ID}
    Response Should Contain Property With Value    outlet_id            ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id          ${TERMINAL_ID}
    Response Should Contain Property With Value    amount               ${amount}
    Response Should Contain Property With Value    payment_method       WALLET
    Response Should Contain Property With Value    currency             ${TH_CURRENCY}
    Response Should Contain Property With Value    payment_code         ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}
    Response Should Contain Property With Empty Value  client_trx_id
    Get EDC Trace Id
    Get Transaction Ref Number
    Post Void Transaction EDC Payment   { "tx_ref_id": "${TEST_VARIABLE_TX_REF_ID}", "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TEST_VARIABLE_TRACE_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id             ${BRAND_ID}
    Response Should Contain Property With Value    outlet_id            ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id          ${TERMINAL_ID}
    Response Should Contain Property With Value    amount               ${amount}
    Response Should Contain Property With Value    payment_method       WALLET
    Response Should Contain Property With Value    currency             ${TH_CURRENCY}
    Response Should Contain Property With Value    payment_code         ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}
    Response Should Contain Property With Value    transaction_type     PAYMENT_CANCEL
    Response Should Contain Property With Empty Value  point
    Response Should Contain Property With Empty Value  acc_type
    Response Should Contain Property With Empty Value  acc_value
    Response Should Contain Property With Empty Value  campaign_name
    Get RPP Payment Status
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Value    refund..amount     ${amount}
    Response Should Contain Property With Value    refund..status     SUCCESS
    Response Should Contain Property With Value    refund..code       1_success
    Response Should Contain Property With Value    refund..message    Success

TC_O2O_13197
    [Documentation]    [EDCPayment] User can create payment void and get the transaction status with clientTrxId(Copy)
    [Tags]    High    Regression    Sanity    E2E    payment
    Post Create Edc Payment By Random Code   { "tx_ref_id": "", "brand_id": "${BRAND_ID}", "tmn_merchant_id": "${TMN_MERCHANT_ID} ", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "payment_code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "payment_method" : "WALLET", "description": "${description}", "client_trx_id": "RANDOM_TRANSACTION_REF_CODE"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id             ${BRAND_ID}
    Response Should Contain Property With Value    outlet_id            ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id          ${TERMINAL_ID}
    Response Should Contain Property With Value    amount               ${amount}
    Response Should Contain Property With Value    payment_method       WALLET
    Response Should Contain Property With Value    currency             ${TH_CURRENCY}
    Response Should Contain Property With Value    payment_code         ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}
    Response Should Contain Property With Value    client_trx_id        ${TRANSACTION_REFERENCE}
    Get EDC Trace Id
    Get Transaction Ref Number
    Post Void Transaction EDC Payment    { "tx_ref_id": "${TEST_VARIABLE_TX_REF_ID}", "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TEST_VARIABLE_TRACE_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id             ${BRAND_ID}
    Response Should Contain Property With Value    outlet_id            ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id          ${TERMINAL_ID}
    Response Should Contain Property With Value    amount               ${amount}
    Response Should Contain Property With Value    payment_method       WALLET
    Response Should Contain Property With Value    currency             ${TH_CURRENCY}
    Response Should Contain Property With Value    payment_code         ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}
    Response Should Contain Property With Value    transaction_type     PAYMENT_CANCEL
    Response Should Contain Property With Empty Value  point
    Response Should Contain Property With Empty Value  acc_type
    Response Should Contain Property With Empty Value  acc_value
    Response Should Contain Property With Empty Value  campaign_name
    Get RPP Payment Status
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Value    refund..amount     ${amount}
    Response Should Contain Property With Value    refund..status     SUCCESS
    Response Should Contain Property With Value    refund..code       1_success
    Response Should Contain Property With Value    refund..message    Success
