*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Put Process Sms DR
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /notification/api/process/read-sms-dr    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Process Update Message Status
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /notification/api/process/update-sms-status    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}