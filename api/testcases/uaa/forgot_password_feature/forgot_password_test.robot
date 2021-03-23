*** Settings ***
Documentation    Tests to verify that forgot password send & check succeed and
...              fail correctly depending from users input values.

Resource            ../../../resources/init.robot
Resource            ../../../keywords/uaa/forgot_password_keywords.robot
Test Setup          Create Gateway Session
Test Teardown       Delete All Sessions

*** Variables ***
${valid_phone}                      ${USER_NAME}
${not_available_phone}              66639148000
${invalid_format_phone}             test
${empty_phone}                      ${EMPTY}
${valid_transaction_id}             20180321074118600
${valid_reference}                  SAZH
${invalid_length_otp}               2343341111
${empty_otp}                        ${EMPTY}
${expired_otp}                      234334
${invalid_format_otp}               AVCDDF
${invalid_key}                      57276928846067448111
${empty_key}                        ${EMPTY}
${valid_password}                   password
${min_password}                     1
${max_password}                     11111111112222222222333333333344444
${phone_not_found_title}            "title": "Mobile number not found"
${constraint_violation_title}       "title": "Constraint Violation"
${error_validation_message}         "message": "error.validation"
${otp_expired_title}                "title": "OTP was expired"
${invalid_argument_title}           "title": "Method argument not valid"
${no_user_title}                    "title": "No user was found for this reset key"
${incorrect_password_title}         "title": "Incorrect password"
${not_found_status}                 "status": 404
${bad_request_status}               "status": 400
${internal_server_error_status}     "status": 500

*** Test Cases ***
TC_O2O_00216
    [Documentation]   Forgot Password - Request OTP with an existing account
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Request Forgot OTP         ${valid_phone}
    Response Correct Code      ${SUCCESS_CODE}

TC_O2O_00217
    [Documentation]   Forgot Password - Request OTP with the account is not available
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Request Forgot OTP         ${not_available_phone}
    Response Correct Code      ${NOT_FOUND_CODE}
    Response Correct Message   ${phone_not_found_title}
    Response Correct Message   ${not_found_status}

TC_O2O_00218
    [Documentation]   Forgot Password - Request OTP with the empty phone
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Request Forgot OTP         ${empty_phone}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Correct Message   ${constraint_violation_title}
    Response Correct Message   ${bad_request_status}
    Response Correct Message   ${error_validation_message}

TC_O2O_00219
    [Documentation]   Forgot Password - Request OTP with the invalid phone format
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Request Forgot OTP         ${invalid_format_phone}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Correct Message   ${constraint_violation_title}
    Response Correct Message   ${bad_request_status}
    Response Correct Message   ${error_validation_message}

TC_O2O_00220
    [Documentation]   Forgot Password - Verify the OTP is expired
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Verify Forgot OTP          ${valid_phone}    ${valid_reference}    ${expired_otp}    ${valid_transaction_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Correct Message   ${otp_expired_title}
    Response Correct Message   ${bad_request_status}

TC_O2O_00222
    [Documentation]   Forgot Password - Verify the OTP with the invalid length
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Verify Forgot OTP          ${valid_phone}    ${valid_reference}    ${invalid_length_otp}    ${valid_transaction_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Correct Message   ${error_validation_message}
    Response Correct Message   ${bad_request_status}
    Response Correct Message   ${invalid_argument_title}

TC_O2O_00223
    [Documentation]   Forgot Password - Verify the OTP with the invalid format
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Verify Forgot OTP          ${valid_phone}    ${valid_reference}    ${invalid_format_otp}    ${valid_transaction_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Correct Message   ${error_validation_message}
    Response Correct Message   ${bad_request_status}
    Response Correct Message   ${invalid_argument_title}

TC_O2O_00224
    [Documentation]   Forgot Password - Verify the empty OTP
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Verify Forgot OTP          ${valid_phone}    ${valid_reference}    ${empty_otp}    ${valid_transaction_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Correct Message   ${error_validation_message}
    Response Correct Message   ${bad_request_status}
    Response Correct Message   ${invalid_argument_title}

TC_O2O_00227
    [Documentation]   Forgot Password - Set the new password with invalid key as expired
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Set New Password           ${invalid_key}    ${valid_password}
    Response Correct Code      ${INTERNAL_SERVER_CODE}
    Response Correct Message   ${no_user_title}
    Response Correct Message   ${internal_server_error_status}

TC_O2O_00228
    [Documentation]   Forgot Password - Set the new password with empty key
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Set New Password           ${empty_key}    ${valid_password}
    Response Correct Code      ${INTERNAL_SERVER_CODE}
    Response Correct Message   ${no_user_title}
    Response Correct Message   ${internal_server_error_status}

TC_O2O_00229
    [Documentation]   Forgot Password - Set the new password less than 8 characters
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Set New Password           ${invalid_key}    ${min_password}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Correct Message   ${bad_request_status}
    Response Correct Message   ${incorrect_password_title}

TC_O2O_00230
    [Documentation]   Forgot Password - Set the new password more than 30 characters
    [Tags]      Regression     ForgotPassword     High        UAA     OTP
    Set New Password           ${invalid_key}    ${max_password}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Correct Message   ${bad_request_status}
    Response Correct Message   ${incorrect_password_title}
