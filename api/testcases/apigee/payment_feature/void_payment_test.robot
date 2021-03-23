*** Settings ***
Documentation    Tests to verify that VOID PAYMENT api works correctly

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup        Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${trace_id}    000010

${invalid_terminal_id}    6900000699
${not_exist_trace_id}    999999

*** Test Cases *** 
TC_O2O_00405
    [Documentation]    [API] [Apigee] [Payment] Verify Void Payment api with voided traceId will return "ไม่สามารถยกเลิกรายการซ้ำได้"
    [Tags]    Regression    Medium    Smoke    ASCO2O-19124
    Generate Voided Trace Id
    Post Void Payment    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .messsage    ไม่สามารถยกเลิกรายการซ้ำได้
    Response Should Contain Property With Value    .displayCode    0409
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00406
    [Documentation]    [API] [Apigee] [Payment] Verify Void Payment api with incorrect terminalId will return "ไม่พบรายการ"
    [Tags]    Regression    Medium   
    Post Void Payment    ${invalid_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00407
    [Documentation]    [API] [Apigee] [Payment] Verify Void Payment api with non exist payment code will return "ไม่พบรายการ"
    [Tags]    Regression    Medium   
    Post Void Payment    ${TERMINAL_ID}    ${not_exist_trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00408
    [Documentation]    [API] [Apigee] [Payment] Verify Void Payment api with missing 1 required field will return missing field message
    [Tags]    Regression    Medium   
    Post Void Payment    ${TERMINAL_ID}    ${trace_id}    { "brandId": "", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    
TC_O2O_00409
    [Documentation]    [API] [Apigee] [Payment] Verify Void Payment api with missing some required fields will return missing fields message
    [Tags]    Regression    Medium   
    Post Void Payment    ${TERMINAL_ID}    ${trace_id}    { "brandId": "", "branchId": "" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00410
    [Documentation]    [API] [Apigee] [Payment] Verify Void Payment api with empty body will return missing all fields message
    [Tags]    Regression    Medium   
    Post Void Payment    ${TERMINAL_ID}    ${trace_id}    {}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00411
    [Documentation]    [API] [Apigee] [Payment] Verify Void Payment api with invalid json format in body will return Bad Request
    [Tags]    Regression    Medium   
    Post Void Payment    ${TERMINAL_ID}    ${not_exist_trace_id}    { "brandId": "${BRAND_ID}" "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Missing comma in object literal
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00412
    [Documentation]    [API] [Apigee] [Payment] Verify Void Payment api with incorrect authentication will return Invalid access token
    [Tags]    Regression    Medium  
    Set Invalid Access Token 
    Post Void Payment    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .displayCode    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields