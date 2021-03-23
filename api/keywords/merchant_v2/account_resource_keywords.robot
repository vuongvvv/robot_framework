*** Variables ***
${merchant_v2_service}    /merchant-v2

*** Keywords ***
Post Auto Binding True You Link
    [Arguments]    ${merchant_id}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${merchant_v2_service}/api/link-trueyou    data={ "mid": "${merchant_id}" }    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}