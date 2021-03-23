*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${merchants_api}    /rpp-merchant/api/merchants
${delete_merchants_api}    /rpp-merchant/api/merchants/_merchantID

*** Keywords ***
Post Create Merchant
    [Arguments]    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${merchants_api}    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
