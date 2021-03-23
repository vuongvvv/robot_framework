*** Keywords ***
Get Installment Payment Plan Option By Payment Account Id
    [Arguments]    ${payment_account_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/credit-card/installment-options/${payment_account_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
