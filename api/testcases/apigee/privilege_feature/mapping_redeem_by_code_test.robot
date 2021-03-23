*** Settings ***
Documentation    Tests to verify that REDEEM BY CODE api works correctly with external client

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup    Run Keywords    Prepare External Ids    ${external_terminal_id}    ${external_brand_id}    ${external_branch_id}    ${TERMINAL_ID}    ${BRAND_ID}    ${BRANCH_ID}    AND    Generate Apigee Header    ${APIGEE_CLIENT_ID_MAPPING_ACTIVE_TRUE}    ${APIGEE_CLIENT_SECRET_MAPPING_ACTIVE_TRUE}
Test Teardown    Run Keywords    Delete All Sessions

*** Variables ***
${external_terminal_id}    68036691
${external_brand_id}    SG_BK
${external_branch_id}    01112

${invalid_reward_code}    TY56639120
${invalid_campaign_code}    DRO-2050
${not_mapping_external_terminal_id}    68036691999
${not_mapping_brand_id}    SG_BKABC
${not_mapping_external_branch_id}    01112999
${reward_code}    TY10448794
${internal_server_error_message}    Internal server error. Please contact weomni-support@ascendcorp.com.
*** Test Cases ***
TC_O2O_02233
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using external brandId, external branchId, external terminalId with invalid rewardCode returns 400
    [Tags]    Regression    Medium    SmokeExclude    ASCO2O-13302
    Post Redeem By Code    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${invalid_reward_code}","external": true}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    2061
    Response Should Contain Property With Value    .messsage    ไม่พบรหัสส่วนลดในระบบ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02234
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using external brandId, external branchId, external terminalId with invalid campaignCode returns 400
    [Tags]    Regression    Medium
    Post Redeem By Code    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${invalid_campaign_code}","rewardCode":"${reward_code}","external": true}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .messsage    ไม่พบแคมเปญในระบบ หรือแคมเปญหมดอายุ
    Response Should Contain Property With Value    .displayCode    1015
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02235
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using external brandId, external branchId, not mapping external terminalId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${not_mapping_external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02236
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using external brandId, external branchId, internal terminalId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02237
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using external brandId, external terminalId, not mapping external branchId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${not_mapping_external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02238
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using external brandId, external terminalId, internal branchId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02239
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using external branchId, external terminalId, not mapping external brandId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${external_terminal_id}    {"brandId":"${not_mapping_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02240
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using external branchId, external terminalId, internal brandId returns 500
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${external_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": true}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02241
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using internal branchId, internal brandId, and external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${external_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0722
    Response Should Contain Property With Value    .messsage    TID ยังไม่ได้ถูกสร้าง
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02242
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using internal branchId, internal brandId, and not mapping external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${not_mapping_external_terminal_id}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0722
    Response Should Contain Property With Value    .messsage    TID ยังไม่ได้ถูกสร้าง
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02245
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using internal terminalId, internal branchId, and external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${external_brand_id}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02246
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using internal terminalId, internal branchId, and not mapping external brandId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${not_mapping_brand_id}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02247
    [Documentation]    [API] [Apigee] [Redeem By Code] Redeem by code using using external brandId, external branchId, external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Post Redeem By Code    ${external_terminal_id}    {"brandId":"${external_brand_id}","branchId":"${external_branch_id}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}","external": false}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields