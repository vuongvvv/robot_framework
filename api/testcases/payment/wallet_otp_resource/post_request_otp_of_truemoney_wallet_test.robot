*** Settings ***
Documentation    Tests to verify that Request OTP of truemoney wallet api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment/wallet_otp_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.write

*** Variables ***
${phone_number_not_register_tmn}    0996195054
${incorrect_format_phone_number}    851646625
${true_card_not_register_with_true_you}    8861978860370164
@{error_message_when_truecard_empty}    Truecard is required    length must be 16 digits

*** Test Cases ***
## These test case below are valid when TrueDigitalCard feature toggle = false
TC_O2O_04626
    [Documentation]    [TrueDigitalCard: off] Verify response when request without type and phone number is dosen't truly exist in the system in TMN Wallet
    [Tags]    ExcludeRegression    Medium    ExcludeSmoke
    Post Request Otp Of Truemoney Wallet    { "mobile": "${phone_number_not_register_tmn}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_account
    Response Should Contain Property With Value    message    Tmn account does not exist.

TC_O2O_04622
    [Documentation]    [TrueDigitalCard: off] Verify response when request without type and input wrong format of phone number
    [Tags]    ExcludeRegression    Medium    ExcludeSmoke
    Post Request Otp Of Truemoney Wallet    { "mobile": "${incorrect_format_phone_number}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_mobile
    Response Should Contain Property With Value    message    The requested mobile number is invalid.

TC_O2O_04623
    [Documentation]    [TrueDigitalCard: off] Verify response when request without type and phone number is null
    [Tags]    ExcludeRegression    Medium    UnitTest
    Post Request Otp Of Truemoney Wallet    { "mobile": null }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    Mobile is required

# TC_O2O_12811
#     [Documentation]    [TrueDigitalCard: off] Verify response when request with type =TRUECARD
#     [Tags]    ExcludeRegression    Medium    UnitTest
#     Post Request Otp Of Truemoney Wallet    {"truecard": "${TRUE_DIGITAL_CARD}","type": "truecard"}
#     Response Correct Code    ${BAD_REQUEST_CODE}
#     Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
#     Response Should Contain Property With Value    title    Method argument not valid
#     Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
#     Response Should Contain Property With Value    path    /api/wallet/otp
#     Response Should Contain Property With Value    message    error.validation
#     Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
#     Response Should Contain Property With Value    fieldErrors..field    type
#     Response Should Contain Property With Value    fieldErrors..message    True You Card service is not available

TC_O2O_12812
    [Documentation]    [TrueDigitalCard: off] Verify response when request without type and phone number is exist in the system in TMN Wallet
    [Tags]    ExcludeRegression    Medium    ExcludeSmoke
    Post Request Otp Of Truemoney Wallet    { "mobile": "${TMN_WALLET_MOBILE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With String Value    linkingAgreement
    Response Should Contain Property With String Value    authCode
    Response Should Not Contain Property    mobile

TC_O2O_12952
    [Documentation]    [TrueDigitalCard: off] Verify response when request with type is Mobile and phone number is exist in the system in TMN Wallet
    [Tags]    ExcludeRegression    Medium    ExcludeSmoke
    Post Request Otp Of Truemoney Wallet    {"mobile" : "${TMN_WALLET_MOBILE}","type": "mobile"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With String Value    linkingAgreement
    Response Should Contain Property With String Value    authCode
    Response Should Not Contain Property    mobile

## These test case below are valid when TrueDigitalCard feature toggle = true
TC_O2O_12841
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =TRUECARD and truecard no. is not 16digits
    [Tags]    Regression    Medium    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": "888122322222","type": "truecard"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    truecard
    Response Should Contain Property With Value    fieldErrors..message    length must be 16 digits

TC_O2O_12842
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =TRUECARD and truecard no. is not existing in trueyou system
    [Tags]    Regression    Medium    Smoke    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": "${true_card_not_register_with_true_you}","type": "truecard"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    4_10008
    Response Should Contain Property With Value    message    Data not found.

TC_O2O_12843
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =TRUECARD and truecard no. is trustly existing in trueyou system
    [Tags]    Regression    Medium    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": "${TRUE_DIGITAL_CARD}","type": "truecard"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With String Value    linkingAgreement
    Response Should Contain Property With String Value    authCode
    Response Should Contain Property With String Value    mobile

TC_O2O_12845
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =TRUECARD and truecard no. is null
    [Tags]    Regression    Medium    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": null,"type": "truecard"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    truecard
    Response Should Contain Property With Value    fieldErrors..message    Truecard is required

TC_O2O_12846
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =TRUECARD and truecard no. is empty
    [Tags]    Regression    Medium    Smoke    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": "","type": "truecard"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    truecard
    Response Should Contain All Property Values Include In List    fieldErrors..message    ${error_message_when_truecard_empty}

TC_O2O_12847
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =TRUECARD and input mobile no. in request body (no truecard tag)
    [Tags]    Regression    Medium    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    {"mobile": "0610090735","type": "TRUECARD"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    truecard
    Response Should Contain Property With Value    fieldErrors..message    Truecard is required

TC_O2O_12848
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =TRUECARD and input mobile no. in request body (have truecard tag)
    [Tags]    Regression    Medium    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": "","mobile": "0610090735","type": "Truecard"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    truecard
    Response Should Contain All Property Values Include In List    fieldErrors..message    ${error_message_when_truecard_empty}

TC_O2O_12849
    [Documentation]    [TrueDigitalCard: On] Verify response when input truecard no. without type in request body
    [Tags]    Regression    Medium    UnitTest    Smoke    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": "${TRUE_DIGITAL_CARD}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    Mobile is required

TC_O2O_12850
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =MOBILE and input truecard no. in request body (no mobile tag)
    [Tags]    Regression    Medium    UnitTest    Smoke    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": "${TRUE_DIGITAL_CARD}","type": "MOBILE"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    Mobile is required

TC_O2O_12851
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =MOBILE and input truecard no. in request body (have mobile tag)
    [Tags]    Regression    Medium    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": "${TRUE_DIGITAL_CARD}","mobile": "","type": "mobile"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    Mobile is required

TC_O2O_12852
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =MOBILE and input mobile whose not existing in TMN system
    [Tags]    Regression    Medium    Smoke    payment
    Post Request Otp Of Truemoney Wallet    {"mobile" : "${phone_number_not_register_tmn}","type": "MOBILE"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_account
    Response Should Contain Property With Value    message    Tmn account does not exist.

TC_O2O_12853
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =MOBILE and input mobile whose existing in TMN system (No Type tag)
    [Tags]    Regression    Medium    Smoke    payment
    Post Request Otp Of Truemoney Wallet    { "mobile": "${TMN_WALLET_MOBILE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With String Value    linkingAgreement
    Response Should Contain Property With String Value    authCode
    Response Should Not Contain Property    mobile

TC_O2O_12854
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =MOBILE and input mobile whose existing in TMN system (Have type tag)
    [Tags]    Regression    Medium    Smoke    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    { "mobile": "${TMN_WALLET_MOBILE}","type": "Mobile" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With String Value    linkingAgreement
    Response Should Contain Property With String Value    authCode
    Response Should Not Contain Property    mobile

TC_O2O_12855
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =MOBILE and mobile no. is invalid format
    [Tags]    Regression    Medium    Smoke    payment
    Post Request Otp Of Truemoney Wallet    {"mobile" : "${incorrect_format_phone_number}","type": "mobile"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_mobile
    Response Should Contain Property With Value    message    The requested mobile number is invalid.

TC_O2O_12856
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type =MOBILE and mobile no. is null
    [Tags]    Regression    Medium    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    {"mobile" : null,"type": "mobile"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    Mobile is required

TC_O2O_12953
    [Documentation]    [TrueDigitalCard: On] Verify response when request with type whose not in (wallet, truecard)
    [Tags]    Regression    Medium    Smoke    UnitTest    payment
    Post Request Otp Of Truemoney Wallet    {"truecard": "8861978860370164","type": "trueid"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    otpRequest
    Response Should Contain Property With Value    fieldErrors..field    type
    Response Should Contain Property With Value    fieldErrors..message    Type is invalid
