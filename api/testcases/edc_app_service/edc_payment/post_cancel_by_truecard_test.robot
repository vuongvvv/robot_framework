*** Settings ***
Documentation    Regression tests to verify that payment cancel with on edc_api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/edc_app_service/edc_payment_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment
Test Teardown     Delete All Sessions
#Require UAA_Client Scope: payment.payment.write

*** Test Cases ***
TC_O2O_13747
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel success when payment_method is TrueCard and transaction_channel is EDC_ANDROID
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
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

TC_O2O_13748
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3]  Payment cancel success when payment_method is TrueCard and transaction_channel is POS
    [Tags]    Regression    Medium    Smoke
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    POS
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

TC_O2O_13749
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3]  Payment cancel success when payment_method is WALLET
    [Tags]    Regression    Medium    Smoke    UnitTest
    [Setup]    Run Keywords    Generate Gateway Header With Scope and Permission    ${ROLE_USER}    ${ROLE_USER_PASSWORD}    payment.payment.write    AND    Create RPP Gateway Header
    Post Request Payment Charge By Wallet To Prepare Data Before Cancel
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

TC_O2O_13750
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3]  Payment cancel success when payment_method is ALIPAY
    [Tags]    Regression    Medium    Smoke    UnitTest
    [Setup]    Run Keywords    Generate Gateway Header With Scope and Permission    ${EDC_APP_SERVICE_USER}    ${EDC_APP_SERVICE_PASSWORD}    payment.payment.write    AND    Create RPP Gateway Header
    Post Request Payment Charge By Alipay To Prepare Data Before Cancel
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

TC_O2O_13758
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to brand_id is null
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Post Payment Cancel By Api Version 3    { "brand_id": null, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    400
    Response Should Contain Property With Value    errors..message    Bad Request

TC_O2O_13759
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to outlet_id is empty
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    outlet_id
    Response Should Contain Property With Value    errors..message    outlet id is required

TC_O2O_13760
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to terminal_id is empty
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    terminal_id
    Response Should Contain Property With Value    errors..message    terminal id is required

TC_O2O_13761
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to trace_id is empty
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    trace_id
    Response Should Contain Property With Value    errors..message    trace id is required

TC_O2O_13762
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to brand_id is invalid
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Post Payment Cancel By Api Version 3    { "brand_id": "99099", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    0404
    Response Should Contain Property With Value    errors..message    ไม่พบรายการ

TC_O2O_13763
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to outlet_id is invalid
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "99099", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    0404
    Response Should Contain Property With Value    errors..message    ไม่พบรายการ

TC_O2O_13764
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to terminal_id is invalid
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "68099999", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    0404
    Response Should Contain Property With Value    errors..message    ไม่พบรายการ

TC_O2O_13765
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to trace_id is invalid
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "99999" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    0404
    Response Should Contain Property With Value    errors..message    ไม่พบรายการ

TC_O2O_13766
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to payment_method =truecard and charge transaction already void
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    0409
    Response Should Contain Property With Value    errors..message    ไม่สามารถยกเลิกรายการซ้ำได้

TC_O2O_13767
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to payment_method =wallet and charge transaction already void
    [Tags]    Regression    Medium    Smoke
    [Setup]    Run Keywords    Generate Gateway Header With Scope and Permission    ${EDC_APP_SERVICE_USER}    ${EDC_APP_SERVICE_PASSWORD}    payment.payment.write    AND    Create RPP Gateway Header
    Post Request Payment Charge By Wallet To Prepare Data Before Cancel
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TEST_VARIABLE_TRACE_ID}" }
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TEST_VARIABLE_TRACE_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    0409
    Response Should Contain Property With Value    errors..message    ไม่สามารถยกเลิกรายการซ้ำได้

TC_O2O_13770
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to due to access token expired
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Set Gateway Header With Expired Token
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    invalid_token
    Response Should Contain Property With Value    error_description    Access token expired: ${expire_tmn_token}

TC_O2O_13771
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to due to system cannot convert json token
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Set Gateway Header With Invalid Access Token
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    invalid_token
    Response Should Contain Property With Value    error_description    Cannot convert access token to JSON

TC_O2O_13772
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to due to no header Authorization
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Set Gateway Header Without Authorization
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    errors..property    401
    Response Should Contain Property With Value    errors..message    Full authentication is required to access this resource

TC_O2O_13773
    [Documentation]    [TrueDigitalCard: On][Cancel_EDC V3] Payment cancel fail due to invalid client scope
    [Tags]    Regression    Low
    Post Request Payment Charge By Truecard To Prepare Data Before Cancel    ${TRUE_DIGITAL_CARD}    EDC_ANDROID
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    Post Payment Cancel By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "trace_id": "${TRUE_CARD_TRACE_ID}" }
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    errors..property    1_403
    Response Should Contain Property With Value    errors..message    Forbidden
