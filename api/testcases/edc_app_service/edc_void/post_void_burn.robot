*** Settings ***
Documentation    [EDC] API to void transaction

Resource    ../../../keywords/edc_app_service/edc_void_keywords.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../resources/init.robot

Suite Setup     Create RPP Gateway Header
Suite Teardown     Delete All Sessions

*** Variables ***
${brand_id}   0418359
${outlet_id}   00001
${terminal_id}   68170951
${acc_type}   THAIID
${acc_value}   1600100366042
${campaign_code}   PRO-2054

*** Test Cases ***
TC_O2O_26430
    [Documentation]    Call 'void version 1'
    [Tags]    Regression    High    Smoke
    Post Issue Point    { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "acc_type":"${acc_type}", "acc_value":"${acc_value}", "amount": 5000 }
    Response Correct Code    ${SUCCESS_CODE}
    Sleep   10s
    Post Redeem By Campaign     { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "acc_type":"${acc_type}", "acc_value":"${acc_value}", "campaign_type":"CUSTOMER", "campaign_code":"${campaign_code}", "action":"redeem_by_campaign" }
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .trace_id    TRACE_ID
    Post Void Version 1     { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "trace_id":"${TRACE_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${brand_id}
    Response Should Contain Property With Value    outlet_id    ${outlet_id}
    Response Should Contain Property With Value    terminal_id    ${terminal_id}
    Response Should Contain Property With Value    trace_id    ${TRACE_ID}
    Response Should Contain Property With Value    transaction_type     REDEEM_ROLLBACK
    Response Should Contain Property With Value    acc_type     ${acc_type}
    Response Should Contain Property With Value    acc_value     ${acc_value}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    transaction_date
    Response Should Contain Property With String Value    "trueyou_id"

TC_O2O_26420
    [Documentation]    Call 'void version 2'
    [Tags]    Regression    High    Smoke
    Post Issue Point    { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "acc_type":"${acc_type}", "acc_value":"${acc_value}", "amount": 5000 }
    Response Correct Code    ${SUCCESS_CODE}
    Sleep   10s
    Post Redeem By Campaign     { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "acc_type":"${acc_type}", "acc_value":"${acc_value}", "campaign_type":"CUSTOMER", "campaign_code":"${campaign_code}", "action":"redeem_by_campaign" }
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .tx_ref_id    TX_REF_ID
    Fetch Property From Response    .trace_id    TRACE_ID
    Post Void Version 2     { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "trace_id":"${TRACE_ID}", "tx_ref_id":"${TX_REF_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${brand_id}
    Response Should Contain Property With Value    outlet_id    ${outlet_id}
    Response Should Contain Property With Value    terminal_id    ${terminal_id}
    Response Should Contain Property With Value    trace_id    ${TRACE_ID}
    Response Should Contain Property With Value    tx_ref_id    ${TX_REF_ID}
    Response Should Contain Property With Value    transaction_type     REDEEM_ROLLBACK
    Response Should Contain Property With Value    acc_type     ${acc_type}
    Response Should Contain Property With Value    acc_value     ${acc_value}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    transaction_date
    Response Should Contain Property With String Value    "trueyou_id"

TC_O2O_26421
    [Documentation]    Call 'void version 3'
    [Tags]    Regression    High    Smoke
    Post Issue Point    { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "acc_type":"${acc_type}", "acc_value":"${acc_value}", "amount": 5000 }
    Response Correct Code    ${SUCCESS_CODE}
    Sleep   10s
    Post Redeem By Campaign     { "brand_id":"${brand_id}", "outlet_id":"${outlet_id}", "terminal_id":"${terminal_id}", "acc_type":"${acc_type}", "acc_value":"${acc_value}", "campaign_type":"CUSTOMER", "campaign_code":"${campaign_code}", "action":"redeem_by_campaign" }
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .trace_id    TRACE_ID
    Generate Robot Automation Header    ${EDC_APP_SERVICE_USER}    ${EDC_APP_SERVICE_PASSWORD}
    Post Void Version 3    {"brand_id": "${brand_id}", "outlet_id": "${outlet_id}", "terminal_id": "${terminal_id}", "trace_id": "${TRACE_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${brand_id}
    Response Should Contain Property With Value    outlet_id    ${outlet_id}
    Response Should Contain Property With Value    terminal_id    ${terminal_id}
    Response Should Contain Property With Value    trace_id     ${TRACE_ID}
    Response Should Contain Property With Value    transaction_type     REDEEM_ROLLBACK
    Response Should Contain Property With Value    acc_type     ${acc_type}
    Response Should Contain Property With Value    acc_value     ${acc_value}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    tx_ref_id
    Response Should Contain Property With String Value    transaction_date
    Response Should Contain Property With String Value    "trueyou_id"
