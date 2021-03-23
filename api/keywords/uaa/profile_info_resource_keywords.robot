*** Settings ***
Resource      ../common/api_common.robot

*** Keywords ***
Get Active Profiles
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /uaa/api/profile-info    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}