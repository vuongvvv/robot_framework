*** Variables ***
${valid_clientTrx_id}    AutomateTest001
${invalid_clientTrx_id}    AutomateTest000
${charge_alipay_success}    Automate_ali_test0001
${void_alipay_success}    Automate_ali_test0002
${charge_alipay_fail}    Automate_ali_fail0001

*** Settings ***
Documentation    Tests to verify that Get Payment Status by clientTrxId api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/apigee/apigee_keywords.robot
Resource    ../../../keywords/apigee/apigee_payment_keywords.robot
Test Setup    Generate Apigee Header
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_09882
    [Documentation]    Query successful with clientTrxId
    [Tags]    Medium    Smoke    Regression
    Get Apigee Payment Status By ClientTrxId    ${TERMINAL_ID}    ${valid_clientTrx_id}    ${BRAND_ID}      ${BRANCH_ID}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payment..status    SUCCESS
    Response Should Contain Property With Value    .payment..code      1_success
    Response Should Contain Property With Value    .payment..message   Success
    Response Should Contain Property With Empty Value    .refund

TC_O2O_09884
    [Documentation]    Query fail due to invalid data
    [Tags]    Medium    Smoke    Regression
    Get Apigee Payment Status By ClientTrxId    ${TERMINAL_ID}    ${invalid_clientTrx_id}    ${BRAND_ID}      ${BRANCH_ID}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    bad_request
    Response Should Contain Property With Value    .message    Transaction does not exist.

TC_O2O_20526
    [Documentation]    Verify search status when only Alipay charge status is success
    [Tags]    Medium    Smoke    Regression
    Get Apigee Payment Status By ClientTrxId    ${ALIPAY_TERMINAL_ID}    ${charge_alipay_success}    ${ALIPAY_BRAND_ID}    ${ALIPAY_ฺBRANCH_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Null Value    error_code
    Response Should Contain Property With Null Value    error_description
    Response Should Contain All Property Values Are String    ascend_money_time
    Response Should Contain All Property Values Are String    ascend_money_trans_id
    Response Should Contain Property With Value    payment_status    SUCCESS

TC_O2O_20527
    [Documentation]    Verify search status when Alipay charge and cancel status is success
    [Tags]    Medium    Smoke    Regression
    Get Apigee Payment Status By ClientTrxId    ${ALIPAY_TERMINAL_ID}    ${void_alipay_success}    ${ALIPAY_BRAND_ID}    ${ALIPAY_ฺBRANCH_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Null Value    error_code
    Response Should Contain Property With Null Value    error_description
    Response Should Contain All Property Values Are String    ascend_money_time
    Response Should Contain All Property Values Are String    ascend_money_trans_id
    Response Should Contain Property With Value    payment_status    CLOSED

TC_O2O_20528
    [Documentation]    Verify search status when  Alipay status is fail
    [Tags]    Medium    Smoke    Regression
    Get Apigee Payment Status By ClientTrxId    ${ALIPAY_TERMINAL_ID}    ${charge_alipay_fail}    ${ALIPAY_BRAND_ID}    ${ALIPAY_ฺBRANCH_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    FAILED
    Response Should Contain Property With Value    error_code    TRADE_NOT_EXIST
    Response Should Contain Property With Null Value    error_description
    Response Should Contain All Property Values Are String    ascend_money_time
    Response Should Contain Property With Null Value    ascend_money_trans_id
    Response Should Contain Property With Null Value    payment_status
