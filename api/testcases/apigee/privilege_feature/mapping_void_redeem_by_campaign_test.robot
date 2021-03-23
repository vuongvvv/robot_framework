*** Settings ***
Documentation    Tests to verify that VOID REDEEM BY CAMPAIGN api works correctly with external client

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

${trace_id}    000005
${invalid_trace_id}    900001
${internal_server_error_message}    Internal server error. Please contact weomni-support@ascendcorp.com.
*** Test Cases ***    
TC_O2O_02218
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using already mapping external brandId, branchId, terminalId returns 400 when traceId is invalid
    [Tags]    Regression    Medium    Smoke
    Post Void Redeem By Campaign    ${external_terminal_id}    ${invalid_trace_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02219
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using already mapping external brandId, branchId, and not mapping external terminalId returns 500
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${not_mapping_external_terminal_id}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02220
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using already mapping external brandId, branchId, and internal terminalId returns 500
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02221
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using already mapping external brandId, terminalId, and not mapping external branchId returns 500
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${external_terminal_id}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${not_mapping_external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02222
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using already mapping external brandId, terminalId, and internal branchId returns 500
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${external_terminal_id}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${BRAND_ID}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02223
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using already mapping external terminalId, branchId, and not mapping external brandId returns 500
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${external_terminal_id}    ${trace_id}    { "brandId": "${not_mapping_brand_id}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02224
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using already mapping external terminalId, branchId, and internal brandId returns 500
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${external_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${external_branch_id}","external": true }
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02225
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using internal brandId, branchId, and already mapping external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${external_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02226
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using internal brandId, branchId, and not mapping external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${not_mapping_external_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02227
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using internal brandId, terminalId, and already mapping external branchId returns 400 when external=FALSE
    [Tags]    Regression    Medium
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${external_branch_id}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02228
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using internal brandId, terminalId, and not mapping external branchId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${not_mapping_external_branch_id}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02229
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using internal terminalId, branchId, and already mapping external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${external_brand_id}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02230
    [Documentation]    [API] [Apigee] [Void Redemption Transaction] Void transaction using internal terminalId, branchId, and not mapping external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${not_mapping_brand_id}", "branchId": "${BRANCH_ID}","external": false }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields