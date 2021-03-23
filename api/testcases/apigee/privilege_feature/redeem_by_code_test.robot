*** Settings ***
Documentation    Tests to verify that REDEEM BY CODE api works correctly

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup        Generate Apigee Header
Test Teardown    Run Keywords    Delete All Sessions

*** Variables ***
${reward_code}    TY56639120
${invalid_brand_id}    9990009
${invalid_branch_id}    99996
${used_reward_code}    TY75270373
${invalid_campaign_code}    TEST-4051123
${invalid_reward_code}    TY56639120123       
    
*** Test Cases ***
TC_O2O_00454
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee works as RPP api for negative cases with missing bandId
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    
TC_O2O_00455
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee works as RPP api for negative cases missing branchId
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00457
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee works as RPP api for negative cases with missing campaignCode
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","rewardCode":"${reward_code}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    campaignCode
    Response Should Contain Property With Value    .fields..message    campaign code is required
    
TC_O2O_00458
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee works as RPP api for negative cases with missing rewardCode
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    rewardCode
    Response Should Contain Property With Value    .fields..message    reward code is required
    
TC_O2O_00459
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee works as RPP api for negative cases with using used rewardCode
    [Tags]    Regression    Medium    SmokeExclude    ASCO2O-13302
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${used_reward_code}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    2061
    Response Should Contain Property With Value    .messsage    ไม่พบรหัสส่วนลดในระบบ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00460
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee works as RPP api for negative cases with Unauthorized
    [Tags]    Regression    Medium
    Set Invalid Access Token
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}"}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    401
    Response Should Contain Property With Value    .displayCode    401
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00463
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee with invalid campaign code
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${invalid_campaign_code}","rewardCode":"${reward_code}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .messsage    ไม่พบแคมเปญในระบบ หรือแคมเปญหมดอายุ
    Response Should Contain Property With Value    .displayCode    1015
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00464
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee with invalid reward code
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${invalid_reward_code}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    2061
    Response Should Contain Property With Value    .messsage    ไม่พบรหัสส่วนลดในระบบ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00465
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee with invalid brand id
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${invalid_brand_id}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    4102
    Response Should Contain Property With Value    .messsage    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00466
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee with invalid branch id
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${invalid_branch_id}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    2061
    Response Should Contain Property With Value    .messsage    ไม่พบรหัสส่วนลดในระบบ
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00467
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee without sending data in 1 required field
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":""}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    400
    Response Should Contain Property With Value    .displayCode    400
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    rewardCode
    Response Should Contain Property With Value    .fields..message    reward code is required
    
TC_O2O_00468
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee without sending data in multiple required fields
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"","rewardCode":""}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    400
    Response Should Contain Property With Value    .displayCode    400
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    campaignCode
    Response Should Contain Property With Value    .fields..message    campaign code is required
    Response Should Contain Property With Value    .fields..name    rewardCode
    Response Should Contain Property With Value    .fields..message    reward code is required
    
TC_O2O_00469
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee without sending multiple required fields
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","campaignCode":"${CAMPAIGN_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    400
    Response Should Contain Property With Value    .displayCode    400
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    rewardCode
    Response Should Contain Property With Value    .fields..message    reward code is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00470
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee without sending data in required field
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    400
    Response Should Contain Property With Value    .displayCode    400
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    rewardCode
    Response Should Contain Property With Value    .fields..message    reward code is required
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    
TC_O2O_00471
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee without body
    Post Redeem By Code    ${TERMINAL_ID}    ${EMPTY}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    400
    Response Should Contain Property With Value    .displayCode    400
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Empty JSON string
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00472
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee with empty body
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    400
    Response Should Contain Property With Value    .displayCode    400
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    campaignCode
    Response Should Contain Property With Value    .fields..message    campaign code is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    Response Should Contain Property With Value    .fields..name    rewardCode
    Response Should Contain Property With Value    .fields..message    reward code is required
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    
TC_O2O_00473
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api on Apigee with invalid Json format body
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"branchId":"${BRANCH_ID}""campaignCode":"${CAMPAIGN_CODE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    400
    Response Should Contain Property With Value    .displayCode    400
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Missing comma in object literal
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00548
    [Documentation]    [API] [Apigee] [Redeem By Code] Verify Redeem By Code api with invalid params
    [Tags]    Regression    Medium
    Post Redeem By Code    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","rewardCode":"${reward_code}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    2061
    Response Should Contain Property With Value    .messsage    ไม่พบรหัสส่วนลดในระบบ
    Response Should Contain Property With Empty Value    .fields