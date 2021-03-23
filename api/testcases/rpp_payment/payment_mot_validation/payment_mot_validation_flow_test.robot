*** Settings ***
Documentation    [MOT_Feature: off] System allow to create payment void and get the transaction status when MOT status = Not Activated
Resource        ../../../resources/init.robot
Resource        ../../../keywords/common/rpp_gateway_common.robot
Resource        ../../../keywords/rpp_payment/rpp_payment_keywords.robot
Resource        ../../../keywords/rpp_payment/payment_mot_validation_flow_keyword.robot
Resource        ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource        ../../../keywords/common/rpp_common.robot
Test Setup       Create RPP Gateway Header
Test Teardown    Delete All Sessions

*** Variable ***
${amount}     100
${payment_method}    WALLET
${description}    Automate Script For MOT Validation
${outlet_id_not_active}       00219
${terminal_id_not_active}     69000219
${outlet_id_not_found}        00001
${terminal_id_not_found}      69000303

*** Test Case ***
TC_O2O_13201
    [Documentation]   [MOT_Feature: off] System allow to create payment void and get the transaction status when MOT status = Not Activated
    [Tags]    ExcludeRegression    ExcludeSanity    ExcludeSmoke    ExcludeE2E    ExcludeHigh
    Get MOT Status    brand_id=${BRAND_ID}&outlet_id=${outlet_id_not_active}&terminal_id=${terminal_id_not_active}
    Response Should Contain Property With Value    status.code         ${${SUCCESS_CODE}}
    Response Should Contain Property With Value    status.message      success
    Response Should Contain Property With Value    data..terminal_id   ${terminal_id_not_active}
    Response Should Contain Property With Empty Value    data..terminal_desc
    Response Should Contain Property With Value    data..outlet_id     ${outlet_id_not_active}
    Response Should Contain Property With String Value    data..outlet_name
    Response Should Contain Property With Value    data..brand_id      ${BRAND_ID}
    Response Should Contain Property With String Value    data..brand_name
    Response Should Contain Property With Value    data..status        NOT ACTIVATED
    Response Should Contain Property With Value    total.total_records   ${1}
    Response Should Contain Property With Value    total.total_pages     ${1}
    Response Should Contain Property With Value    total.total_size      ${1}
    Response Should Contain Property With Value    total.has_next        ${false}
    Response Should Contain Property With Value    total.has_pervious    ${false}
    Generate Transaction Reference  20
    Post Create RPP Payment By Random Code  ${payment_bs_v4_url}   { "tx_ref_id": "RANDOM_TRANSACTION_REFERENCE_ID", "brand_id": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "tmn_merchant_id": "${TMN_MERCHANT_ID}", "outlet_id": "${outlet_id_not_active}", "terminal_id": "${terminal_id_not_active}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "payment_code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "payment_method" : "${payment_method}", "description": "E2E for RPP_Charge with in-active MOT", "client_trx_id": "" }
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
    Post Void Transaction RPP Payment   { "tx_ref_id": "${TRANSACTION_REFERENCE}", "brand_id": "${BRAND_ID}", "outlet_id": "${outlet_id_not_active}", "terminal_id": "${terminal_id_not_active}" }
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

TC_O2O_13202
    [Documentation]   [MOT_Feature: off] System allow to create payment void and get the transaction status when MOT status = Not Found
    [Tags]    ExcludeRegression    ExcludeSanity    ExcludeSmoke    ExcludeE2E    ExcludeHigh
    Get MOT Status  brand_id=${BRAND_ID}&outlet_id=${outlet_id_not_found}&terminal_id=${terminal_id_not_found}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code         ${${SUCCESS_CODE}}
    Response Should Contain Property With Value    status.message      success
    Response Should Contain Property With Empty Value    data
    Response Should Contain Property With Value    total.total_records   ${0}
    Response Should Contain Property With Value    total.total_pages     ${0}
    Response Should Contain Property With Value    total.total_size      ${0}
    Response Should Contain Property With Value    total.has_next        ${false}
    Response Should Contain Property With Value    total.has_pervious    ${false}
    Generate Transaction Reference  20
    Post Create RPP Payment By Random Code  ${payment_bs_v4_url}   { "tx_ref_id": "RANDOM_TRANSACTION_REFERENCE_ID", "brand_id": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "tmn_merchant_id": "${TMN_MERCHANT_ID}", "outlet_id": "${outlet_id_not_found}", "terminal_id": "${terminal_id_not_found}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "payment_code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "payment_method" : "${payment_method}", "description": "E2E for RPP_Charge with in-active MOT", "client_trx_id": "" }
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
    Post Void Transaction RPP Payment   { "tx_ref_id": "${TRANSACTION_REFERENCE}", "brand_id": "${BRAND_ID}", "outlet_id": "${outlet_id_not_found}", "terminal_id": "${terminal_id_not_found}" }
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
