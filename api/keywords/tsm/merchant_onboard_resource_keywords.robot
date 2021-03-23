*** Keywords ***
Create Merchant Onboard Registration
    [Arguments]    ${body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /tsm/api/merchant-onboard/registration    data=${body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
