*** Settings ***
Documentation    Tests to verify that GET TRUE YOU CARD INFORMATION api works correctly with external client

Resource    ../../../resources/init.robot   
Resource    ../../../keywords/apigee/apigee_privilege_keywords.robot
Test Setup    Run Keywords    Prepare External Ids    ${external_terminal_id}    ${external_brand_id}    ${external_branch_id}    ${TERMINAL_ID}    ${BRAND_ID}    ${BRANCH_ID}    AND    Generate Apigee Header    ${APIGEE_CLIENT_ID_MAPPING_ACTIVE_TRUE}    ${APIGEE_CLIENT_SECRET_MAPPING_ACTIVE_TRUE}
Test Teardown    Delete All Sessions

*** Variables ***
${external_terminal_id}    68036691
${external_brand_id}    SG_BK
${external_branch_id}    01112

${not_mapping_external_terminal_id}    68036691999
${not_mapping_brand_id}    SG_BKABC
${not_mapping_external_branch_id}    01112999

${yyyy_mm_dd}    ^\\d{4}[-]\\d{2}[-]\\d{2}$
${mm_yy}    \\d{2}[/]\\d{2}
${slip_type_regex}    (1|2|3|4|5)

${invalid_account_type}    THAIIDABC
${invalid_account_value}    2000000000107
${internal_server_error_message}    Internal server error. Please contact weomni-support@ascendcorp.com.
*** Test Cases ***    
TC_O2O_02268
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] User can get TrueYou Card Information using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId
    [Tags]    Regression    High    Smoke
    Get True You Privilege    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=true
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
    Response Should Contain Property With Value    slipType.description    You are True

TC_O2O_02269
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using already mapping external brandId, branchId, and terminalId returns 400 when account value is invalid
    [Tags]    Regression    Medium   
    Get True You Privilege    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${invalid_account_value}&external=true
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
    Response Should Contain Property With Value    slipType.description    You are Non-True
    
TC_O2O_02270
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using already mapping external brandId, branchId, and terminalId returns 400 when account type is invalid
    [Tags]    Regression    Medium   
    Get True You Privilege    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${external_branch_id}&accountType=${invalid_account_type}&accountValue=${ACCOUNT_VALUE}&external=true
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0104
    Response Should Contain Property With Value    .messsage    ไม่พบข้อมูลลูกค้าในระบบทรู
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02271
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using already mapping external brandId, branchId, and not mapping external terminalId returns 500
    [Tags]    Regression    Medium   
    Get True You Privilege    ${not_mapping_external_terminal_id}    brandId=${external_brand_id}&branchId=${external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=true
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02272
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using already mapping external brandId, branchId, and internal terminalId returns 500
    [Tags]    Regression    Medium   
    Get True You Privilege    ${TERMINAL_ID}    brandId=${external_brand_id}&branchId=${external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=true
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02273
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using already mapping external brandId, terminalId, and not mapping external branchId returns 500
    [Tags]    Regression    Medium   
    Get True You Privilege    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${not_mapping_external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=true
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02274
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using already mapping external brandId, terminalId, and internal branchId returns 500
    [Tags]    Regression    Medium   
    Get True You Privilege    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=true
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02275
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using already mapping external branchId, terminalId, and not mapping external brandId returns 500
    [Tags]    Regression    Medium   
    Get True You Privilege    ${external_terminal_id}    brandId=${not_mapping_brand_id}&branchId=${external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=true
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02276
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using already mapping external branchId, terminalId, and internal brandId returns 500
    [Tags]    Regression    Medium   
    Get True You Privilege    ${external_terminal_id}    brandId=${BRAND_ID}&branchId=${external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=true
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .code    ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    .displayCode    m002
    Response Should Contain Property With Value    .messsage    ${internal_server_error_message}
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02277
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using internal brandId, branchId, and already mapping external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Get True You Privilege    ${external_terminal_id}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=false
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0709
    Response Should Contain Property With Value    .messsage    ไม่พบข้อมูลบัตรของท่าน
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02278
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using internal brandId, branchId, and not mapping external terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Get True You Privilege    ${not_mapping_external_terminal_id}    brandId=${BRAND_ID}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=false
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0709
    Response Should Contain Property With Value    .messsage    ไม่พบข้อมูลบัตรของท่าน
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_02279
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using internal brandId, terminalId, and already mapping external branchId returns 200 when external=FALSE
    [Tags]    Regression    Medium   
    Get True You Privilege    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=false
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
    
TC_O2O_02280
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using internal brandId,terminalId, and not mapping external branchId returns 200 when external=FALSE
    [Tags]    Regression    Medium   
    Get True You Privilege    ${TERMINAL_ID}    brandId=${BRAND_ID}&branchId=${not_mapping_external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=false
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

TC_O2O_02281
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using internal terminalId, branchId, and already mapping external brandId returns 200 when external=FALSE
    [Tags]    Regression    Medium   
    Get True You Privilege    ${TERMINAL_ID}    brandId=${external_brand_id}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=false
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
    
TC_O2O_02282
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using internal terminalId, branchId, and not mapping external brandId returns 200 when external=FALSE
    [Tags]    Regression    Medium   
    Get True You Privilege    ${TERMINAL_ID}    brandId=${not_mapping_brand_id}&branchId=${BRANCH_ID}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=false
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
    
TC_O2O_02283
    [Documentation]    [API] [Apigee] [Get TrueYou Card Information] Get TrueYou Card Information using external brandId, external branchId, external terminalId that are already map with internal brandId, branchId, terminalId returns 400 when external=FALSE
    [Tags]    Regression    Medium   
    Get True You Privilege    ${external_terminal_id}    brandId=${external_brand_id}&branchId=${external_branch_id}&accountType=${ACCOUNT_TYPE}&accountValue=${ACCOUNT_VALUE}&external=false
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    0709
    Response Should Contain Property With Value    .messsage    ไม่พบข้อมูลบัตรของท่าน
    Response Should Contain Property With Empty Value    .fields