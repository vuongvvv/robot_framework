*** Settings ***
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/rpp-mytruepoint/rpp_my_true_point_keywords.robot

Test Setup    Create RPP Gateway Header
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_09855
    [Documentation]    [TYK - Point&Privilege] Verify user is able to void (By Campaign) burning point successfully
    [Tags]    Regression    ExcludeSmoke
    Generate Transaction Reference Id
    Post Redeem By Campaign    { "tx_ref_id" : "${TRANSACTION_REFERENCE_ID}", "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "acc_type" : "${ACCOUNT_TYPE}", "acc_value" : "${ACCOUNT_VALUE}", "campaign_code" : "${CAMPAIGN_CODE}", "campaign_type":"CUSTOMER", "mobile":"0853397704" }
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Trace Id
    Fetch Transaction Reference Id
    Post Void    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}","tx_ref_id" : "${TEST_DATA_TRANSACTION_REFERENCE_ID}", "trace_id": "${TEST_DATA_TRACE_ID}" }
    Response Correct Code    ${SUCCESS_CODE}