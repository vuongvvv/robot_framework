*** Settings ***
Documentation    Tests to verify that CREATE PAYMENT api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup        Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${amount}    100
${code}    00002102929615
${method}    WALLET
${description}    Automatate script for APIGEE PAYMENT TEST
${invalid_code}    000021080
${non_exist_code}    08882102929615
${used_code}    00002108051364
${void_body}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }

*** Variables ***
${message_regex}    [Barcode ถูกใช้แล้ว\/ไม่ถูกต้องหรือหมดอายุ by TxRefId : ].+
*** Test Cases ***
TC_O2O_00392
    [Documentation]    [API] [Apigee] [Payment] Verify Create Payment with created code will return 400
    [Tags]    Medium    Regression    Sanity    Smoke    payment
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${used_code}", "method": "${method}", "description": "${description}" } }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4104
    Response Should Contain Property Matches Regex    .messsage    ${message_regex}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_00393
    [Documentation]    [API] [Apigee] [Payment] Verify Create Payment with invalid code will return 400
    [Tags]    Medium    Regression    payment
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${invalid_code}", "method": "${method}", "description": "${description}" } }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4104
    Response Should Contain Property Matches Regex    .messsage    ${message_regex}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_00394
    [Documentation]    [API] [Apigee] [Payment] Verify Create Payment with not exist code will return 400
    [Tags]    Medium    Regression    payment
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "00002102929615", "method": "${method}", "description": "${description}" } }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4104
    Response Should Contain Property Matches Regex    .messsage    ${message_regex}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_00395
    [Documentation]    [API] [Apigee] [Payment] Verify Create Payment with missing 1 required field will return message about missing a field
    [Tags]    Medium    Regression    payment
    Post Create Payment    ${TERMINAL_ID}    { "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${non_exist_code}", "method": "${method}", "description": "${description}" } }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required

TC_O2O_00396
    [Documentation]    [API] [Apigee] [Payment] Verify Create Payment with missing some required fields will return message about missing some fields
    [Tags]    Medium    Regression    payment
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "code": "${code}", "method": "${method}", "description": "${description}" } }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    amount
    Response Should Contain Property With Value    .fields..message    amount is required
    Response Should Contain Property With Value    .fields..name    currency
    Response Should Contain Property With Value    .fields..message    currency is required

TC_O2O_00397
    [Documentation]    [API] [Apigee] [Payment] Verify Create Payment without body will return Invalid JSON format message
    [Tags]    Medium    Regression    payment
    Post Create Payment    ${TERMINAL_ID}    ${EMPTY}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Empty JSON string
    Response Should Contain Property With Empty Value    .fields

TC_O2O_00398
    [Documentation]    [API] [Apigee] [Payment] Verify Create Payment with empty body will return message about missing all fields
    [Tags]    Medium    Regression    payment
    Post Create Payment    ${TERMINAL_ID}    {}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    Response Should Contain Property With Value    .fields..name    amount
    Response Should Contain Property With Value    .fields..message    amount is required
    Response Should Contain Property With Value    .fields..name    currency
    Response Should Contain Property With Value    .fields..message    currency is required
    Response Should Contain Property With Value    .fields..name    payment.method
    Response Should Contain Property With Value    .fields..message    payment method is required
    Response Should Contain Property With Value    .fields..name    payment.code
    Response Should Contain Property With Value    .fields..message    payment code is required

TC_O2O_00399
    [Documentation]    [API] [Apigee] [Payment] Verify Create Payment with invalid json format will return Bad Request
    [Tags]    Medium    Regression    payment
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}" "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}" "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" } }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Missing comma in object literal
    Response Should Contain Property With Empty Value    .fields

TC_O2O_00640
    [Documentation]    [API] [Apigee] [Payment] Unauthorized user returns Invalid Access Token
    [Tags]    Medium    Regression    payment
    Set Invalid Access Token
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${used_code}", "method": "${method}", "description": "${description}" } }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    401
    Response Should Contain Property With Value    .displayCode    401
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields

TC_O2O_09873
    [Documentation]    [API] [Apigee] [Payment] Charge fail due to un-unique clientTrxId
    [Tags]    Medium    Regression    UnitTest  Smoke    Sanity    payment
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${used_code}", "method": "${method}", "description": "${description}" ,"clientTrxId": "AutomateTest001"} }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0400
    Response Should Contain Property With Value    .fields[0].name    client_trx_id
    Response Should Contain Property With Value    .fields[0].message    Client trx id is already exist.

