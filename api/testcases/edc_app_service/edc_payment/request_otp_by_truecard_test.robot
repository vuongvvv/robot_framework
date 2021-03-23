*** Settings ***
Documentation    Regression tests to verify that request OTP with truecard on edc_api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/edc_app_service/edc_payment_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment
Test Teardown     Delete All Sessions
#Require UAA_Client Scope: payment.payment.write

*** Test Cases ***
TC_O2O_13436
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Verify response when send requestOTP with invalid client scope
    [Tags]    Regression    Medium    Smoke
    [Setup]    Generate Gateway Header With Scope and Permission    ${EDC_APP_SERVICE_USER}    ${EDC_APP_SERVICE_PASSWORD}    payment.payment.read
    Post Request Otp Of Truecard    { "truecard": "${TRUE_DIGITAL_CARD}" }
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    errors..property    1_403
    Response Should Contain Property With Value    errors..message    Forbidden

TC_O2O_13437
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Verify response when send requestOTP without header Authorization
    [Tags]    Regression    Low    UnitTest
    Set Gateway Header Without Authorization
    Post Request Otp Of Truecard    { "truecard": "${TRUE_DIGITAL_CARD}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    errors..property    401
    Response Should Contain Property With Value    errors..message    Full authentication is required to access this resource

TC_O2O_13442
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Verify response when send requestOTP and truecard no. is not 16digits
    [Tags]    Regression    Medium    Smoke
    Post Request Otp Of Truecard    { "truecard": "886199886037016" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    truecard
    Response Should Contain Property With Value    errors..message    length must be 16 digits

TC_O2O_13443
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Verify response when send requestOTP and truecard no. not existing in trueyou system
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp Of Truecard    { "truecard": "8861998860370173" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_4_10008
    Response Should Contain Property With Value    errors..message    Data not found.

TC_O2O_13444
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Verify response when send requestOTP and truecard no. is empty
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp Of Truecard    { "truecard": "" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    truecard
    Response Should Contain Property With Value    errors..message    length must be 16 digits
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13445
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Verify response when send requestOTP and truecard no. is null
    [Tags]    Regression    Medium    Smoke
    Post Request Otp Of Truecard    { "truecard": null }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    truecard
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13446
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Verify response when send requestOTP and truecard no. is trustly existing in trueyou system
    [Tags]    Regression    High    Smoke    Sanity    UnitTest
    Post Request Otp Of Truecard    { "truecard": "${TRUE_DIGITAL_CARD}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otp_ref
    Response Should Contain Property With String Value    linking_agreement
    Response Should Contain Property With String Value    auth_code
    Response Should Contain Property With String Value    mobile

TC_O2O_13528
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Now allow to request otp via mobile no.
    [Tags]    Regression    Medium    Smoke    UnitTest
    Post Request Otp Of Truecard    { "mobile": "${TRUE_DIGITAL_CARD}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    truecard
    Response Should Contain Property With Value    errors..message    may not be empty

TC_O2O_13529
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Verify response when send requestOTP and invalid_token
    [Tags]    Regression    Medium    Smoke
    Set Gateway Header With Invalid Access Token
    Post Request Otp Of Truecard    { "truecard": "${TRUE_DIGITAL_CARD}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    invalid_token
    Response Should Contain Property With Value    error_description    Cannot convert access token to JSON

TC_O2O_13530
    [Documentation]    [PaymentOnline][TrueDigitalCard: On] Verify response when send requestOTP and access token is expire
    [Tags]    Regression    Medium    Smoke
    Set Gateway Header With Expired Token
    Post Request Otp Of Truecard    { "truecard": "${TRUE_DIGITAL_CARD}" }
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    invalid_token
    Response Should Contain Property With Value    error_description    Access token expired: ${expire_tmn_token}

TC_O2O_13699
    [Documentation]    [PaymentOnline][TrueDigitalCard: Off] System not allow to request OTP when feature toggle is off
    [Tags]    ExcludeRegression    Low
    Post Request Otp Of Truecard    { "truecard": "${TRUE_DIGITAL_CARD}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    errors..property    1_type
    Response Should Contain Property With Value    errors..message    True You Card service is not available
