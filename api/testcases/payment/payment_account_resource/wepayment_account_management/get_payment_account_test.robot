*** Settings ***
Documentation    Tests to verify that wePayment onboard - get all payment account api works correctly

Resource    ../../../../resources/init.robot
Resource    ../../../../keywords/payment/payment_account_resource/wepayment_account_management_keywords.robot
Resource    ../../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
Test Teardown    Delete All Sessions
#Require Client Scope: payment.payment.actAsAdmin

*** Test Cases ***
TC_O2O_24276
    [Documentation]    [query all] Unable to query payment account when request with invalid client scope
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
    Get All Payment Account List
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/payment-account
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_24277
    [Documentation]    Verify total payment account list should be correct
    [Tags]    Medium    Regression    Smoke    payment
    Get All Payment Account List    size=1
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .paymentAccountId
    Response Should Contain All Property Values Are String Or Null    .projectId
    Response Should Contain All Property Values Are String Or Null    .shopId
    Response Should Contain Property With Null Value    .ownerClientId
    Response Should Contain All Property Values Are String Or Null    .companyName
    Response Should Contain All Property Values Are String Or Null    .platformName
    Response Should Contain Property With Null Value    .o2oPublicKey
    Response Should Contain Property With Null Value    .o2oPrivateKey
    Response Should Contain All Property Values Are String Or Null    .clientCallbackUrl
    Response Should Contain All Property Values Are String Or Null    .email
    Response Should Contain All Property Values Are String Or Null    .mobile
    Response Should Contain All Property Values Are String Or Null    .omiseAccount
    Response Should Contain All Property Values Are String Or Null    .recipients
    Response Should Contain All Property Values Are String Or Null    .subscriptions
    Response Should Contain Property With String Value    .status
    Response Should Contain All Property Values Are String Or Null    .ip
    Response Should Contain Property With Boolean    .enabled
