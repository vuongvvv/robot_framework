*** Settings ***
Documentation    Tests to verify that createPaymentTransaction api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Run Keywords    Prepare Payment Transaction Test Data    AND    Generate Gateway Header With Scope and Permission    ${PAYMENT_TRAN_USER}    ${PAYMENT_TRAN_PASSWORD}    paymentTx.create
Test Teardown     Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_05658
    [Documentation]     [PaymentTransaction][createPaymentTransaction] Request with long value for amount returns 200
    [Tags]    Regression    High    UnitTest    Smoke    E2E
    Post Create Payment Transaction    { "amount": 1500, "merchantId": "9000001", "merchantPhoneNumber": "0953509888", "merchantThaiId": "1986040488882", "terminalId": "9901", "outletId": "00001", "thaiId": "1986040499992", "trueCard":"9999999999", "transactionDateTime": "${TRANSACTION_DATE}", "transactionReference": "${TRANSACTION_REFERENCE}", "transactionType": "P2P", "paymentMethod":"ALIPAY" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body

TC_O2O_01790
    [Documentation]     [API][PaymentTransaction][createPaymentTrans] Request with 256 characters for transactionReference returns 400
    [Tags]    Regression    Medium    UnitTest    Smoke
    Generate Transaction Reference    256
    Post Create Payment Transaction    { "amount": 1500, "merchantId": "9000001", "merchantPhoneNumber": "0953509888", "merchantThaiId": "1986040488882", "terminalId": "9901", "outletId": "00001", "thaiId": "1986040499992", "trueCard":"9999999999", "transactionDateTime": "${TRANSACTION_DATE}", "transactionReference": "${TRANSACTION_REFERENCE}", "transactionType": "P2P", "paymentMethod":"ALIPAY" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    paymentTransaction
    Response Should Contain Property With Value    fieldErrors..field    transactionReference
    Response Should Contain Property With Value    fieldErrors..message    size must be between 1 and 255

TC_O2O_06193
    [Documentation]     [API][PaymentTransaction][createPaymentTrans] Request with less than or equal to 255 characters for transactionReference returns 200
    [Tags]      Regression     Medium    UnitTest
    Generate Transaction Reference    254
    Post Create Payment Transaction    { "amount": 1500, "merchantId": "9000001", "merchantPhoneNumber": "0953509888", "merchantThaiId": "1986040488882", "terminalId": "9901", "outletId": "00001", "thaiId": "1986040499992", "trueCard":"9999999999", "transactionDateTime": "${TRANSACTION_DATE}", "transactionReference": "${TRANSACTION_REFERENCE}", "transactionType": "P2P", "paymentMethod":"ALIPAY" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body
