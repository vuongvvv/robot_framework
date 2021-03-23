*** Settings ***
Documentation    Tests to verify that VOID PAYMENT api works correctly with external client

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

${trace_id}    000010
${internal_server_error_message}    Internal server error. Please contact weomni-support@ascendcorp.com.
*** Test Cases ***
TC_O2O_02180
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using already mapping external brandId, branchId, terminalId returns 400 when traceId is invalid
    [Tags]    Regression    Medium    Smoke    ASCO2O-19124
    Generate Voided Trace Id
    Post Void Payment    ${external_terminal_id}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .messsage    ไม่สามารถยกเลิกรายการซ้ำได้
    Response Should Contain Property With Value    .displayCode    0409
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02181
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using already mapping external brandId, branchId, and not mapping external terminalId returns 500
    [Tags]    Regression    Medium
    Post Void Payment    ${not_mapping_external_terminal_id}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02182
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using already mapping external brandId, branchId, and internal terminalId returns 500
    [Tags]    Regression    Medium
    Post Void Payment    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02183
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using already mapping external brandId, terminalId, and not mapping external branchId returns 500
    [Tags]    Regression    Medium
    Post Void Payment    ${external_terminal_id}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${not_mapping_external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02184
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using already mapping external brandId, terminalId, and internal branchId returns 500
    [Tags]    Regression    Medium
    Post Void Payment    ${external_terminal_id}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${BRANCH_ID}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02185
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using already mapping external terminalId, branchId, and not mapping external brandId returns 500
    [Tags]    Regression    Medium
    Post Void Payment    ${external_terminal_id}    ${trace_id}    { "brandId": "${not_mapping_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02186
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using already mapping external terminalId, branchId, and internal brandId returns 500
    [Tags]    Regression    Medium
    Post Void Payment    ${external_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02187
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using internal brandId, branchId, and already mapping external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Void Payment    ${external_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02188
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using internal brandId, branchId, and not mapping external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Void Payment    ${not_mapping_external_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02189
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using internal brandId, terminalId, and already mapping external branchId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Void Payment    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${external_branch_id}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02190
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using internal brandId, terminalId, and not mapping external branchId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Void Payment    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${not_mapping_external_branch_id}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02191
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using internal terminalId, branchId, and already mapping external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Void Payment    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02192
    [Documentation]    [API] [Apigee] [Void Payment Transaction] Void transaction using internal terminalId, branchId, and not mapping external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Void Payment    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
