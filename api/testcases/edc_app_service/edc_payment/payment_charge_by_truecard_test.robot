*** Settings ***
Documentation    Regression tests to verify that payment charge on edc_api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/edc_app_service/edc_payment_keywords.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment
Test Teardown     Delete All Sessions
#Require UAA_Client Scope: payment.payment.write

*** Test Cases ***
TC_O2O_13701
    [Documentation]    [TrueDigitalCard: On] Payment charge success by TrueCard when transaction_channel fill in data =EDC_ANDROID
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
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

TC_O2O_13702
    [Documentation]    [TrueDigitalCard: On] Payment charge success by TrueCard when transaction_channel fill in data =POS
    [Tags]    Regression    Medium    Smoke
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "POS" }
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
    Response Should Contain Property With Value    transaction_channel    POS

TC_O2O_13703
    [Documentation]    [TrueDigitalCard: On] Payment charge success by TrueCard when transaction_channel fill in data =TSM
    [Tags]    Regression    Medium    Smoke
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "TSM" }
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
    Response Should Contain Property With Value    transaction_channel    TSM

TC_O2O_13704
    [Documentation]    [TrueDigitalCard: On] Payment charge success by TrueCard when transaction_channel fill in data =POS_PARTNER
    [Tags]    Regression    Medium    Smoke
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "POS_PARTNER" }
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
    Response Should Contain Property With Value    transaction_channel    POS_PARTNER

TC_O2O_13705
    [Documentation]    [TrueDigitalCard: On] Payment charge success by TrueCard when transaction_channel fill in data =TM4
    [Tags]    Regression    Medium    Smoke
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "TM4" }
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
    Response Should Contain Property With Value    transaction_channel    TM4

TC_O2O_13706
    [Documentation]    [TrueDigitalCard: On] Payment charge success by TrueCard when transaction_channel fill in data =EDC
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC" }
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
    Response Should Contain Property With Value    transaction_channel    EDC

TC_O2O_13707
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to fill in transaction_channel dosen't truly exist and All fill in data correct
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_IOS" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    transaction_channel
    Response Should Contain Property With Value    errors..message    transaction_channel is invalid

TC_O2O_13708
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input invalid brand_id
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "12345678901234567890", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    4102
    Response Should Contain Property With Value    errors..message    ข้อมูลร้านค้าไม่ถูกต้อง ไม่สามารถดำเนินการได้

TC_O2O_13709
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input invalid outlet_id
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "12345678901234567890", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_Bad Request
    Response Should Contain Property With Value    errors..message    Merchant does not exist.

TC_O2O_13710
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input Outlet_id over maximum length
    [Tags]    Regression    Low
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "123456789012345678901", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_outletId
    Response Should Contain Property With Value    errors..message    length must be less than or equal to 20

TC_O2O_13711
    [Documentation]    [TrueDigitalCard: On] Payment charge success by TrueCard when input invalid Terminal_id
    [Tags]    Regression    Medium    Smoke
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "12345678901234567890", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    brand_id    ${BRAND_ID}
    Response Should Contain Property With Value    outlet_id    ${BRANCH_ID}
    Response Should Contain Property With Value    terminal_id    12345678901234567890
    Response Should Contain Property With String Value    batch_id
    Response Should Contain Property With String Value    trace_id
    Response Should Contain Property With String Value    transaction_reference_id
    Response Should Contain Property With String Value    transaction_date
    Response Should Contain Property With String Value    "trueyou_id"
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    payment_method    TRUECARD
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    transaction_channel    EDC_ANDROID

TC_O2O_13712
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input Terminal_id over maximum length
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "123456789012345678901", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_terminalId
    Response Should Contain Property With Value    errors..message    length must be less than or equal to 20

TC_O2O_13713
    [Documentation]    [TrueDigitalCard: On] Payment charge fail by TrueCard when input invalid otp_ref
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "INVALID", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_invalid_otp
    Response Should Contain Property With Value    errors..message    The requested otp is invalid.

TC_O2O_13714
    [Documentation]    [TrueDigitalCard: On] Payment charge fail by due to input invalid otp_code
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "111112", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_invalid_otp
    Response Should Contain Property With Value    errors..message    The requested otp is invalid.

TC_O2O_13715
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input invalid auth_code
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "c0f5791633b5d1d784648032841e9663", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_invalid_auth_code
    Response Should Contain Property With Value    errors..message    The requested auth code is invalid.

TC_O2O_13716
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input invalid mobile number
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "0611111111", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_invalid_account
    Response Should Contain Property With Value    errors..message    Tmn account does not exist.