TC_O2O_09864
    [Documentation]    [API] [Apigee] [Payment] Charge successful with unique clientTrxId
    [Tags]    High    Regression    Smoke    payment
    Generate Transaction Reference    12
    Create Payment By Random Code    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "method": "${method}", "description": "${description}" ,"clientTrxId": "${TRANSACTION_REFERENCE}"} }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value     brandId    ${BRAND_ID}
    Response Should Contain Property With Value     branchId    ${BRANCH_ID}
    Response Should Contain Property With Value     terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Value     payment.clientTrxId    ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Number String     payment.traceId
    Response Should Contain Property With Number String     payment.batchId
    Response Should Contain Property With String Value     payment.transactionReferenceId
    Response Should Contain Property With Value     payment.currency    ${TH_CURRENCY}
    Response Should Contain Property With Value     payment.amount    ${amount}
    Response Should Contain Property With Value     payment.method    ${method}
    Response Should Contain Property With Number String     "trueYouId"
    [Teardown]    Run Keywords    Get Trace Id    AND    Post Void Payment    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    ${void_body}    AND    Delete All Sessions

TC_O2O_09865
    [Documentation]    [API] [Apigee] [Payment] Charge successful with empty clientTrxId
    [Tags]    Medium    Regression    payment
    Create Payment By Random Code    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "method": "${method}", "description": "${description}" ,"clientTrxId": ""} }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value     brandId    ${BRAND_ID}
    Response Should Contain Property With Value     branchId    ${BRANCH_ID}
    Response Should Contain Property With Value     terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Empty Value     payment.clientTrxId
    Response Should Contain Property With Number String     payment.traceId
    Response Should Contain Property With Number String     payment.batchId
    Response Should Contain Property With String Value     payment.transactionReferenceId
    Response Should Contain Property With Value     payment.currency    ${TH_CURRENCY}
    Response Should Contain Property With Value     payment.amount    ${amount}
    Response Should Contain Property With Value     payment.method    ${method}
    Response Should Contain Property With Number String     "trueYouId"
    [Teardown]    Run Keywords    Get Trace Id    AND    Post Void Payment    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    ${void_body}    AND    Delete All Sessions

TC_O2O_09866
    [Documentation]    [API] [Apigee] [Payment] Charge successful with clientTrxId is null
    [Tags]    Medium    Regression    payment
    Create Payment By Random Code    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "method": "${method}", "description": "${description}" ,"clientTrxId": null }}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value     brandId    ${BRAND_ID}
    Response Should Contain Property With Value     branchId    ${BRANCH_ID}
    Response Should Contain Property With Value     terminalId    ${TERMINAL_ID}
    Response Should Contain Property With String Or Null     payment.clientTrxId
    Response Should Contain Property With Number String     payment.traceId
    Response Should Contain Property With Number String     payment.batchId
    Response Should Contain Property With String Value     payment.transactionReferenceId
    Response Should Contain Property With Value     payment.currency    ${TH_CURRENCY}
    Response Should Contain Property With Value     payment.amount    ${amount}
    Response Should Contain Property With Value     payment.method    ${method}
    Response Should Contain Property With Number String     "trueYouId"
    [Teardown]    Run Keywords    Get Trace Id    AND    Post Void Payment    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    ${void_body}    AND    Delete All Sessions

TC_O2O_09867
    [Documentation]    [API] [Apigee] [Payment] Charge successful without clientTrxId tag
    [Tags]    High    Regression    Smoke    payment
    Create Payment By Random Code    ${TERMINAL_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "method": "${method}", "description": "${description}"}}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value     brandId    ${BRAND_ID}
    Response Should Contain Property With Value     branchId    ${BRANCH_ID}
    Response Should Contain Property With Value     terminalId    ${TERMINAL_ID}
    Response Should Contain Property With String Or Null     payment.clientTrxId
    Response Should Contain Property With Number String     payment.traceId
    Response Should Contain Property With Number String     payment.batchId
    Response Should Contain Property With String Value     payment.transactionReferenceId
    Response Should Contain Property With Value     payment.currency    ${TH_CURRENCY}
    Response Should Contain Property With Value     payment.amount    ${amount}
    Response Should Contain Property With Value     payment.method    ${method}
    Response Should Contain Property With Number String     "trueYouId"
    [Teardown]    Run Keywords    Get Trace Id    AND    Post Void Payment    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    ${void_body}    AND    Delete All Sessions
