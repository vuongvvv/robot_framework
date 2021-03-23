*** Settings ***
Documentation    Tests to verify that create account succeed and
...              fail correctly depending from users input values.

Resource            ../../../resources/init.robot
Resource            ../../../keywords/uaa/register_keywords.robot
Test Setup          Create Gateway Session
Test Teardown       Delete All Sessions

*** Variables ***
${valid_phone_number}                       66639148348
${valid_unused_phone_number}                66091533031
${empty_phone_number}                       ${EMPTY}
${empty_login_number}                       ${EMPTY}
${special_phone_number}                     !!!!!!!!!!!
${min_phone_number}                         666391
${max_phone_number}                         66639148348000000
${inconsistent_phone_message}               "title": "Login and Mobile need to be the same"
${account_invalid_message}                  "title": "Method argument not valid"
${valid_user_password}                      password123
${empty_user_password}                      ${EMPTY}
${max_user_password}                        password123456789012345678901234567890
${min_user_password}                        123
${spacing_user_password}                    {SPACE * 8}
${text_phone_number}                        AAAAAAAAAAA
${spacing_phone_number}                     {SPACE * 11}
${inconsistent_phone_number}                66639148349
${valid_lang}                               th
${special_user_password}                    !!!!!!!!

*** Test Cases ***
TC_O2O_00001
    [Documentation]     [Register] Check the user has created an account successful without OTP
    [Tags]      Regression     Register     High        UAA
    Create Account                                 ${valid_unused_phone_number}     ${valid_unused_phone_number}        ${valid_user_password}      ${valid_lang}
    Response Correct Code                          ${CREATED_CODE}

TC_O2O_00002
    [Documentation]     [Register] Create the new account with a password more than 30 characters
    [Tags]      Regression     Register     Medium        UAA    Smoke
    Create Account                                 ${valid_phone_number}        ${valid_phone_number}       ${max_user_password}        ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}

TC_O2O_00003
    [Documentation]     [Register] Create the new account with a password less than 8 characters
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${valid_phone_number}        ${valid_phone_number}       ${min_user_password}        ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}

TC_O2O_00004
    [Documentation]     [Register] Create the new account with a spacing password
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${valid_unused_phone_number}     ${valid_unused_phone_number}        ${spacing_user_password}        ${valid_lang}
    Response Correct Code                          ${CREATED_CODE}

TC_O2O_00005﻿
    [Documentation]     [Register] Create the new account with a empty password
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${valid_phone_number}        ${valid_phone_number}       ${empty_user_password}      ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}

TC_O2O_00007
    [Documentation]     [Register] Create the new account with a special password
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${valid_unused_phone_number}     ${valid_unused_phone_number}        ${special_user_password}        ${valid_lang}
    Response Correct Code                          ${CREATED_CODE}

TC_O2O_00008
    [Documentation]     [Register] Create the new account with a phone as text
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${text_phone_number}     ${text_phone_number}        ${valid_user_password}      ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}

TC_O2O_00009
    [Documentation]     [Register] Create the new account with a special phone
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${special_phone_number}      ${special_phone_number}     ${valid_user_password}      ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}

TC_O2O_00010
    [Documentation]     [Register] Create the new account with a spacing phone
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${spacing_phone_number}      ${spacing_phone_number}     ${valid_user_password}      ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}

TC_O2O_00011
    [Documentation]     [Register] Create the new account with a phone more than 11 numberic
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${max_phone_number}      ${max_phone_number}     ${valid_user_password}      ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}

TC_O2O_00012
    [Documentation]     [Register] Create the new account with a phone less than 11 numberic
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${min_phone_number}      ${min_phone_number}     ${valid_user_password}      ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}

TC_O2O_00013
    [Documentation]     [Register] Create the new account with a empty phone
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${empty_login_number}        ${empty_phone_number}       ${valid_user_password}      ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}

TC_O2O_00014
    [Documentation]     [Register] Create the new account with a inconsistent phone
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${valid_phone_number}        ${inconsistent_phone_number}        ${valid_user_password}      ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${inconsistent_phone_message}

TC_O2O_00015
    [Documentation]     [Register] Create the new account with a empty phone and password
    [Tags]      Regression     Register     Medium        UAA
    Create Account                                 ${empty_login_number}        ${empty_phone_number}       ${empty_user_password}       ${valid_lang}
    Response Correct Code                          ${BAD_REQUEST_CODE}
    Response Correct Message                       ${account_invalid_message}
