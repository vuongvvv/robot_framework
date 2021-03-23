*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${sms_audiences_url}    messagetool/api/topics
*** Keywords ***
Get Topic Message By
    [Arguments]    ${topic}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${sms_audiences_url}/${topic}/messages    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Message From Kafka Topic With Incorrect Permission
    [Arguments]    ${topic}
    ${topic}=    Replace String    ${topic}    staging.    stg.
    Get Topic Message By    ${topic}
    Response Correct Code    ${403}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/topics/${topic}/messages
    Response Should Contain Property With Value    message    error.http.403

Get Message From Kafka Topic With Correct Permission
    [Arguments]    ${topic}
    ${topic}=    Replace String    ${topic}    staging.    stg.
    Get Topic Message By    ${topic}
    Response Correct Code    ${200}
