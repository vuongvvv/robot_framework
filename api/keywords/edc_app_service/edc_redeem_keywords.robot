*** Variables ***
${endpoint_redeem_campaign}     /edc-app-services/v1/redeems/campaign
${endpoint_point_issue}    /edc-app-services/v1/points/issue
${endpoint_redeem_code}    /edc-app-services/v1/redeems/code

*** Keywords ***
Post Issue Point
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${endpoint_point_issue}    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Redeem By Campaign
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${endpoint_redeem_campaign}    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Redeem By Code
    [Arguments]    ${data}
    ${RESP} =    Post Request    ${RPP_GATEWAY_SESSION}    ${endpoint_redeem_code}    data=${data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
