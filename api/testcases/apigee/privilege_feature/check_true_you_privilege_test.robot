*** Settings ***
Documentation    Tests to verify CHECK TRUE YOU PRIVILEGE apis work correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup        Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${yyyy_mm_dd}    ^\\d{4}[-]\\d{2}[-]\\d{2}$
${mm_yy}    \\d{2}[/]\\d{2}
${slip_type_regex}    (1|2|3|4|5)       
    
*** Test Cases ***
TC_O2O_00427
    [Documentation]    [API] [Apigee] [Check True You Privilege] Verify Check True You Privilege api on Apigee works as RPP api
    [Tags]    Regression    High    Sanity    Smoke
    Get True You Privilege    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number String    no
    Response Should Contain Property With String Value    name
    Response Should Contain Property With String Value    type
    Response Should Contain Property With String Value    status
    Response Should Contain Property Matches Regex    expired    ${mm_yy}    
    Response Should Contain Property With Number String    point.balance
    Response Should Contain All Property Values Are String    point.pockets..description
    Response Should Contain All Property Values Are Number    point.pockets..balance    
    Response Should Contain All Property Values Match Regex    point.pockets..expired    ${yyyy_mm_dd}        
    Response Should Contain Property Matches Regex    slipType.id    ${slip_type_regex}
    Response Should Contain Property With String Value    slipType.description
    
TC_O2O_00428
    [Documentation]    [API] [Apigee] [Check True You Privilege] Verify Check True You Privilege Apigee api with missing required field will return missing field message
    [Tags]    Regression    High
    [Template]    Get True You Privilege With Missing Or Empty Required Fields
    ${TERMINAL_ID}    branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}    brandId    brand/merchant id is required
    ${TERMINAL_ID}    brandId=${BRAND_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}    branchId    branch id is required
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountValue=${ACCOUNT_VALUE}    account.type    account type is required
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}    account.value    account value is required
    
TC_O2O_00429
    [Documentation]    [API] [Apigee] [Check True You Privilege] Verify Check True You Privilege api on Apigee works as RPP api for negative cases with Invalid token
    [Tags]    Regression    High
    Set Invalid Access Token           
    Get True You Privilege    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    401
    Response Should Contain Property With Value    .displayCode    401
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00434
    [Documentation]    [API] [Apigee] [Check True You Privilege] Verify Check True You Privilege Apigee api with empty will return the message about missing fields
    [Tags]    Regression    Medium
    [Template]    Get True You Privilege With Missing Or Empty Required Fields
    ${TERMINAL_ID}    brandId=&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}    brandId    brand/merchant id is required
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}    branchId    branch id is required
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=&accountValue=${ACCOUNT_VALUE}    account.type    account type is required
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=    account.value    account value is required
    
TC_O2O_00546
    [Documentation]    [API] [Apigee] [Check True You Privilege] Verify Check True You Privilege Apigee api with invalid params
    [Tags]    Regression    Medium
    [Template]    Get True You Privilege With Invalid Params
    6900000    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}    0709    ไม่พบข้อมูลบัตรของท่าน
    ${TERMINAL_ID}    brandId=91100001&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}    0709    ไม่พบข้อมูลบัตรของท่าน
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=900006&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}    0709    ไม่พบข้อมูลบัตรของท่าน
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=INVALID&accountValue=${ACCOUNT_VALUE}    0709    ไม่พบข้อมูลบัตรของท่าน
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=9000000000103    0709    ไม่พบข้อมูลบัตรของท่าน
    
TC_O2O_00433
    [Documentation]    [API] [Apigee] [Check True You Privilege] Verify Check True You Privilege Apigee api with missing params will return the message about missing fields
    [Tags]    Regression    Medium    NoUnitTest       
    Get True You Privilege    ${TERMINAL_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .fields..name    account.type
    Response Should Contain Property With Value    .fields..message    account type is required
    Response Should Contain Property With Value    .fields..name    account.value
    Response Should Contain Property With Value    .fields..message    account value is required
    Response Should Contain Property With Value    .fields..name    brandId
    Response Should Contain Property With Value    .fields..message    brand/merchant id is required
    Response Should Contain Property With Value    .fields..name    branchId
    Response Should Contain Property With Value    .fields..message    branch id is required
    Response Should Contain Property With Value    .messsage    Bad Request