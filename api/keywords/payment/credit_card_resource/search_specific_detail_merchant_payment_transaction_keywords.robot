*** Keywords ***
Get Specific Detail Merchant Payment Transaction
    [Arguments]    ${transaction_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/credit-card/transactions/${transaction_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
