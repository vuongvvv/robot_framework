*** Settings ***
Documentation    Tests to verify that REDEEM BY CAMPAIGN api works correctly with external client

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup    Run Keywords    Prepare External Ids    ${external_terminal_id}    ${external_brand_id}    ${external_branch_id}    ${TERMINAL_ID}    ${BRAND_ID}    ${BRANCH_ID}    AND    Generate Apigee Header    ${APIGEE_CLIENT_ID_MAPPING_ACTIVE_TRUE}    ${APIGEE_CLIENT_SECRET_MAPPING_ACTIVE_TRUE}
Test Teardown    Delete All Sessions

*** Variables ***
${external_terminal_id}    68036691
${external_brand_id}    SG_BK
${external_branch_id}    01112

${invalid_account_type}    THAIIDABC
${invalid_account_value}    200000000010799
${invalid_campaign_code}    TEST-6764ABC
${not_mapping_external_terminal_id}    68036691999
${not_mapping_brand_id}    SG_BKABC
${not_mapping_external_branch_id}    01112999

${timestamp_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[.]\\d+$
${fifteen_digits_regex}    ^\\d{15}$
${internal_server_error_message}    Internal server error. Please contact weomni-support@ascendcorp.com.
*** Test Cases ***
TC_O2O_02160
    [Documentation]    [API] [Apigee] [Redeem By Campaign] User can redeem by campaign using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId
    [Tags]    Regression    High    Smoke
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    brandId    ${external_brand_id}
    Response Should Contain All Property Values Equal To Value    branchId    ${external_branch_id}
    Response Should Contain All Property Values Equal To Value    terminalId    ${external_terminal_id}
    Response Should Contain Property With Number String    transaction.traceId
    Response Should Contain Property With Number String    transaction.batchId
    Response Should Contain Property With String Value    transaction.transactionReferenceId
    Response Should Contain Property Matches Regex    transaction.transactionDate    ${timestamp_regex}
    Response Should Contain Property Matches Regex    "trueYouId"    ${fifteen_digits_regex}
    Response Should Contain Property With Number String    customer.customerReferenceId
    Response Should Contain Property With Number String    customer.pointUsed
    Response Should Contain Property With Number String    customer.pointBalance
    
TC_O2O_02161
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external brandId, external branchId, external terminalId with invalid account value returns 400
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${invalid_account_value}"},"external": true}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0709
    Response Should Contain Property With Value    .messsage    ไม่พบข้อมูลบัตรของท่าน
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02162
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external brandId, external branchId, external terminalId with invalid account type returns 400
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${invalid_account_type}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    account.type
    Response Should Contain Property With Value    .fields..message    account type invalid.
    
TC_O2O_02163
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external brandId, external branchId, external terminalId with invalid campaign code returns 400
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${invalid_campaign_code}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    2056
    Response Should Contain Property With Value    .messsage    ระบบยังไม่ได้สร้างโปรโมชั่นร้านค้านี้
    Response Should Contain Property With Empty Value    .fields

TC_O2O_02164
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external brandId, external branchId and not matching external terminalId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${not_mapping_external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02165
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external brandId, external branchId and internal terminalId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02166
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external brandId, external terminalId and not matching external branchId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${not_mapping_external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02167
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external brandId, external terminalId and internal branchId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02168
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external terminalId, external branchId and not matching external brandId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${not_mapping_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02169
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external terminalId, external branchId and internal brandId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02170
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using internal terminalId, branchId and brandId returns 500 when external=true
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02171
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using internal brandId, internal branchId and external terminalId already map returns 400
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0722
    Response Should Contain Property With Value    .messsage    TID ยังไม่ได้ถูกสร้าง
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02172
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using internal brandId, internal branchId and not mapping external terminalId returns 400
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0722
    Response Should Contain Property With Value    .messsage    TID ยังไม่ได้ถูกสร้าง
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02173
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using internal brandId, internal terminalId and external branchId already map returns 200
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": false}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    brandId    ${BRAND_ID}
    Response Should Contain All Property Values Equal To Value    branchId    ${external_branch_id}
    Response Should Contain All Property Values Equal To Value    terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Number String    transaction.traceId
    Response Should Contain Property With Number String    transaction.batchId
    Response Should Contain Property With String Value    transaction.transactionReferenceId
    Response Should Contain Property Matches Regex    transaction.transactionDate    ${timestamp_regex}
    Response Should Contain Property Matches Regex    "trueYouId"    ${fifteen_digits_regex}    
    Response Should Contain Property With Number String    customer.customerReferenceId
    Response Should Contain Property With Number String    customer.pointUsed
    Response Should Contain Property With Number String    customer.pointBalance
    
TC_O2O_02174
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using internal brandId, internal terminalId and not mapping external branchId returns 200
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${not_mapping_external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": false}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    brandId    ${BRAND_ID}
    Response Should Contain All Property Values Equal To Value    branchId    ${not_mapping_external_branch_id}
    Response Should Contain All Property Values Equal To Value    terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Number String    transaction.traceId
    Response Should Contain Property With Number String    transaction.batchId
    Response Should Contain Property With String Value    transaction.transactionReferenceId
    Response Should Contain Property Matches Regex    transaction.transactionDate    ${timestamp_regex}
    Response Should Contain Property Matches Regex    "trueYouId"    ${fifteen_digits_regex}    
    Response Should Contain Property With Number String    customer.customerReferenceId
    Response Should Contain Property With Number String    customer.pointUsed
    Response Should Contain Property With Number String    customer.pointBalance
    
TC_O2O_02175
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using internal terminalId, internal branchId and external brandId already map returns 400
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${external_brand_id}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02176
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using internal terminalId, internal branchId and not mapping external brandId returns 400
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${not_mapping_brand_id}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02177
    [Documentation]    [API] [Apigee] [Redeem By Campaign] Redeem by campaign using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Redeem By Campaign    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"},"external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields