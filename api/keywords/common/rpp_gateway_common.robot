*** Settings ***
Resource    json_common.robot

*** Keywords ***
Create RPP Gateway Session
    [Arguments]     ${rpp_gateway_host_url}
    Create Session    ${RPP_GATEWAY_SESSION}    ${rpp_gateway_host_url}    verify=true

Create RPP Gateway Header
    [Arguments]     ${rpp_gateway_host_url}=${RPP_GATEWAY_HOST}
    &{headers}=   Create Dictionary    Content-Type=application/json    authorization=Basic ${RPP_GATEWAY_AUTHORIZATION_KEY}    
    Create RPP Gateway Session    ${rpp_gateway_host_url}
    Set Suite Variable    &{RPP_GATEWAY_HEADERS}    &{headers}

Create RPP Payment V2 Gateway Header
    [Arguments]     ${rpp_gateway_host_url}=${RPP_GATEWAY_HOST}
    &{headers}=    Create Dictionary    Content-Type=application/json    x-api-key=xxx    Accept-Language=TH
    Create RPP Gateway Session    ${rpp_gateway_host_url}
    Set Suite Variable    &{RPP_PAYMENT_V2_GATEWAY_HEADERS}    &{headers}