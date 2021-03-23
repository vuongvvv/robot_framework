*** Settings ***
Documentation    Tests to verify that REDEEM BY CAMPAIGN api works correctly

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup        Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${invalid_brand_id}    9999999
${timestamp_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[.]\\d+$
${fifteen_digits_regex}    ^\\d{15}$        
    
*** Test Cases ***
TC_O2O_00435
    [Documentation]    [API] [Apigee] [Privilege] Verify Redeem By Campaign api on Apigee works as RPP api
    [Tags]    Regression    High    Sanity    Smoke
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    brandId    ${BRAND_ID}
    Response Should Contain All Property Values Equal To Value    branchId    ${BRANCH_ID}
    Response Should Contain All Property Values Equal To Value    terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Number String    transaction.traceId
    Response Should Contain Property With Number String    transaction.batchId
    Response Should Contain Property With String Value    transaction.transactionReferenceId
    Response Should Contain Property Matches Regex    transaction.transactionDate    ${timestamp_regex}
    Response Should Contain Property Matches Regex    "trueYouId"    ${fifteen_digits_regex}    
    Response Should Contain Property With Number String    customer.customerReferenceId
    Response Should Contain Property With Number String    customer.pointUsed
    Response Should Contain Property With Number String    customer.pointBalance
    
TC_O2O_00436
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api on Apigee works as RPP api for negative cases Bad Request (brandId)
    [Tags]    Regression    Medium
    Redeem By Campaign With Missing Fields    ${TERMINAL_ID}    {"branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}    brandId    brand/merchant id is required
    
TC_O2O_00437
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api on Apigee works as RPP api for negative cases Bad Request (branchId)
    [Tags]    Regression    Medium
    Redeem By Campaign With Missing Fields    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}    branchId    branch id is required
    
TC_O2O_00438
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api on Apigee works as RPP api for negative cases Bad Request (account.type)
    [Tags]    Regression    Medium
    Redeem By Campaign With Missing Fields    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"value":"${ACCOUNT_VALUE}"}}    account.type    account type is required
    
TC_O2O_00439
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api on Apigee works as RPP api for negative cases Bad Request (account.value)
    [Tags]    Regression    Medium
    Redeem By Campaign With Missing Fields    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}"}}    account.value    account value is required
    
TC_O2O_00440
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api on Apigee works as RPP api for negative cases Bad Request (campaignCode)
    [Tags]    Regression    Medium
    Redeem By Campaign With Missing Fields    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}    campaignCode    campaign code is required
     
TC_O2O_00441
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api on Apigee works as RPP api for negative cases Unauthorized
    [Tags]    Regression    Medium
    Set Invalid Access Token    
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .displayCode    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields

TC_O2O_00442
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api on Apigee works as RPP api for negative cases Not Found
    [Tags]    Regression    Medium    
    Post Redeem By Campaign With Wrong Url    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    .code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    .displayCode    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    .messsage    Not Found
    Response Should Contain Property With Empty Value    .fields
        
TC_O2O_00443
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with invalid campaign
    [Tags]    Regression    Medium
    Redeem By Campaign With Invalid Fields    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"InvalidCampaign","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}    ${BAD_REQUEST_CODE}    API_3_PARTY    2056    ระบบยังไม่ได้สร้างโปรโมชั่นร้านค้านี้
    
TC_O2O_00444
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with invalid ACCOUNT VALUE
    [Tags]    Regression    Medium
    Redeem By Campaign With Invalid Fields    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"InvalidAccountValue"}}    ${BAD_REQUEST_CODE}    API_3_PARTY    0709    ไม่พบข้อมูลบัตรของท่าน
    
TC_O2O_00445
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with invalid brandId
    [Tags]    Regression    Medium
    Redeem By Campaign With Invalid Fields    ${TERMINAL_ID}    {"brandId":"${invalid_brand_id}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}    ${BAD_REQUEST_CODE}    API_3_PARTY    4102    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    
TC_O2O_00547
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with invalid params
    [Tags]    Regression    Medium
    [Template]    Redeem By Campaign With Invalid Fields
    69000006    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}    ${BAD_REQUEST_CODE}    ${BAD_REQUEST_CODE}    API_3_PARTY    TID ยังไม่ได้ถูกสร้าง
    ${TERMINAL_ID}    {"brandId":"100001VVV","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}    ${BAD_REQUEST_CODE}    ${BAD_REQUEST_CODE}    API_3_PARTY    ระบบยังไม่ได้สร้างโปรโมชั่นร้านค้านี้
    
TC_O2O_00446
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with missing data in 1 required field
    [Tags]    Regression    Medium
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    
TC_O2O_00447
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with missing some data in required fields
    [Tags]    Regression    Medium
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"","branchId":"","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00448    
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with missing required fields
    [Tags]    Regression    Medium
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    campaignCode
    Response Should Contain Property With Value    .fields..message    campaign code is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    
TC_O2O_00449
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with missing accountType and accountValue
    [Tags]    Regression    Medium
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    account.type
    Response Should Contain Property With Value    .fields..message    account type is required
    Response Should Contain Property With Value    .fields..name    account.value
    Response Should Contain Property With Value    .fields..message    account value is required
    
TC_O2O_00451
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with empty body
    [Tags]    Regression    Medium
    Post Redeem By Campaign    ${TERMINAL_ID}    {}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    Response Should Contain Property With Value    .fields..name    campaignCode
    Response Should Contain Property With Value    .fields..message    campaign code is required
    Response Should Contain Property With Value    .fields..name    account.type
    Response Should Contain Property With Value    .fields..message    account type is required
    Response Should Contain Property With Value    .fields..name    account.value
    Response Should Contain Property With Value    .fields..message    account value is required
    
TC_O2O_00452
    [Documentation]    [API] [Apigee] [Redeem By Campaign]  Verify Redeem By Campaign api with missing accountType and accountValue
    [Tags]    Regression    Medium
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}""branchId":"${BRANCH_ID}","campaignCode":"${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Missing comma in object literal
    Response Should Contain Property With Empty Value    .fields