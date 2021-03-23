*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Get Send Daily Report
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /tsmbsreport/api/daily-report    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}