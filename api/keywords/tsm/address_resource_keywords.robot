*** Keywords ***
Get Address by Postcode
   [Arguments]    ${postcode}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /tsm/api/addresses/postcode/${postcode}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}