*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Put Process SMS Delivery
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /notification/api/process/read-delivery-report    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Process Update Message Status
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /notification/api/process/update-status    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}