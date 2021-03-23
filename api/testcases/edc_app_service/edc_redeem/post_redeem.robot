*** Settings ***
Documentation    [EDC] API to redeem by campaign

Resource    ../../../keywords/edc_app_service/edc_redeem_keywords.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../resources/init.robot

Suite Setup     Create RPP Gateway Header
Suite Teardown     Delete All Sessions

*** Variables ***
${brand_id}   0418377
${outlet_id}   00001
${terminal_id}   68222795
${acc_type}   THAIID
${acc_value}   1600100366042
${campaign_code}   PRO-2054

*** Test Cases ***
TC_O2O_28667
    [Documentation]    Call 'redeem by campaign'
    [Tags]    Regression    High    Smoke
    Post Issue Point    { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "acc_type":"${acc_type}", "acc_value":"${acc_value}", "amount": 5000 }
    Response Correct Code    ${SUCCESS_CODE}
    Post Redeem By Campaign     { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "acc_type":"${acc_type}", "acc_value":"${acc_value}", "campaign_type":"CUSTOMER", "campaign_code":"${campaign_code}", "action":"redeem_by_campaign" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${brand_id}
    Response Should Contain Property With Value    outlet_id    ${outlet_id}
    Response Should Contain Property With Value    terminal_id    ${terminal_id}
    Response Should Contain Property With Value    customer_ref    1600100366042
    Response Should Contain Property With String Value    coupon_code
    Response Should Contain Property With String Value    trace_id
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    tx_ref_id
    Response Should Contain Property With String Value    transaction_date

TC_O2O_28668
    [Documentation]    Call 'redeem by code'
    [Tags]    Regression    Medium    Smoke
    Post Issue Point    { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "acc_type":"${acc_type}", "acc_value":"${acc_value}", "amount": 5000 }
    Response Correct Code    ${SUCCESS_CODE}
    Post Redeem By Campaign     {"brand_id": "${brand_id}", "outlet_id": "${outlet_id}", "terminal_id": "${terminal_id}", "acc_type": "${acc_type}", "acc_value": "${acc_value}", "transaction_channel": "EDC_ANDROID", "action": "redeem_by_campaign", "campaign_code": "${campaign_code}", "campaign_type": "CUSTOMER"}
    Fetch Property From Response    .coupon_code    REWARD_CODE
    Post Redeem By Code     {"brand_id": "${brand_id}", "outlet_id": "${outlet_id}", "terminal_id": "${terminal_id}", "campaign_code": "${campaign_code}", "reward_code": "${REWARD_CODE}", "transaction_channel": "EDC_ANDROID", "campaign_type": "CUSTOMER"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${brand_id}
    Response Should Contain Property With Value    outlet_id    ${outlet_id}
    Response Should Contain Property With Value    terminal_id    ${terminal_id}
    Response Should Contain Property With Value    reward_code    ${REWARD_CODE}
    Response Should Contain Property With String Value    trace_id
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    tx_ref_id
    Response Should Contain Property With String Value    transaction_date
    Response Should Contain Property With String Value    "trueyou_id"
