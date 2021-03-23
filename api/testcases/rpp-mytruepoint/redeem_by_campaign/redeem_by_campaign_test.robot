*** Settings ***
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/rpp-mytruepoint/rpp_my_true_point_keywords.robot

Test Setup    Create RPP Gateway Header
Test Teardown    Delete All Sessions

*** Variables ***
${invalid_terminal_id}    532320
${invalid_brand_id}    532320
${invalid_branch_id}    532320

*** Test Cases ***
TC_O2O_09854
    [Documentation]    [TYK - Point&Privilege] Verify user burns (By Campaign) point successfully
    [Tags]    Regression    ExcludeSmoke
    Generate Transaction Reference Id
    Post Redeem By Campaign    { "tx_ref_id" : "${TRANSACTION_REFERENCE_ID}", "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "acc_type" : "${ACCOUNT_TYPE}", "acc_value" : "${ACCOUNT_VALUE}", "campaign_code" : "${CAMPAIGN_CODE}", "campaign_type":"CUSTOMER", "mobile":"${CUSTOMER_MOBILE}" }
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_08581
    [Documentation]    Request with brand_id, outlet_id and terminal_id are invalid returns 400
    [Tags]    Regression    ExcludeSmoke
    Generate Transaction Reference Id
    Post Redeem By Campaign    { "tx_ref_id" : "${TRANSACTION_REFERENCE_ID}", "brand_id": "${invalid_brand_id}", "outlet_id": "${invalid_branch_id}", "terminal_id": "${invalid_terminal_id}", "acc_type" : "${ACCOUNT_TYPE}", "acc_value" : "${ACCOUNT_VALUE}", "campaign_code" : "${CAMPAIGN_CODE}", "campaign_type":"CUSTOMER", "mobile":"${CUSTOMER_MOBILE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    error.code    API_3_PARTY
    Response Should Contain Property With Value    error.message    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้
    Response Should Contain Property With Value    error.display_code    4102
    Response Should Contain Property Value Is String Or Empty List    error.errors

TC_O2O_08576
    [Documentation]    Request with campaign type is MERCHANT returns 200
    [Tags]    Regression    ExcludeSmoke
    Generate Transaction Reference Id
    Post Redeem By Campaign    { "tx_ref_id" : "${TRANSACTION_REFERENCE_ID}", "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "acc_type" : "${ACCOUNT_TYPE}", "acc_value" : "${ACCOUNT_VALUE}", "campaign_code" : "${CAMPAIGN_CODE}", "campaign_type":"MERCHANT", "mobile":"${MERCHANT_MOBILE}" }
    Response Correct Code    ${SUCCESS_CODE}