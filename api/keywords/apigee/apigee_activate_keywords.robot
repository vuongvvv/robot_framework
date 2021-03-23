*** Settings ***
Resource      apigee_keywords.robot

*** Keywords ***
Post Pos Registration
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${APIGEE_SESSION}    /v1/terminals/activate    data=${data}    headers=&{api_headers}
    Set Test Variable    ${RESP}