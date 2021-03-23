*** Settings ***
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/common/true_you_common.robot
Resource    ../../../keywords/rpp-mytruepoint/rpp_my_true_point_keywords.robot

Test Setup    Create RPP Gateway Header
Test Teardown    Delete All Sessions

*** Variables ***
${invalid_terminal_id}    532320
${invalid_brand_id}    532320
${invalid_branch_id}    532320
${reward_code}    108546425181752625

*** Test Cases ***
TC_O2O_09853
    [Documentation]    [TYK - Point&Privilege] Verify user burns (By Code) point successfully
    [Tags]    ExcludeSmoke    Regression
    Generate Transaction Reference Id
    Generate Reward Code By Campaign    ${CAMPAIGN_CODE}
    Post Redeem By Code    { "tx_ref_id" : "${TRANSACTION_REFERENCE_ID}", "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "acc_type" : "${ACCOUNT_TYPE}", "acc_value" : "${ACCOUNT_VALUE}", "campaign_code" : "${CAMPAIGN_CODE}", "reward_code" : "${TEST_DATA_REWARD_CODE}", "action" : "redeem_by_code", "campaign_type":"CUSTOMER", "mobile":"${CUSTOMER_MOBILE}" }
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_08582
    [Documentation]    Request with terminal id, brand id, and branch id are invalid returns 400
    [Tags]    Regression
    Generate Transaction Reference Id
    Post Redeem By Code    { "tx_ref_id" : "${TRANSACTION_REFERENCE_ID}", "brand_id": "${invalid_brand_id}", "outlet_id": "${invalid_branch_id}", "terminal_id": "${invalid_terminal_id}", "acc_type" : "${ACCOUNT_TYPE}", "acc_value" : "${ACCOUNT_VALUE}", "campaign_code" : "${CAMPAIGN_CODE}", "reward_code" : "${reward_code}", "action" : "redeem_by_code", "campaign_type":"CUSTOMER", "mobile":"${CUSTOMER_MOBILE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}