*** Variables ***
${endpoint_point_issue}    /edc-app-services/v1/points/issue
${endpoint_redeem_campaign}     /edc-app-services/v1/redeems/campaign
${endpoint_void_v1}    /edc-app-services/voids
${endpoint_void_v2}    /edc-app-services/v2/voids
${endpoint_void_v3}    /edc-app-services/api/v3/void

*** Keywords ***
Post Issue Point
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${endpoint_point_issue}    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Redeem By Campaign
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${endpoint_redeem_campaign}    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Void Version 1
    [Arguments]    ${request_data}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}    ${endpoint_void_v1}    data=${request_data}    headers=${RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Void Version 2
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${endpoint_void_v2}    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Void Version 3
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    ${endpoint_void_v3}    data=${request_data}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
