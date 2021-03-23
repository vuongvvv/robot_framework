*** Settings ***
Resource    ../../payment/credit_card_resource/creditcard_charge_by_payment_account_keywords.robot

*** Keywords ***
Post Payment Void By Payment Account
    [Arguments]    ${charge_transaction_id}    ${data}
    Set Gateway Header With Kms Security Header For Wepayment
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/credit-card/transactions/${charge_transaction_id}/void    data=${data}    headers=&{WEPAYMENT_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Prepare Omise The Charge Transaction Type 3D Secure
    [Arguments]    ${order_id}
    Generate Omise Payment Token    ${omise_valid_master_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientRefId": "PREPARE-${order_id}","manualCapture": false,"rememberCard": false,"returnUrl": "${returnUrl}","amount": "${amount}","currency": "${TH_CURRENCY}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","userDefine1": "AUTOMATE TEST SCRIPT","userDefine2": "PREPARE STEP BEFORE VOID","userDefine3": "ENHANCE BY STORM TEAM"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    Fetch Property From Response    .authorizeUri    OMISE_AUTHORIZE_URI
    Confirm Credit Card Authorize    ${OMISE_AUTHORIZE_URI}
    # add sleep thead for pending callback process
    Sleep    0.5s
