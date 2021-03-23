*** Settings ***
Documentation    Tests to verify that EARN POINT api works correctly

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup        Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${amount}    ${5000}
${invalid_terminal_id}    99000009
${invalid_brand_id}    9999999
${invalid_branch_id}    99996
${invalid_amount}    -1000
${timestamp_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[.]\\d+$
${fifteen_digits_regex}    ^\\d{15}$ 

*** Test Cases ***
TC_O2O_00474
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api on Apigee works as RPP api
    [Tags]    Regression    High    Smoke    ASCO2O-20848
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brandId    ${BRAND_ID}
    Response Should Contain Property With Value    branchId    ${BRANCH_ID}
    Response Should Contain Property With Value    terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Number String    transaction.traceId
    Response Should Contain Property With Number String    transaction.batchId
    Response Should Contain Property With String Value    transaction.transactionReferenceId
    Response Should Contain Property Matches Regex    transaction.transactionDate    ${timestamp_regex}
    Response Should Contain Property With Number String    transaction.points
    Response Should Contain Property With Number String    transaction.amount
    Response Should Contain Property Matches Regex    "trueYouId"    ${fifteen_digits_regex}
    Response Should Contain Property With Value    account.type    ${ACCOUNT_TYPE}
    Response Should Contain Property With Value    account.value    ${ACCOUNT_VALUE}
    
TC_O2O_00475
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api on Apigee works as RPP api for negative cases Bad Request(brandId)
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
 
TC_O2O_00476
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api on Apigee works as RPP api for negative cases Bad Request (branchId)
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
 
TC_O2O_00477
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api on Apigee works as RPP api for negative cases Bad Request (amount)
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    amount
    Response Should Contain Property With Value    .fields..message    amount is required
 
TC_O2O_00478
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api on Apigee works as RPP api for negative cases Bad Request (account.type)
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    account.type
    Response Should Contain Property With Value    .fields..message    account type is required

TC_O2O_00479
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api on Apigee works as RPP api for negative cases Bad Request (account.value)
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    account.value
    Response Should Contain Property With Value    .fields..message    account value is required
    
TC_O2O_00480
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api on Apigee works as RPP api for negative cases with Unauthorized
    [Tags]    Regression    Medium   
    Set Invalid Access Token
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .displayCode    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00482
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api with invalid terminalId
    [Tags]    Regression    Medium   
    Post Earn Point    ${invalid_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Value    .fields..name    outlet_id or terminal_id
    Response Should Contain Property With Value    .fields..message    Invalid outlet id or terminal id

TC_O2O_00483
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api with invalid branch id
    [Tags]    Regression    Medium
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${invalid_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0715
    Response Should Contain Property With Value    .messsage    ไม่พบข้อมูลลูกค้าในระบบทรู
    Response Should Contain Property With Empty Value    .fields

TC_O2O_00484
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api with invalid brandId
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${invalid_brand_id}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0715
    Response Should Contain Property With Value    .messsage    ไม่พบข้อมูลลูกค้าในระบบทรู
    Response Should Contain Property With Empty Value    .fields

TC_O2O_00485
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api with invalid amount (ex: -1000)
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","amount":"${invalid_amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    amount
    Response Should Contain Property With Value    .fields..message    incorrect amount format.

TC_O2O_00486
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api without sending data in 1 required field
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required

TC_O2O_00487
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api without sending data in some required fields
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"","amount":"","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    Response Should Contain Property With Value    .fields..name    amount
    Response Should Contain Property With Value    .fields..message    amount is required

TC_O2O_00488
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api without some required fields
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    account.value
    Response Should Contain Property With Value    .fields..message    account value is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required

TC_O2O_00489
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api without sending data in 1 required field and missing 1 required field
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    account.value
    Response Should Contain Property With Value    .fields..message    account value is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required

TC_O2O_00490
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api without body
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    ${EMPTY}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Empty JSON string
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00491
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api with empty body
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    Response Should Contain Property With Value    .fields..name    account.value
    Response Should Contain Property With Value    .fields..message    account value is required
    Response Should Contain Property With Value    .fields..name    account.type
    Response Should Contain Property With Value    .fields..message    account type is required
    Response Should Contain Property With Value    .fields..name    amount
    Response Should Contain Property With Value    .fields..message    amount is required
    
TC_O2O_00492
    [Documentation]    [API] [Apigee] [Earn Point] Verify Earn Point api with invalid Json format body
    [Tags]    Regression    Medium   
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}""branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Missing comma in object literal
    Response Should Contain Property With Empty Value    .fields