*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${process_failed_issue_point_api}    /point/api/process/failed-issue-point

*** Keywords ***
Post Process Failed Issue Point
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${process_failed_issue_point_api}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Process Failed Payment Transaction Customer
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /point/api/process/failed-payment-transaction-customer    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Process Failed Payment Transaction Merchant
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /point/api/process/failed-payment-transaction-merchant    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}