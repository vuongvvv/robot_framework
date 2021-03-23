*** Settings ***
Documentation    Tests to verify that CREATE PAYMENT api works correctly with external client

Resource    ../../../resources/init.robot
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup    Run Keywords    Prepare External Ids    ${external_terminal_id}    ${external_brand_id}    ${external_branch_id}    ${TERMINAL_ID}    ${BRAND_ID}    ${BRANCH_ID}    AND    Generate Apigee Header    ${APIGEE_CLIENT_ID_MAPPING_ACTIVE_TRUE}    ${APIGEE_CLIENT_SECRET_MAPPING_ACTIVE_TRUE}
Test Teardown    Delete All Sessions

*** Variables ***
${external_terminal_id}    68036691
${external_brand_id}    SG_BK
${external_branch_id}    01112

${not_mapping_external_terminal_id}    68036691999
${not_mapping_brand_id}    SG_BKABC
${not_mapping_external_branch_id}    01112999

${amount}    100
${code}    00000395174113
${method}    WALLET
${description}    description
${message_regex}    [ระบบไม่สามารถดำเนินการณ์ได้ในขณะนี้ by TxRefId : ].+
${barcode_message_regex}    [Barcode ถูกใช้แล้ว/ไม่ถูกต้องหรือหมดอายุ by TxRefId : ].+
${invalid_payment_method_message_regex}    [บาร์โค้ดชำระเงินไม่ถูกต้อง by TxRefId : ].+
${invalid_information_message_regex}    [ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้ by TxRefId : ].+
${invalid_amount}    -100
${invalid_currency}    USD
${invalid_code}    00000395141999
${invalid_method}    ALIPAY
${internal_server_error_message}    Internal server error. Please contact weomni-support@ascendcorp.com.
*** Test Cases ***
TC_O2O_02250
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external brandId, branchId, terminalId returns 400 when payment amount is invalid
    [Tags]    Regression    Medium    Sanity    Smoke
    Post Create Payment    ${external_terminal_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}", "payment": { "amount": "${invalid_amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": true }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    amount
    Response Should Contain Property With Value    .fields..message    incorrect amount format.

TC_O2O_02251
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external brandId, branchId, terminalId returns 400 when payment currency is invalid
    [Tags]    Regression    Medium
    Post Create Payment    ${external_terminal_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}", "payment": { "amount": "${amount}", "currency": "${invalid_currency}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": true }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0400
    Response Should Contain Property Matches Regex    .message    ${message_regex}
    Response Should Contain Property With Value    .fields..name    currency
    Response Should Contain Property With Value    .fields..message    currency invalid

TC_O2O_02252
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external brandId, branchId, terminalId returns 400 when payment code is invalid
    [Tags]    Regression    Medium
    Post Create Payment    ${external_terminal_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${invalid_code}", "method": "${method}", "description": "${description}" },"external": true }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4104
    Response Should Contain Property Matches Regex    .messsage    ${barcode_message_regex}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02253
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external brandId, branchId, terminalId returns 400 when payment method is invalid
    [Tags]    Regression    Medium
    Post Create Payment    ${external_terminal_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${invalid_method}", "description": "${description}" },"external": true }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4152
    Response Should Contain Property Matches Regex    .messsage    ${invalid_payment_method_message_regex}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02254
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external brandId, branchId, and not mapping external terminalId returns 500
    [Tags]    Regression    Medium
    Post Create Payment    ${not_mapping_external_terminal_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02255
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external brandId, branchId, and internal terminalId returns 500
    [Tags]    Regression    Medium
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02256
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external brandId, terminalId, and not mapping external branchId returns 500
    [Tags]    Regression    Medium
    Post Create Payment    ${external_terminal_id}    { "brandId": "${external_brand_id}", "branchId": "${not_mapping_external_branch_id}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02257
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external brandId, terminalId, and internal branchId returns 500
    [Tags]    Regression    Medium
    Post Create Payment    ${external_terminal_id}    { "brandId": "${external_brand_id}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02258
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external terminalId, branchId, and not mapping external brandId returns 500
    [Tags]    Regression    Medium
    Post Create Payment    ${external_terminal_id}    { "brandId": "${not_mapping_brand_id}", "branchId": "${external_branch_id}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02259
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using already mapping external terminalId, branchId, and not mapping external brandId returns 500
    [Tags]    Regression    Medium
    Post Create Payment    ${external_terminal_id}    { "brandId": "${BRAND_ID}", "branchId": "${external_branch_id}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02264
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using internal terminalId, branchId, and already mapping external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${external_brand_id}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property Matches Regex    .messsage    ${invalid_information_message_regex}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02265
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using internal terminalId, branchId, and not mapping external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Create Payment    ${TERMINAL_ID}    { "brandId": "${not_mapping_brand_id}", "branchId": "${BRANCH_ID}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property Matches Regex    .messsage    ${invalid_information_message_regex}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02266
    [Documentation]    [API] [Apigee] [Create Payment] Create payment using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Create Payment    ${external_terminal_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}", "payment": { "amount": "${amount}", "currency": "${TH_CURRENCY}", "code": "${code}", "method": "${method}", "description": "${description}" },"external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property Matches Regex    .messsage    ${invalid_information_message_regex}
    Response Should Contain Property With Empty Value    .fields
