*** Settings ***
Documentation    User can create payment void and get the transaction status with payment method= ALIPAY

Resource    ../../../resources/init.robot
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Resource    ../../../keywords/apigee/apigee_payment_keywords.robot
Resource    ../../../keywords/common/api_common.robot
Test Setup    Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${amount}         100
${description}       Automatate script for APIGEE PAYMENT TEST
${alipay_code_prefix}    acm20001

*** Test Cases ***
TC_O2O_13326
    [Documentation]    [Apigee] User can create payment void and get the transaction status with payment method= ALIPAY
    [Tags]    Regression    Sanity    Smoke    E2E    High
    Generate Alipay Barcode  ${alipay_code_prefix}
    Post Create Payment      ${ALIPAY_TERMINAL_ID}    { "brandId":"${ALIPAY_BRAND_ID}", "branchId":"${ALIPAY_ฺBRANCH_ID}", "payment":{"amount":"${amount}", "currency":"${TH_CURRENCY}", "code":"${ALIPAY_BARCODE}", "method":"ALIPAY", "description":"${description}", "clientTrxId":""} }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   brandId       ${ALIPAY_BRAND_ID}
    Response Should Contain Property With Value   branchId      ${ALIPAY_ฺBRANCH_ID}
    Response Should Contain Property With Value   terminalId    ${ALIPAY_TERMINAL_ID}
    Response Should Contain Property With Number String   payment.traceId
    Response Should Contain Property With Number String   payment.batchId
    Response Should Contain Property With String Value   payment.transactionReferenceId
    Response Should Contain Property With Value   payment.currency  ${TH_CURRENCY}
    Response Should Contain Property With Value   payment.amount    ${amount}
    Response Should Contain Property With Value   payment.code      ${ALIPAY_BARCODE}
    Response Should Contain Property With Value   payment.method    ALIPAY
    Response Should Contain Property With Number String    "trueYouId"
    Get Trace Id
    Get Transaction By Reference ID
    Post Void Payment    ${ALIPAY_TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${ALIPAY_BRAND_ID}", "branchId": "${ALIPAY_ฺBRANCH_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   brandId       ${ALIPAY_BRAND_ID}
    Response Should Contain Property With Value   branchId      ${ALIPAY_ฺBRANCH_ID}
    Response Should Contain Property With Value   terminalId    ${ALIPAY_TERMINAL_ID}
    Response Should Contain Property With Value   transactionType  PAYMENT_CANCEL
    Response Should Contain Property With Value   payment.traceId    ${TEST_VARIABLE_TRACE_ID}
    Response Should Contain Property With Number String   payment.batchId
    Response Should Contain Property With Value   payment.transactionReferenceId  ${TEST_VARIABLE_TX_REF}
    Response Should Contain Property With Value   payment.currency  ${TH_CURRENCY}
    Response Should Contain Property With Value   payment.amount    ${amount}
    Response Should Contain Property With Value   payment.code      ${ALIPAY_BARCODE}
    Response Should Contain Property With Value   payment.method    ALIPAY
    Response Should Contain Property With Empty Value  account.type
    Response Should Contain Property With Empty Value  account.value
    Response Should Contain Property With Number String  "trueYouId"
    Response Should Contain Property With Empty Value  campaign.name
    Response Should Contain Property With Empty Value  point
