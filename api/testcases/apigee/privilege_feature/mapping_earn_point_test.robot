*** Settings ***
Documentation    Tests to verify that EARN POINT api works correctly with external client

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

${timestamp_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[.]\\d+$
${fifteen_digits_regex}    ^\\d{15}$ 

${amount}    ${5000}

${invalid_account_type}    THAIIDABC
${invalid_account_value}    2000000000107
${invalid_amount}    -100
${internal_server_error_message}    Internal server error. Please contact weomni-support@ascendcorp.com.
*** Test Cases ***
TC_O2O_02301
    [Documentation]    [API] [Apigee] [Earn Point] User can earn point using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId
    [Tags]    Regression    High    Smoke    ASCO2O-20848 
    Post Earn Point    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":true}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brandId    ${external_brand_id}
    Response Should Contain Property With Value    branchId    ${external_branch_id}
    Response Should Contain Property With Value    terminalId    ${external_terminal_id}
    Response Should Contain Property With Number String    transaction.traceId
    Response Should Contain Property With Number String    transaction.batchId
    Response Should Contain Property With String Value    transaction.transactionReferenceId
    Response Should Contain Property Matches Regex    transaction.transactionDate    ${timestamp_regex}
    Response Should Contain Property With Number String    transaction.points
    Response Should Contain Property With Number String    transaction.amount
    Response Should Contain Property Matches Regex    "trueYouId"    ${fifteen_digits_regex}
    Response Should Contain Property With Value    account.type    ${ACCOUNT_TYPE}
    Response Should Contain Property With Value    account.value    ${ACCOUNT_VALUE}

TC_O2O_02498
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using already mapping external brandId, branchId, and terminalId returns 400 when account value is invalid
    [Tags]     Regression     Medium
    Post Earn Point    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${invalid_account_value}"},"external":true}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brandId    ${external_brand_id}
    Response Should Contain Property With Value    branchId    ${external_branch_id}
    Response Should Contain Property With Value    terminalId    ${external_terminal_id}
    Response Should Contain Property With Number String    transaction.traceId
    Response Should Contain Property With Number String    transaction.batchId
    Response Should Contain Property With String Value    transaction.transactionReferenceId
    Response Should Contain Property Matches Regex    transaction.transactionDate    ${timestamp_regex}
    Response Should Contain Property With Number String    transaction.points
    Response Should Contain Property With Number String    transaction.amount
    Response Should Contain Property Matches Regex    "trueYouId"    ${fifteen_digits_regex}    
    Response Should Contain Property With Value    account.type    ${ACCOUNT_TYPE}
    Response Should Contain Property With Value    account.value    ${invalid_account_value}
        
TC_O2O_02302
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using already mapping external brandId, branchId, and terminalId returns 400 when account type is invalid
    [Tags]     Regression     Medium
    Post Earn Point    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","amount":"${amount}","account":{"type":"${invalid_account_type}","value":"${ACCOUNT_VALUE}"},"external":true}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    account.type
    Response Should Contain Property With Value    .fields..message    account type invalid.
    
TC_O2O_02303
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using already mapping external brandId, branchId, and terminalId returns 400 when amount is invalid
    [Tags]     Regression     Medium
    Post Earn Point    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","amount":"${invalid_amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":true}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    amount
    Response Should Contain Property With Value    .fields..message    incorrect amount format.
    
TC_O2O_02304
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using already mapping external brandId, branchId, and not mapping external terminalId returns 500
    [Tags]     Regression     Medium
    Post Earn Point    ${not_mapping_external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02305
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using already mapping external brandId, branchId, and internal terminalId returns 500
    [Tags]     Regression     Medium
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02306
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using already mapping external brandId, terminalId, and not mapping external branchId returns 500
    [Tags]     Regression     Medium
    Post Earn Point    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${not_mapping_external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02307
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using already mapping external brandId, terminalId, and internal branchId returns 500
    [Tags]     Regression     Medium
    Post Earn Point    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02308
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using already mapping external branchId, terminalId, and not mapping external brandId returns 500
    [Tags]     Regression     Medium
    Post Earn Point    ${external_terminal_id}    {"brandId":"${not_mapping_brand_id}","branchId":"${external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02309
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using already mapping external branchId, terminalId, and internal brandId returns 500
    [Tags]     Regression     Medium
    Post Earn Point    ${external_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02310
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using internal brandId, branchId, and already mapping external terminalId returns 400 when external=FALSE
    [Tags]     Regression     Medium
    Post Earn Point    ${external_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Value    .fields..name    outlet_id or terminal_id
    Response Should Contain Property With Value    .fields..message    Invalid outlet id or terminal id
    
TC_O2O_02311
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using internal brandId, branchId, and not mapping external terminalId returns 400 when external=FALSE
    [Tags]     Regression     Medium
    Post Earn Point    ${not_mapping_external_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Value    .fields..name    outlet_id or terminal_id
    Response Should Contain Property With Value    .fields..message    Invalid outlet id or terminal id
    
TC_O2O_02312
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using internal brandId, terminalId, and already mapping external branchId returns 400 when external=FALSE
    [Tags]     Regression     Medium
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Value    .fields..name    outlet_id or terminal_id
    Response Should Contain Property With Value    .fields..message    Invalid outlet id or terminal id
    
TC_O2O_02313
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using internal brandId, terminalId, and not mapping external branchId returns 400 when external=FALSE
    [Tags]     Regression     Medium
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${not_mapping_external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0404
    Response Should Contain Property With Value    .messsage    ไม่พบรายการ
    Response Should Contain Property With Value    .fields..name    outlet_id or terminal_id
    Response Should Contain Property With Value    .fields..message    Invalid outlet id or terminal id
    
TC_O2O_02314
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using internal branchId, terminalId, and already mapping external brandId returns 400 when external=FALSE
    [Tags]     Regression     Medium
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${external_brand_id}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02315
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using internal branchId, terminalId, and not mapping external brandId returns 400 when external=FALSE
    [Tags]     Regression     Medium
    Post Earn Point    ${TERMINAL_ID}    {"brandId":"${not_mapping_brand_id}","branchId":"${BRANCH_ID}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02316
    [Documentation]    [API] [Apigee] [Earn Point] Earn point using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId returns 400 when external=FALSE
    [Tags]     Regression     Medium
    Post Earn Point    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","amount":"${amount}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external":false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields