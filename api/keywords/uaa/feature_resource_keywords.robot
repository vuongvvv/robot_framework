*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Get Features
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /uaa/api/features    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}