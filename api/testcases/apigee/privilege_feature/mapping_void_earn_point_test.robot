*** Settings ***
Documentation    Tests to verify that VOID EARN POINT api works correctly with external client

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup    Run Keywords    Prepare External Ids    ${external_terminal_id}    ${external_brand_id}    ${external_branch_id}    ${TERMINAL_ID}    ${BRAND_ID}    ${BRANCH_ID}    AND    Generate Apigee Header    ${APIGEE_CLIENT_ID_MAPPING_ACTIVE_TRUE}    ${APIGEE_CLIENT_SECRET_MAPPING_ACTIVE_TRUE}
Test Teardown    Run Keywords    Delete All Sessions

*** Variables ***
${external_terminal_id}    68036691
${external_brand_id}    SG_BK
${external_branch_id}    01112

${not_mapping_external_terminal_id}    68036691999
${not_mapping_brand_id}    SG_BKABC
${not_mapping_external_branch_id}    01112999

${trace_id}    000001
${invalid_trace_id}    000057
${internal_server_error_message}    Internal server error. Please contact weomni-support@ascendcorp.com.
*** Test Cases ***    
TC_O2O_02203
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using already mapping external brandId, branchId, terminalId returns 400 when traceId is already voided
    [Tags]    Regression    Medium    Smoke    ASCO2O-19124
    Generate Voided Trace Id
    Post Void Earn Point    ${external_terminal_id}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .messsage    ไม่สามารถยกเลิกรายการซ้ำได้
    Response Should Contain Property With Value    .displayCode    0409
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02204
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using already mapping external brandId, branchId, and not mapping external terminalId returns 500
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${not_mapping_external_terminal_id}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02205
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using already mapping external brandId, branchId, and internal terminalId returns 500
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02206
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using already mapping external brandId, terminalId, and not mapping external branchId returns 500
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${external_terminal_id}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${not_mapping_external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02207
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using already mapping external brandId, terminalId, and internal branchId returns 500
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${external_terminal_id}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${BRANCH_ID}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02208
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using already mapping external terminalId, branchId, and not mapping external brandId returns 500
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${external_terminal_id}    ${trace_id}    { "brandId": "${not_mapping_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02209
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using already mapping external terminalId, branchId, and internal brandId returns 500
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${external_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02210
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using internal brandId, branchId, and already mapping external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${external_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02211
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using internal brandId, branchId, and not mapping external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${not_mapping_external_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02212
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using internal brandId, terminalId, and already mapping external branchId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Generate Voided Trace Id
    Post Void Earn Point    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${BRAND_ID}", "branchId": "${external_branch_id}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02213
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using internal brandId, terminalId, and not mapping external branchId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Generate Voided Trace Id
    Post Void Earn Point    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${BRAND_ID}", "branchId": "${not_mapping_external_branch_id}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02214
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using internal terminalId, branchId, and already mapping external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Generate Voided Trace Id
    Post Void Earn Point    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${external_brand_id}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02215
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using internal terminalId, branchId, and not mapping external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Generate Voided Trace Id
    Post Void Earn Point    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${not_mapping_brand_id}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02216
    [Documentation]    [API] [Apigee] [Void Earn TruePoint Transaction] Void transaction using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId returns 500 when markAsDelete of Mapping is TRUE
    [Tags]    Regression    Medium    ASCO2O-1954
    [Setup]    Prepare External Ids    ${external_terminal_id}    ${external_brand_id}    ${external_branch_id}    ${TERMINAL_ID}    ${BRAND_ID}    ${BRANCH_ID}    true
    Generate Apigee Header    ${APIGEE_CLIENT_ID_MAPPING_ACTIVE_TRUE}    ${APIGEE_CLIENT_SECRET_MAPPING_ACTIVE_TRUE}
    Generate Voided Trace Id
    Post Void Earn Point    ${external_terminal_id}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields