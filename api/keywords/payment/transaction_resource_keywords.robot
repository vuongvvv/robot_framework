*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${payment_url}    /payment/api/charge

*** Keywords ***
Get Search Transaction
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/transactions    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Data Preparation
Get Existing Transaction Reference
    Get Search Transaction
    ${EXISTING_TRANSACTION_REFERENCE}=    Get Property Value From Json By Index    .txRefId    0
    Set Test Variable    ${EXISTING_TRANSACTION_REFERENCE}