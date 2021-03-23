*** Settings ***
Documentation    Tests to verify that GET CAMPAIGNS api works correctly with external client

Resource    ../../../resources/init.robot
Resource    ../../../keywords/apigee/apigee_campaign_keywords.robot
Test Setup    Run Keywords    Prepare External Ids    ${external_terminal_id}    ${external_brand_id}    ${external_branch_id}    ${TERMINAL_ID}    ${BRAND_ID}    ${BRANCH_ID}    AND    Generate Apigee Header    ${APIGEE_CLIENT_ID_MAPPING_ACTIVE_TRUE}    ${APIGEE_CLIENT_SECRET_MAPPING_ACTIVE_TRUE}
Test Teardown    Run Keywords    Delete All Sessions

*** Variables ***
${external_terminal_id}    68036691
${external_brand_id}    SG_BK
${external_branch_id}    01112

${not_mapping_external_terminal_id}    68036691999
${not_mapping_brand_id}    SG_BKABC
${not_mapping_external_branch_id}    01112999

${redeem_type}    REDEEM_BY_CAMPAIGN
${yyyy_mm_dd}    ^\\d{4}[-]\\d{2}[-]\\d{2}$
${yyyy_mm_dd_hh_mm_ss}    ^\\d{4}[-]\\d{2}[-]\\d{2}[ ]\\d{2}[:]\\d{2}[:]\\d{2}$
${status_regex}    ^(active|inactive)$ 

${invalid_terminal_id}    69000099
${invalid_redeem_type}    REDEEM_BY_CAMPAIGNABC
${internal_server_error_message}    Internal server error. Please contact weomni-support@ascendcorp.com.
*** Test Cases ***

TC_O2O_02285
    [Documentation]    [API] [Apigee] [Get Campaigns] User can get campaigns using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId
    [Tags]    Regression    High    Smoke
    Get Campaign List    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${external_branch_id}&redeemType=${redeem_type}&external=true
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    content..brandId    ${external_brand_id}
    Response Should Contain All Property Values Equal To Value    content..branchId    ${external_branch_id}
    Response Should Contain All Property Values Equal To Value    content..terminalId    ${external_terminal_id}
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
    
TC_O2O_02286
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using external brandId, external branchId, external terminalId returns 404 with invalid redeemType
    [Tags]    Regression    Normal
    Get Campaign List    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${external_branch_id}&redeemType=${invalid_redeem_type}&external=true 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    content..brandId    ${external_brand_id}  
    Response Should Contain All Property Values Equal To Value    content..branchId    ${external_branch_id}
    Response Should Contain All Property Values Equal To Value    content..terminalId    ${external_terminal_id}
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
    
TC_O2O_02287
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using external brandId, external branchId, not mapping external terminalId returns 500
    [Tags]    Regression    Normal   
    Get Campaign List    ${not_mapping_external_terminal_id}    brandId=${external_brand_id}&branchId=${external_branch_id}&redeemType=${redeem_type}&external=true 
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02288
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using external brandId, external branchId, internal terminalId returns 500
    [Tags]    Regression    Normal   
    Get Campaign List    ${TERMINAL_ID}    brandId=${external_brand_id}&branchId=${external_branch_id}&redeemType=${redeem_type}&external=true 
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02289
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using external brandId, external terminalId, not mapping external branchId returns 500
    [Tags]    Regression    Normal   
    Get Campaign List    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${not_mapping_external_branch_id}&redeemType=${redeem_type}&external=true 
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02290
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using external brandId, external terminalId, internal branchId returns 500
    [Tags]    Regression    Normal   
    Get Campaign List    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${BRANCH_ID}&redeemType=${redeem_type}&external=true 
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02291
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using external branchId, external terminalId, not mapping external brandId returns 500
    [Tags]    Regression    Normal   
    Get Campaign List    ${external_terminal_id}    brandId=${not_mapping_brand_id}&branchId=${external_branch_id}&redeemType=${redeem_type}&external=true 
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02292
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using external branchId, external terminalId, internal brandId returns 500
    [Tags]    Regression    Normal   
    Get Campaign List    ${external_terminal_id}    brandId=${BRAND_ID}&branchId=${external_branch_id}&redeemType=${redeem_type}&external=true 
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02293
    [Documentation]    [API][Apigee][Get Campaigns] Get campaign using only terminalId which consisted of different brandId. If there is one brandld which cannot be mapped, should returns 500
    [Tags]    Regression    Normal    ASCO2O-1041
    Get Campaign List    ${external_terminal_id}    external=true
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02294
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using internal brandId, internal branchId, already mapping external terminalId returns 200 when external=FALSE
    [Tags]    Regression    Normal   
    Get Campaign List    ${external_terminal_id}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&redeemType=${redeem_type}&external=false 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious
    
TC_O2O_02295
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using internal brandId, internal branchId, not mapping external terminalId returns 200 when external=FALSE
    [Tags]    Regression    Normal   
    Get Campaign List    ${not_mapping_external_terminal_id}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&redeemType=${redeem_type}&external=false 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious
    
TC_O2O_02296
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using internal brandId, internal terminalId, already mapping external branchId returns 200 when external=FALSE
    [Tags]    Regression    Normal   
    Get Campaign List    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${external_branch_id}&redeemType=${redeem_type}&external=false 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious
    
TC_O2O_02297
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using internal brandId, internal terminalId, not mapping external branchId returns 200 when external=FALSE
    [Tags]    Regression    Normal   
    Get Campaign List    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${not_mapping_external_branch_id}&redeemType=${redeem_type}&external=false 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious
    
TC_O2O_02298
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using internal branchId, internal terminalId, already mapping external brandId returns 200 when external=FALSE
    [Tags]    Regression    Normal   
    Get Campaign List    ${TERMINAL_ID}    brandId=${external_brand_id}&branchId=${BRANCH_ID}&redeemType=${redeem_type}&external=false 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious
    
TC_O2O_02299
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using internal branchId, internal terminalId, not mapping external brandId returns 200 when external=FALSE
    [Tags]    Regression    Normal   
    Get Campaign List    ${TERMINAL_ID}    brandId=${not_mapping_brand_id}&branchId=${BRANCH_ID}&redeemType=${redeem_type}&external=false 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious
    
TC_O2O_02300
    [Documentation]    [API] [Apigee] [Get Campaigns] Get campaigns using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId returns 200 when external=FALSE
    [Tags]    Regression    Normal   
    Get Campaign List    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${external_branch_id}&redeemType=${redeem_type}&external=false 
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious