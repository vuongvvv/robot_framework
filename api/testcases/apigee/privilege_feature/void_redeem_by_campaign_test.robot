*** Settings ***
Documentation    Tests to verify that VOID REDEEM BY CAMPAIGN api works correctly

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup        Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${trace_id}    000010
${voided_trace_id}    000013
${invalid_terminal_id}    6900000699
${not_exist_trace_id}    999999
${invalid_brand_id}    11000022221
${invalid_branch_id}    9999999

*** Test Cases *** 
TC_O2O_00494
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify user can void (cancel) Redeem by Campaign(void burn point) transaction nagative case with void redeem more than one time
    [Tags]    Regression    Medium    Smoke    ASCO2O-19124
    Generate Voided Trace Id
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .messsage    ไม่สามารถยกเลิกรายการซ้ำได้
    Response Should Contain Property With Value    .displayCode    0409
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00496
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify user can void (cancel) Redeem by Campaign(void burn point) transaction nagative case with missing tranceId or incorrect tranceId
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${not_exist_trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00497
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify user can void (cancel) Redeem by Campaign(void burn point) transaction nagative case with missing brandId
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    
TC_O2O_00498
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify user can void (cancel) Redeem by Campaign(void burn point) transaction nagative case with missing branchId
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00499
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify user can void (cancel) Redeem by Campaign(void burn point) transaction nagative case with Unauthorized
    [Tags]    Regression    Medium 
    Set Invalid Access Token  
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    401
    Response Should Contain Property With Value    .displayCode    401
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00500
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify user can void (cancel) Redeem by Campaign(void burn point) transaction nagative case with Unauthorized
    [Tags]    Regression    Medium 
    Set Invalid Access Token  
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    401
    Response Should Contain Property With Value    .displayCode    401
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00502
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify Void Redeem by Campaign api with invalid terminalId
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${invalid_terminal_id}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00503
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify Void Redeem by Campaign api with invalid brand id
    [Tags]    Regression    Medium
    Generate Voided Trace Id
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${invalid_brand_id}", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00504
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify Void Redeem by Campaign api with invalid branch id
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}", "branchId": "${invalid_branch_id}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00505
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify Void Redeem by Campaign api without sending data in 1 required field
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "", "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    
TC_O2O_00506
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify Void Redeem by Campaign api without sending data in multiple required fields
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "", "branchId": "" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00508
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify Void Redeem by Campaign api empty body
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    {}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00509
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify Void Redeem by Campaign api with invalid Json format
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}" "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Missing comma in object literal
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00550
    [Documentation]    [API] [Apigee] [Void Redeem By Campaign] Verify Void Redeem by Campaign api with invalid params
    [Tags]    Regression    Medium   
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${trace_id}    { "brandId": "${BRAND_ID}" "branchId": "${BRANCH_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Missing comma in object literal
    Response Should Contain Property With Empty Value    .fields