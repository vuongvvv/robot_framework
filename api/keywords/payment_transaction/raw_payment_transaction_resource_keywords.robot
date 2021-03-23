*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${raw_payment_transaction}    /paymenttransaction/api/raw-transactions

*** Keywords ***
Post Create Raw Payment Transaction
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${raw_payment_transaction}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}