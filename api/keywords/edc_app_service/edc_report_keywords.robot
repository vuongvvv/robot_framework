*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/rpp_gateway_common.robot
Resource    ../rpp_payment/rpp_payment_keywords.robot

*** Keywords ***
Post Request Preview Settlement Report
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}    /edc-app-services/v1/reports/preview-settlement    data=${data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
    
Post Request Settlement Report
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}    /edc-app-services/v1/reports/settlement    data=${data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Get Summary Report
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP} =    Get Request    ${RPP_GATEWAY_SESSION}    /edc-app-services/v1/reports/summary    params=${params_uri}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
    
Get Detail Summary Report
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP} =    Get Request    ${RPP_GATEWAY_SESSION}    /edc-app-services/v1/reports/detail-summary    params=${params_uri}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}  