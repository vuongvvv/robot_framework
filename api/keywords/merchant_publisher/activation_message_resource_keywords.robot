*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${merchant_publisher_url}    /merchantpublisher/api/activations

*** Keywords ***
Post Publish Activation Code Created Event
    [Arguments]    ${action}    ${data}
    ${header_with_action}=    Set Variable    ${GATEWAY_HEADER}
    Set To Dictionary    ${header_with_action}    action=${action}
    ${resp}=    Post Request    ${GATEWAY_SESSION}    ${merchant_publisher_url}    data=${data}    headers=&{header_with_action}
    Set Test Variable    ${resp}

Put Publish Activation Code Updated Event
    [Arguments]    ${action}    ${data}
    ${header_with_action}=    Set Variable    ${GATEWAY_HEADER}
    Set To Dictionary    ${header_with_action}    action=${action}
    ${resp}=    Put Request    ${GATEWAY_SESSION}    ${merchant_publisher_url}    data=${data}    headers=&{header_with_action}
    Set Test Variable    ${resp}