TC_O2O_13718
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to brand_id is null
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": null, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    brand_id
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13719
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to outlet_id is empty
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    outlet_id
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13720
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to terminal_id is empty
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    terminal_id
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13721
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to amount is empty
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    amount
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13722
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to currency is empty
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    currency
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13723
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to otp_ref is empty
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    otp_ref
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13724
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to otp_code is null
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": null, "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    otp_code
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13725
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to auth_code is empty
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    auth_code
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13726
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to transaction_channel is null
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": null }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    transaction_channel
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13727
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to mobile is null
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": null, "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    mobile
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13728
    [Documentation]    [TrueDigitalCard: On] Payment charge success by TrueCard when description is null
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": null, "transaction_channel": "EDC_ANDROID" }
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

TC_O2O_13729
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input description with html tag
    [Tags]    Regression    Medium    Smoke
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": ${BRAND_ID}, "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "<any value>", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_description
    Response Should Contain Property With Value    errors..message    The HTML tag are not allowed

TC_O2O_13730
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input amount over maximum length
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "1234567890", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    amount
    Response Should Contain Property With Value    errors..message    length must be less than 10

TC_O2O_13731
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to amount with point decimal
    [Tags]    Regression    Medium    Smoke
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "27.81", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    amount
    Response Should Contain Property With Value    errors..message    amount is invalid

TC_O2O_13732
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to amount is not positove value
    [Tags]    Regression    Medium    Smoke
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "-2700", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    amount
    Response Should Contain Property With Value    errors..message    amount is invalid

TC_O2O_13733
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to currency dosen't truly exist and All fill in data correct
    [Tags]    Regression    Medium    Smoke
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "CNY", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    currency
    Response Should Contain Property With Value    errors..message    currency is invalid

TC_O2O_13734
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input mobile no.less than 10 digits
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "090990999", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    mobile
    Response Should Contain Property With Value    errors..message    mobile is invalid

TC_O2O_13735
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input mobile no.more than 10 digits
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "09099099909", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    mobile
    Response Should Contain Property With Value    errors..message    mobile is invalid

TC_O2O_13736
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input mobile with special character
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "89-9998333", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    mobile
    Response Should Contain Property With Value    errors..message    mobile is invalid

TC_O2O_13737
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to input description more than 250 digits
    [Tags]    Regression    Medium    Smoke
    Generate Transaction Reference  251
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "${TRANSACTION_REFERENCE}", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    description
    Response Should Contain Property With Value    errors..message    length must be less than or equal to 250

TC_O2O_13738
    [Documentation]    [TrueDigitalCard: On] Payment charge success when input description more than 100 digits
    [Tags]    Regression    Medium    Smoke
    Generate Transaction Reference  101
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "${TRANSACTION_REFERENCE}", "transaction_channel": "EDC_ANDROID" }
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

TC_O2O_13739
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to access token expired
    [Tags]    Regression    Low
    Post Request Otp By Truecard And Get Reference Information   ${TRUE_DIGITAL_CARD}
    Set Gateway Header With Expired Token
    Post Payment Charge By Api Version 3     { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    invalid_token
    Response Should Contain Property With Value    error_description    Access token expired: ${expire_tmn_token}

TC_O2O_13740
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to system cannot convert json token
    [Tags]    Regression    Low
    Post Request Otp By Truecard And Get Reference Information   ${TRUE_DIGITAL_CARD}
    Set Gateway Header With Invalid Access Token
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    invalid_token
    Response Should Contain Property With Value    error_description    Cannot convert access token to JSON

TC_O2O_13741
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to without header Authorization
    [Tags]    Regression    Low
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Set Gateway Header Without Authorization
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    errors..property    401
    Response Should Contain Property With Value    errors..message    Full authentication is required to access this resource

TC_O2O_13742
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to invalid client scope
    [Tags]    Regression    Low    UnitTest
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    errors..property    1_403
    Response Should Contain Property With Value    errors..message    Forbidden

TC_O2O_13780
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to API does not allow to input lower_case on currency
    [Tags]    Regression    Low
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "thb", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "EDC_ANDROID" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    currency
    Response Should Contain Property With Value    errors..message    currency is invalid

TC_O2O_13781
    [Documentation]    [TrueDigitalCard: On] Payment charge fail due to API does not allow to input lower_case on transaction_channel
    [Tags]    Regression    Low
    Post Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "any value", "transaction_channel": "edc_android" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    transaction_channel
    Response Should Contain Property With Value    errors..message    transaction_channel is invalid
