*** Settings ***
Documentation    E2E tests to verify that payment charge and void on edc_api works correctly
Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/common/rpp_gateway_common.robot
Resource    ../../../api/keywords/edc_app_service/edc_payment_keywords.robot
Resource    ../../../api/keywords/edc_app_service/edc_report_keywords.robot
Resource    ../../../api/keywords/payment/payment_resource_keywords.robot
Resource    ../../../api/keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Run Keywords    Generate Gateway Header With Scope and Permission    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    payment.payment.write,payment.payment.read    AND    Create RPP Gateway Header
Test Teardown     Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
@{payment_method_list}    WALLET    ALIPAY    TRUECARD

*** Test Cases ***
TC_O2O_13777
    [Documentation]    [TrueDigitalCard: On] System allow to charge and void by truecard via OTP
    [Tags]    Regression    High    Smoke    Sanity    E2E    payment
    #Step0: Clear pending settlement transaction
    Post Request Settlement Report    {"brand_id":"${BRAND_ID}","outlet_id":"${BRANCH_ID}","terminal_id":"${TERMINAL_ID}","username":"D9FE9063-0EC6-475F-A61F-5FB821E47A1F","password":"1111"}
    #Step1: Request OTP by truecard
    Post Request Otp Of Truecard    { "truecard": "${TRUE_DIGITAL_CARD}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otp_ref
    Response Should Contain Property With String Value    linking_agreement
    Response Should Contain Property With String Value    auth_code
    Response Should Contain Property With String Value    mobile
    Get Otp Reference Of Truecard
    Get Authorized Code Of Truecard
    Get Mobile Number Of Truecard
    #Step2: Payment charge success by TrueCard
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "E2E Automation to verify charge by truecard via OTP", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${BRAND_ID}
    Response Should Contain Property With Value    outlet_id    ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id    ${TERMINAL_ID}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    trace_id
    Response Should Contain Property With String Value    transaction_reference_id
    Response Should Contain Property With String Value    transaction_date
    Response Should Contain Property With String Value    "trueyou_id"
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    payment_method    TRUECARD
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    transaction_channel    EDC_ANDROID
    Get True Card Transaction Reference Id
    Get Trace Id Of Charge By Truecard
    # Step3: View preview settlement report
    Post Request Preview Settlement Report    {"brand_id":"${BRAND_ID}","outlet_id":"${BRANCH_ID}","terminal_id":"${TERMINAL_ID}","username":"D9FE9063-0EC6-475F-A61F-5FB821E47A1F","password":"1111"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${BRAND_ID}
    Response Should Contain Property With String Value    brand_name
    Response Should Contain Property With Value    outlet_id    ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id    ${TERMINAL_ID}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With Value    payment.total    1
    Response Should Contain Property With Value    payment.amount     3.00
    Response Should Contain All Property Values Include In List    payment.methods..payment_method    ${payment_method_list}
    #Step4: Payment charge cancel success
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${BRAND_ID}
    Response Should Contain Property With Value    outlet_id    ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id    ${TERMINAL_ID}
    Response Should Contain Property With Value    trace_id    ${TRUE_CARD_TRACE_ID}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    tx_ref_id
    Response Should Contain Property With String Value    transaction_date
    Response Should Contain Property With String Value    "trueyou_id"
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Empty Value    payment_code
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    payment_method    TRUECARD
    Response Should Contain Property With Value    transaction_type    PAYMENT_CANCEL
    Response Should Contain Property With Empty Value    point
    Response Should Contain Property With Empty Value    acc_type
    Response Should Contain Property With Empty Value    acc_value
    Response Should Contain Property With Empty Value    campaign_name
    Response Should Contain Property With String Value    voided_date
    # Step5: Get Payment Status By Transaction Reference ID after void success
    Get Payment Query    ${TRUE_CARD_TX_REF}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    data.isv_payment_ref    ${TRUE_CARD_TX_REF}
    Response Should Contain Property With Value    data.metadata.description    E2E Automation to verify charge by truecard via OTP
    Response Should Contain Property With Value    data.metadata.user_mobile    0000000000
    Response Should Contain Property With Value    data.refunded      ${${amount}}
    Response Should Contain Property With String Value    data.refunds..refund_id
    Response Should Contain Property With Value    data.refunds..isv_refund_ref    ${TRUE_CARD_TX_REF}C
    Response Should Contain Property With Value    data.refunds..amount    ${${amount}}
    Response Should Contain Property With String Value    data.refunds..created
    Response Should Contain Property With Value    data.refunds..status    succeeded
    Response Should Contain Property With Value    data.refunds..response_code    success
    Response Should Contain Property With Value    data.refunds..response_message    Success
    # Step6: View settlement report
    Post Request Settlement Report    {"brand_id":"${BRAND_ID}","outlet_id":"${BRANCH_ID}","terminal_id":"${TERMINAL_ID}","username":"D9FE9063-0EC6-475F-A61F-5FB821E47A1F","password":"1111"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${BRAND_ID}
    Response Should Contain Property With String Value    brand_name
    Response Should Contain Property With Value    outlet_id    ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id    ${TERMINAL_ID}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    payment.total
    Response Should Contain Property With String Value    payment.amount
    Response Should Contain All Property Values Include In List    payment.methods..payment_method    ${payment_method_list}
    # Step7: View summary report
    Get Summary Report    brand_id=${BRAND_ID}&outlet_id=${BRANCH_ID}&terminal_id=${TERMINAL_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Include In List    payments..payment_method    ${payment_method_list}
    # Step8: View detail summary report
    Get Detail Summary Report    brand_id=${BRAND_ID}&outlet_id=${BRANCH_ID}&terminal_id=${TERMINAL_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    terminal_id    ${TERMINAL_ID}
    Response Should Contain All Property Values Include In List    payment..transaction_name    ${payment_method_list}

TC_O2O_13784
    [Documentation]    [TrueDigitalCard: On] System allow to void by TMN Wallet via edc_void_v3
    [Tags]    Regression    High    Smoke    Sanity    E2E    payment
    #Step1: Payment charge success by TMNWallet
    Post Request Payment Charge By Wallet To Prepare Data Before Cancel
    # Step2: Query Payment Status
    Get Transaction Ref Number
    Get RPP Payment Status
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Empty Value  refund
    # Step3: Payment charge cancel success
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TEST_VARIABLE_TRACE_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${BRAND_ID}
    Response Should Contain Property With Value    outlet_id    ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id    ${TERMINAL_ID}
    Response Should Contain Property With Value    trace_id    ${TEST_VARIABLE_TRACE_ID}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    tx_ref_id
    Response Should Contain Property With String Value    transaction_date
    Response Should Contain Property With String Value    "trueyou_id"
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With String Value    payment_code
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    payment_method    WALLET
    Response Should Contain Property With Value    transaction_type    PAYMENT_CANCEL
    Response Should Contain Property With Empty Value    point
    Response Should Contain Property With Empty Value    acc_type
    Response Should Contain Property With Empty Value    acc_value
    Response Should Contain Property With Empty Value    campaign_name
    Response Should Contain Property With String Value    voided_date
    # Step4: Query Payment Status
    Get RPP Payment Status
    Response Should Contain Property With Value    payment.status     SUCCESS
    Response Should Contain Property With Value    payment.code       1_success
    Response Should Contain Property With Value    payment.message    Success
    Response Should Contain Property With Value    refund..amount     ${amount}
    Response Should Contain Property With Value    refund..status     SUCCESS
    Response Should Contain Property With Value    refund..code       1_success
    Response Should Contain Property With Value    refund..message    Success

TC_O2O_13785
    [Documentation]    [TrueDigitalCard: On] System allow to void by ALIPAY via edc_void_v3
    [Tags]    Regression    High    Smoke    Sanity    E2E    payment
    #Step1: Payment charge success by ALIPAY
    Post Request Payment Charge By Alipay To Prepare Data Before Cancel
    # Step2: Query Payment Status
    Get Transaction Ref Number
    Get RPP Payment Status
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    FAILED
    Response Should Contain Property With Value    error_code    TRADE_NOT_EXIST
    Response Should Contain Property With Null Value    error_description
    Response Should Contain Property With String Value    ascend_money_time
    Response Should Contain Property With Null Value    ascend_money_trans_id
    Response Should Contain Property With Null Value    payment_status
    #Step3: Payment charge cancel success
    Post Payment Cancel By Api Version 3    { "brand_id": "${ALIPAY_BRAND_ID}", "outlet_id": "${ALIPAY_ฺBRANCH_ID}", "terminal_id": "${ALIPAY_TERMINAL_ID}", "trace_id": "${TEST_VARIABLE_TRACE_ID}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${ALIPAY_BRAND_ID}
    Response Should Contain Property With Value    outlet_id    ${ALIPAY_ฺBRANCH_ID}
    Response Should Contain Property With Value    terminal_id    ${ALIPAY_TERMINAL_ID}
    Response Should Contain Property With Value    trace_id    ${TEST_VARIABLE_TRACE_ID}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    tx_ref_id
    Response Should Contain Property With String Value    transaction_date
    Response Should Contain Property With String Value    "trueyou_id"
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With String Value    payment_code
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    payment_method    ALIPAY
    Response Should Contain Property With Value    transaction_type    PAYMENT_CANCEL
    Response Should Contain Property With Empty Value    point
    Response Should Contain Property With Empty Value    acc_type
    Response Should Contain Property With Empty Value    acc_value
    Response Should Contain Property With Empty Value    campaign_name
    Response Should Contain Property With String Value    voided_date
    #Step4 View preview settlement report
    Post Request Preview Settlement Report    {"brand_id":"${ALIPAY_BRAND_ID}","outlet_id":"${ALIPAY_ฺBRANCH_ID}","terminal_id":"${ALIPAY_TERMINAL_ID}","username":"D9FE9063-0EC6-475F-A61F-5FB821E47A1F","password":"1111"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${ALIPAY_BRAND_ID}
    Response Should Contain Property With String Value    brand_name
    Response Should Contain Property With Value    outlet_id    ${ALIPAY_ฺBRANCH_ID}
    Response Should Contain Property With Value    terminal_id    ${ALIPAY_TERMINAL_ID}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    payment.total
    Response Should Contain Property With String Value    payment.amount
    Response Should Contain All Property Values Include In List    payment.methods..payment_method    ${payment_method_list}
    #Step5: View settlement report
    Post Request Settlement Report    {"brand_id":"${ALIPAY_BRAND_ID}","outlet_id":"${ALIPAY_ฺBRANCH_ID}","terminal_id":"${ALIPAY_TERMINAL_ID}","username":"D9FE9063-0EC6-475F-A61F-5FB821E47A1F","password":"1111"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${ALIPAY_BRAND_ID}
    Response Should Contain Property With String Value    brand_name
    Response Should Contain Property With Value    outlet_id    ${ALIPAY_ฺBRANCH_ID}
    Response Should Contain Property With Value    terminal_id    ${ALIPAY_TERMINAL_ID}
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    payment.total
    Response Should Contain Property With String Value    payment.amount
    Response Should Contain All Property Values Include In List    payment.methods..payment_method    ${payment_method_list}
    #Step6: View summary report
    Get Summary Report    brand_id=${ALIPAY_BRAND_ID}&outlet_id=${ALIPAY_ฺBRANCH_ID}&terminal_id=${ALIPAY_TERMINAL_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Include In List    payments..payment_method    ${payment_method_list}
    #Step7: View detail summary report
    Get Detail Summary Report    brand_id=${ALIPAY_BRAND_ID}&outlet_id=${ALIPAY_ฺBRANCH_ID}&terminal_id=${ALIPAY_TERMINAL_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    terminal_id    ${ALIPAY_TERMINAL_ID}
    Response Should Contain Property With Value    payment..transaction_name    ALIPAY
