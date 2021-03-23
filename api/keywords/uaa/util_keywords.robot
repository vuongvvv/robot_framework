*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Delete Reset All Cache
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    /uaa/api/cache/clear-all    headers=&{GATEWAY_HEADER}
    Set Suite Variable   ${RESP}
    
Post Refresh Properties
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/refresh-properties    headers=&{GATEWAY_HEADER}
    Set Suite Variable   ${RESP}