*** Settings ***
Library    Collections
Resource    ../common/api_common.robot

*** Keywords ***
Reprocess Messages On Error Topic Of Kafka
    [Documentation]    Reprocess message in a specific error topic on Kafka
    [Arguments]    ${reprocess_api}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${reprocess_api}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}