*** Settings ***
Documentation    Tests to verify that Verify OTP of truemoney wallet api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment/wallet_otp_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.write

*** Variables ***
${phone_number_not_register_tmn}    0996195054
${phone_number_invalid_format}    66610090735

*** Test Cases ***
TC_O2O_04633
    [Documentation]    [Payment][Verify OTP of truemoney wallet] Verify request OTP (wallet) by format phone number start with 0xxxx (phone number dosen't truly exist in the system in TMN Wallet)
    [Tags]    Regression    Medium    Smoke    payment
    Post Verify Otp Of Truemoney Wallet    { "otpCode": "540627", "otpRef": "TJFN", "authCode": "5020150e4f8594af19b61386aade8846", "mobile": "${phone_number_not_register_tmn}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_account
    Response Should Contain Property With Value    message    Tmn account does not exist.

TC_O2O_04632
    [Documentation]    Verify OTP (wallet) by sending request without phone number
    [Tags]    Regression    Medium    Smoke    payment
    Post Verify Otp Of Truemoney Wallet    { "otpCode": "540627", "otpRef": "TJFN", "authCode": "5020150e4f8594af19b61386aade8846", "mobile": "" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/wallet/otp/verify
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    .fieldErrors..objectName    otpVerifyRequest
    Response Should Contain Property With Value    .fieldErrors..field    mobile
    Response Should Contain Property With Value    .fieldErrors..message    mobile is required

TC_O2O_13362
    [Documentation]    [Payment][Verify OTP of truemoney wallet] Verify request OTP (wallet) with invalid format
    [Tags]    Regression    Medium    Smoke    payment
    Post Verify Otp Of Truemoney Wallet    { "otpCode": "540627", "otpRef": "TJFN", "authCode": "5020150e4f8594af19b61386aade8846", "mobile": "${phone_number_invalid_format}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_account
    Response Should Contain Property With Value    message    Tmn account does not exist.
