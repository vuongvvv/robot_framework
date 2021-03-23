*** Keywords ***
Post Payment Reverse Charge
    [Arguments]    ${transaction_id}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/credit-card/transactions/${transaction_id}/reverse    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
