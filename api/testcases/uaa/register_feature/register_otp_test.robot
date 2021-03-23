*** Settings ***
Documentation    Tests to verify that register OTP send & check succeed and
...              fail correctly depending from users input values.

Resource            ../../../resources/init.robot
Resource            ../../../keywords/uaa/register_keywords.robot
Test Setup          Create Gateway Session
Test Teardown       Delete All Sessions

*** Variables ***
${valid_phone_number}                       66639148348
${empty_phone_number}                       ${EMPTY}
${empty_login_number}                       ${EMPTY}
${special_phone_number}                     !!!!!!!!!!!
${min_phone_number}                         666391
${max_phone_number}                         66639148348000000
${otp_expired_message}                      "title": "OTP was expired"
${otp_invalid_message}                      "title": "Method argument not valid"
${otp_constraint_violation_message}         "title": "Constraint Violation"
${otp_empty_message}                        ${EMPTY}
${valid_reference}                          YJHF
${valid_customer_otp}                       159632
${valid_transaction_id}                     20180221043438125
${invalid_phone_number}                     660915
${empty_reference}                          ${EMPTY}
${empty_customer_otp}                       ${EMPTY}
${empty_transaction_id}                     ${EMPTY}
${invalid_reference}                        YJ
${invalid_customer_otp}                     159
${special_reference}                        !!!!
${special_customer_otp}                     !!!!!!
${special_transaction_id}                   !!!!!!!

*** Test Cases ***
TC_O2O_00104
    [Documentation]     [RegisterOTP] Valid OTP send successful
    [Tags]      Regression     Register     High        UAA     OTP    Smoke
    Send OTP                                        ${valid_phone_number}
    Response Correct Code                           ${SUCCESS_CODE}
    Response Correct Message                        ${otp_empty_message}

TC_O2O_00105
    [Documentation]     [RegisterOTP] Send the OTP with an empty phone
    [Tags]      Regression     Register     Medium        UAA     OTP
    Send OTP                                       ${empty_phone_number}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_constraint_violation_message}

TC_O2O_00106
    [Documentation]     [RegisterOTP] Send the OTP with a special phone
    [Tags]      Regression     Register     Medium        UAA     OTP
    Send OTP                                       ${special_phone_number}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_constraint_violation_message}

TC_O2O_00107
    [Documentation]     [RegisterOTP] Send the OTP with a phone less than 11 characters
    [Tags]      Regression     Register     Medium        UAA     OTP
    Send OTP                                       ${min_phone_number}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_constraint_violation_message}

TC_O2O_00108
    [Documentation]     [RegisterOTP] Send the OTP with a phone more than 11 characters
    [Tags]      Regression     Register     Medium        UAA     OTP
    Send OTP                                       ${max_phone_number}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_constraint_violation_message}

TC_O2O_00110
    [Documentation]     [RegisterOTP] Check the OTP with an empty phone
    [Tags]      Regression     Register     Medium        UAA     OTP    Sanity    E2E    Smoke
    Check OTP                                      ${empty_phone_number}        ${valid_reference}      ${valid_customer_otp}       ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00111
    [Documentation]     [RegisterOTP] Check the OTP with an empty reference
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${valid_phone_number}        ${empty_reference}      ${valid_customer_otp}       ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00112
    [Documentation]     [RegisterOTP] Check the OTP with an empty customer OTP
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${valid_phone_number}        ${valid_reference}      ${empty_customer_otp}       ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00113
    [Documentation]     [RegisterOTP] Check the OTP with an empty transaction ID
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${valid_phone_number}        ${valid_reference}      ${valid_customer_otp}       ${empty_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00114
    [Documentation]     [RegisterOTP] Check the OTP with an empty all key
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${empty_phone_number}      ${empty_reference}        ${empty_customer_otp}       ${empty_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00115
    [Documentation]     [RegisterOTP] Check the OTP with an invalid phone size
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${invalid_phone_number}      ${valid_reference}      ${valid_customer_otp}       ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00116
    [Documentation]     [RegisterOTP] Check the OTP with an invalid reference size
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${valid_phone_number}        ${invalid_reference}        ${valid_customer_otp}       ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00117
    [Documentation]     [RegisterOTP] Check the OTP with an invalid customer OTP size
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${valid_phone_number}        ${valid_reference}      ${invalid_customer_otp}     ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00118
    [Documentation]     [RegisterOTP] Check the OTP expired return correct
    [Tags]      Regression     Register     High        UAA     OTP
    Check OTP                                      ${valid_phone_number}        ${valid_reference}      ${valid_customer_otp}       ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_expired_message}

TC_O2O_00119
    [Documentation]     [RegisterOTP] Check the OTP with the special phone
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${special_phone_number}      ${valid_reference}      ${valid_customer_otp}       ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00120
    [Documentation]     [RegisterOTP] Check the OTP with the special reference
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                       ${valid_phone_number}       ${special_reference}        ${valid_customer_otp}       ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00121
    [Documentation]     [RegisterOTP] Check the OTP with the special customer OTP
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${valid_phone_number}        ${valid_reference}      ${special_customer_otp}     ${valid_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}

TC_O2O_00122
    [Documentation]     [RegisterOTP] Check the OTP with the special transaction ID
    [Tags]      Regression     Register     Medium        UAA     OTP
    Check OTP                                      ${valid_phone_number}        ${valid_reference}      ${valid_customer_otp}       ${special_transaction_id}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${otp_invalid_message}
