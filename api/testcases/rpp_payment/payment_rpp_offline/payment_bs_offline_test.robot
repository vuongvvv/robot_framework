*** Settings ***
Documentation    [RPPPayment] User can create payment void and get the transaction status without clientTrxId
Resource        ../../../resources/init.robot
Resource        ../../../keywords/common/rpp_gateway_common.robot
Resource        ../../../keywords/rpp_payment/rpp_payment_keywords.robot
Resource        ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup       Runkeywords   Create RPP Gateway Header  AND  Create RPP Payment V2 Gateway Header
Test Teardown    Delete All Sessions

*** Variable ***
${amount}     100
${payment_method}    WALLET
${description}    Automate Script to verify payment offline

*** Test Case ***
TC_O2O_13198
    [Documentation]    [RPPPayment][V2] User can create payment void and get the transaction status with clientTrxId
    [Tags]    High    Regression    Sanity    Smoke    E2E    payment
    Post Create RPP Payment By Random Code  ${payment_bs_v2_url}   { "tx_ref_id": "RANDOM_TRANSACTION_REFERENCE_ID", "brand_id": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "tmn_merchant_id": "${TMN_MERCHANT_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "payment_code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "payment_method" : "${payment_method}", "description": "Automation test script for E2E", "client_trx_id": "RANDOM_CLIENT_TRANSACTION_ID" }
    ...   ${RPP_PAYMENT_V2_GATEWAY_HEADERS}
    Response Should Contain Property With Value    status.code     ${${SUCCESS_CODE}}
    Response Should Contain Property With Value    status.message  Success
    Response Should Contain Property With Value    tx_ref_id        ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    client_trx_id    ${null}
    Response Should Contain Property With Value   total     ${1}
    Get Transaction Ref Number
    Get RPP Payment Status
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Empty Value  refund
    Post Void Transaction RPP Payment   { "tx_ref_id": "${TRANSACTION_REFERENCE}", "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code     ${${SUCCESS_CODE}}
    Response Should Contain Property With Value    status.message  Success
    Response Should Contain Property With Value    tx_ref_id       ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    client_trx_id   ${null}
    Response Should Contain Property With Value    total     ${1}
    Get RPP Payment Status
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Value    refund..amount     ${amount}
    Response Should Contain Property With Value    refund..status     SUCCESS
    Response Should Contain Property With Value    refund..code       1_success
    Response Should Contain Property With Value    refund..message    Success

TC_O2O_13200
    [Documentation]    [RPPPayment][V4] User can create payment void and get the transaction status without clientTrxId
    [Tags]    High    Regression    Sanity    Smoke    E2E    payment
    Post Create RPP Payment By Random Code  ${payment_bs_v4_url}    { "tx_ref_id": "RANDOM_TRANSACTION_REFERENCE_ID", "brand_id": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "tmn_merchant_id": "${TMN_MERCHANT_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "payment_code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "payment_method" : "${payment_method}", "description": "Automation test script for E2E", "client_trx_id": "" }
    ...   ${RPP_GATEWAY_HEADERS}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code     ${${SUCCESS_CODE}}
    Response Should Contain Property With Value    status.message  Success
    Response Should Contain Property With Value    tx_ref_id     ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Empty Value   client_trx_id
    Response Should Contain Property With Value   total     ${1}
    Response Should Contain Property With Empty Value    data.trace
    Response Should Contain Property With Empty Value    data.reward
    Get Transaction Ref Number
    Get RPP Payment Status
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Empty Value  refund
    Post Void Transaction RPP Payment   { "tx_ref_id": "${TRANSACTION_REFERENCE}", "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code     ${${SUCCESS_CODE}}
    Response Should Contain Property With Value    status.message  Success
    Response Should Contain Property With Value    tx_ref_id       ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    client_trx_id   ${null}
    Response Should Contain Property With Value    total     ${1}
    Get RPP Payment Status
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Value    refund..amount     ${amount}
    Response Should Contain Property With Value    refund..status     SUCCESS
    Response Should Contain Property With Value    refund..code       1_success
    Response Should Contain Property With Value    refund..message    Success

TC_O2O_13199
    [Documentation]    [RPPPayment][V4] User can create payment void and get the transaction status with clientTrxId
    [Tags]    High    Regression    Sanity    Smoke    E2E    payment
    Post Create RPP Payment By Random Code  ${payment_bs_v4_url}    { "tx_ref_id": "RANDOM_TRANSACTION_REFERENCE_ID", "brand_id": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "tmn_merchant_id": "${TMN_MERCHANT_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "payment_code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "payment_method" : "${payment_method}", "description": "Automation test script for E2E", "client_trx_id": "RANDOM_CLIENT_TRANSACTION_ID" }
    ...   ${RPP_GATEWAY_HEADERS}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code     ${${SUCCESS_CODE}}
    Response Should Contain Property With Value    status.message  Success
    Response Should Contain Property With Value    tx_ref_id        ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    client_trx_id    ${CLIENT_TRANSACTION_ID}
    Response Should Contain Property With Value   total     ${1}
    Response Should Contain Property With Empty Value    data.trace
    Response Should Contain Property With Empty Value    data.reward
    Get Transaction Ref Number
    Get RPP Payment Status
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Empty Value  refund
    Post Void Transaction RPP Payment   { "tx_ref_id": "${TRANSACTION_REFERENCE}", "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code     ${${SUCCESS_CODE}}
    Response Should Contain Property With Value    status.message  Success
    Response Should Contain Property With Value    tx_ref_id       ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    client_trx_id   ${null}
    Response Should Contain Property With Value    total     ${1}
    Get RPP Payment Status
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Value    refund..amount     ${amount}
    Response Should Contain Property With Value    refund..status     SUCCESS
    Response Should Contain Property With Value    refund..code       1_success
    Response Should Contain Property With Value    refund..message    Success
