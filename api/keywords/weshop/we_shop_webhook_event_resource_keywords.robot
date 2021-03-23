*** Settings ***
Library    Collections    

*** Keywords ***
Post Wefresh Order Event
    [Arguments]    ${shop_id}    ${data}    ${authorization_key}=UPjMezEPUmzt2PdudvWYQwTGFb6dK3nReuGZ2Wbd
    &{header}=    Create Dictionary    Content-Type=application/json    Authorization=${authorization_key}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /weshop/webhooks/api/wefresh/orders/events    data=${data}    headers=&{header}
    Set Test Variable    ${RESP}
    Sleep    3s    