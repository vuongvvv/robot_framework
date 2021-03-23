*** Settings ***
Documentation    Tests to verify that CAMPAIGN api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/apigee/apigee_campaign_keywords.robot
Test Setup    Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${redeem_type}    REDEEM_BY_CAMPAIGN
${invalid_terminal_id}    69000099
${yyyy_mm_dd}    ^\\d{4}[-]\\d{2}[-]\\d{2}$
${yyyy_mm_dd_hh_mm_ss}    ^\\d{4}[-]\\d{2}[-]\\d{2}[ ]\\d{2}[:]\\d{2}[:]\\d{2}$
${status_regex}    ^(active|inactive)$

${invalid_brand_id}    1100001999
${invalid_branch_id}    00006999
*** Test Cases ***
TC_O2O_00416
    [Documentation]     [API] [Apigee] [Campaign] Verify Get Campaign api on Apigee works as RPP api
    [Tags]      Regression     High    Sanity    Smoke
    Get Campaign List    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&redeemType=${redeem_type} 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    content..brandId    ${BRAND_ID}  
    Response Should Contain All Property Values Equal To Value    content..branchId    ${BRANCH_ID}
    Response Should Contain All Property Values Equal To Value    content..terminalId    ${TERMINAL_ID}
    Response Should Contain All Property Values Match Regex    content..campaign.code    ^(\\w+)[-](\\d+)$
    Response Should Contain All Property Values Are String    content..campaign.name
    Response Should Contain All Property Values Are Url    content..campaign.imageUrl
    Response Should Contain All Property Values Match Regex    content..campaign.start    ${yyyy_mm_dd_hh_mm_ss}
    Response Should Contain All Property Values Match Regex    content..campaign.end    ${yyyy_mm_dd_hh_mm_ss}
    Response Should Contain All Property Values Match Regex    content..campaign.lastModifiedDate    ${yyyy_mm_dd}
    Response Should Contain All Property Values Match Regex    content..campaign.status    ${status_regex}
    Response Should Contain Property With Integer Value    page..totalElements
    Response Should Contain Property With Integer Value    page..totalPages
    Response Should Contain Property With Integer Value    page..size
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious
    
TC_O2O_00417
    [Documentation]     [API] [Apigee] [Campaign] Verify Get Campaign api without terminalId
    [Tags]      Regression     High        
    Get Campaign List    ${EMPTY}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&redeemType=${redeem_type} 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious

TC_O2O_00418
    [Documentation]     [API] [Apigee] [Campaign] Verify Get Campaign api with terminalId, but missing another data
    [Tags]      Regression     High
    [Template]    Get Campaign Without Params Return Success
    ${TERMINAL_ID}    branchId=${BRANCH_ID}&redeemType=${redeem_type}
    ${TERMINAL_ID}    brandId=${BRAND_ID}&redeemType=${redeem_type}
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}

TC_O2O_00419
    [Documentation]     [API] [Apigee] [Campaign] Verify Get Campaign api with incorrect redeemType
    [Tags]      Regression     High        
    Get Campaign List    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&redeemType=INVALID
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious

TC_O2O_00420
    [Documentation]     [API] [Apigee] [Campaign] Verify Get Campaign api with brandId & branchId do not exist in the system
    [Tags]      Regression     High
    [Template]    Get Campaign With Invalid Params Return No Data
    ${TERMINAL_ID}    brandId=1100002&branchId=${BRANCH_ID}&redeemType=${redeem_type}
    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=10006&redeemType=${redeem_type}

TC_O2O_00421
    [Documentation]     [API] [Apigee] [Campaign] Verify Get Campaign api with invalid authorization will return Invalid Access Token
    [Tags]      Regression     High
    Set Invalid Access Token
    Get Campaign List    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&redeemType=${redeem_type} 
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .displayCode    ${UNAUTHORIZED}
    Response Should Contain Property With Value    .messsage    Invalid Access Token
    Response Should Contain Property With Empty Value    .fields

TC_O2O_00422
    [Documentation]     [API] [Apigee] [Campaign] Verify Get Campaign api with invalid terminalId will return Not Found
    [Tags]      Regression     High
    Get Campaign List    ${invalid_terminal_id}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&redeemType=${redeem_type} 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious

TC_O2O_00552
    [Documentation]     [API] [Apigee] [Campaign] Verify Get Campaign api with invalid params
    [Tags]      Regression     High
    Get Campaign List    ${TERMINAL_ID}    brandId=${invalid_brand_id}&branchId=${invalid_branch_id}&redeemType=${redeem_type} 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious