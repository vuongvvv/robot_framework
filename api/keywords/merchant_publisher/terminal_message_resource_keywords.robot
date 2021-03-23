*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${merchant_publisher_url}    /merchantpublisher/api/terminals

*** Keywords ***
Put Publish Terminal Updated Event
    [Arguments]    ${action}    ${data}
    ${header_with_action}=    Set Variable    ${GATEWAY_HEADER}
    Set To Dictionary    ${header_with_action}    action=${action}
    ${resp}=    Put Request    ${GATEWAY_SESSION}    ${merchant_publisher_url}    data=${data}    headers=&{header_with_action}
    Set Test Variable    ${resp}

Post Publish Terminal Created Event
    [Arguments]    ${action}    ${data}
    ${header_with_action}=    Set Variable    ${GATEWAY_HEADER}
    Set To Dictionary    ${header_with_action}    action=${action}
    ${resp}=    Post Request    ${GATEWAY_SESSION}    ${merchant_publisher_url}    data=${data}    headers=&{header_with_action}
    Set Test Variable    ${resp}