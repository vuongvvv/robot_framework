*** Settings ***
Documentation    Tests to verify that wePayment onboard - access control api works correctly

Resource    ../../../../resources/init.robot
Resource    ../../../../keywords/payment/payment_account_resource/wepayment_account_management_keywords.robot
Resource    ../../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
Test Teardown    Delete All Sessions
#Require Client Scope: payment.payment.actAsAdmin

*** Test Cases ***
TC_O2O_24278
    [Documentation]    [app client][create] verify response when request with invalid client scope
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
    Post Create App Client    {"clientId": "robotautomationclientpayment_creditcard","clientDesc": "Client For Automation Scripts"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/payment-account/app-client
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_24279
    [Documentation]    [app client][create] verify response when request with valid input information
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    5
    Post Create App Client    {"clientId": "robotautomation_${TRANSACTION_REFERENCE}","clientDesc": "Can Remove Test Client By Automation Scripts"}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    clientId    robotautomation_${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    clientDesc    Can Remove Test Client By Automation Scripts
    Response Should Contain Property With String Value    o2oPublicKey
