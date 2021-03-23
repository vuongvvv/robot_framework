*** Settings ***
Resource    ../../payment/merchant_payment_resource_keyword.robot

*** Keywords ***
Post Payment Capture Charge
    [Arguments]    ${transaction_id}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/credit-card/transactions/${transaction_id}/capture    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Search Payment Transaction By Status
    [Arguments]    ${status}    ${payment_account_id}=${VALID_PAYMENT_ACCOUNT_ID}
    Get Payment Transaction List By Merchant Or Admin    paymentAccountId.equals=${payment_account_id}&status.equals=${status}&size=1&sort=createdDate,DESC
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transactionId    TRANSACTION_ID
    Fetch Property From Response    .clientRefId    CHARGE_CLIENT_REF
    Set Test Variable    ${TRANSACTION_ID}
