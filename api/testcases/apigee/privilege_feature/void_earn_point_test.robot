*** Settings ***
Documentation    Tests to verify that VOID EARN POINT api works correctly

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup        Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${trace_id}    000010

${invalid_terminal_id}    6900000699
${voided_trace_id}    000001
${not_exist_trace_id}    999999
${invalid_brand_id}    11000022221
${invalid_branch_id}    99999

*** Test Cases *** 
TC_O2O_00512
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api on Apigee works as RPP apis for the negative cases with invalid traceId
    [Tags]    Regression    Medium    Sanity    Smoke
    Post Void Earn Point    ${TERMINAL_ID}    ${not_exist_trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00513
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api on Apigee works as RPP apis for the negative cases with missing brandId
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${TERMINAL_ID}    ${trace_id}    { "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    
TC_O2O_00514
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api on Apigee works as RPP apis for the negative cases with missing branchId
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00515
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api on Apigee works as RPP apis for the nagative case with Unauthorized
    [Tags]    Regression    Medium  
    Set Invalid Access Token 
    Post Void Earn Point    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .displayCode    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00518
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api with invalid terminalId
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${invalid_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00519
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api with invalid brand id
    [Tags]    Regression    Medium   
    Generate Voided Trace Id
    Post Void Earn Point    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${invalid_brand_id}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00520
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api with invalid branch id
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${invalid_branch_id}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00521
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api without sending data in 1 required field
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${TERMINAL_ID}    ${trace_id}    { "brandId": "", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    
TC_O2O_00522
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api without sending data in multiple required fields
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${TERMINAL_ID}    ${trace_id}    { "brandId": "", "branchId": "" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00524
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api with empty body
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${TERMINAL_ID}    ${trace_id}    {}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00525
    [Documentation]    [API] [Apigee] [Void Earn Point] Verify void Earn Point api with invalid Json format
    [Tags]    Regression    Medium   
    Post Void Earn Point    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}" "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Missing comma in object literal
    Response Should Contain Property With Empty Value    .fields