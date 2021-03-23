*** Settings ***

*** Keywords ***
Post Payment Report
    [Arguments]      ${criteria}=${EMPTY}
    ${RESP}=    Get Request     ${RPP_GATEWAY_SESSION}      /crm-ms-payment-api/v1/api/payments/reports/export      params=${criteria}
    Set Test Variable    ${RESP}