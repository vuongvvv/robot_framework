*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${merchant_publisher_url}    /merchantpublisher/api/outlets
${outlet_v2_url}    /merchantpublisher/api/v2/outlets

*** Keywords ***
Post Publish Outlets Created Event
    [Arguments]    ${data}
    ${resp}=    Post Request    ${GATEWAY_SESSION}    ${merchant_publisher_url}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${resp}

Put Publish Outlets Updated Event
    [Arguments]    ${data}
    ${resp}=    Put Request    ${GATEWAY_SESSION}    ${merchant_publisher_url}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${resp}

Put Publish Outlet V2 Updated Event
    [Arguments]    ${action}    ${data}
    ${header_with_action}=    Set Variable    ${GATEWAY_HEADER}
    Set To Dictionary    ${header_with_action}    action=${action}
    ${resp}=    Put Request    ${GATEWAY_SESSION}    ${outlet_v2_url}    data=${data}    headers=&{header_with_action}
    Set Test Variable    ${resp}

Post Publish Outlet V2 Created Event
    [Arguments]    ${action}    ${data}
    ${header_with_action}=    Set Variable    ${GATEWAY_HEADER}
    Set To Dictionary    ${header_with_action}    action=${action}
    ${resp}=    Post Request    ${GATEWAY_SESSION}    ${outlet_v2_url}    data=${data}    headers=&{header_with_action}
    Set Test Variable    ${resp}

