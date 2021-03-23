*** Keywords ***
Post Payment Refund By Payment Account
    [Arguments]    ${charge_transaction_id}    ${data}
    Set Gateway Header With Kms Security Header For Wepayment
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/credit-card/transactions/${charge_transaction_id}/refund    data=${data}    headers=&{WEPAYMENT_GATEWAY_HEADER}
    Set Test Variable    ${RESP}
