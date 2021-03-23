*** Keywords ***
Post Update Driver Status
    [Arguments]    ${data}    
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /weshop/callback/api/delivery/ali    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}