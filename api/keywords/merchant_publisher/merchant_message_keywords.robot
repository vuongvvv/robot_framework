*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${merchant_publisher_url}    /merchantpublisher/api/merchants

*** Keywords ***
Put Publish Merchant Updated Event
    [Arguments]    ${action}    ${data}
    ${header_with_action}=    Set Variable    ${GATEWAY_HEADER}
    Set To Dictionary    ${header_with_action}    action=${action}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${merchant_publisher_url}    data=${data}    headers=&{header_with_action}
    Set Test Variable    ${RESP}

Post Publish Merchant Created Event
    [Arguments]    ${action}    ${data}
    ${header_with_action}=    Set Variable    ${GATEWAY_HEADER}
    Set To Dictionary    ${header_with_action}    action=${action}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${merchant_publisher_url}    data=${data}    headers=&{header_with_action}
    Set Test Variable    ${RESP}
