*** Settings ***
Library    JsonValidator

*** Variables ***
${update_message_uri}    /merchantpublisher/api/merchants
${max_partition}    6
${is_found}    False

*** Keywords ***
Put Message Into Merchant Topic
    [Arguments]    ${header_action}    ${data}
    &{PUT_MESSAGE_GATEWAY_HEADER}=    Create Dictionary    Content-Type=application/json    action=${header_action}        Authorization=Bearer ${ACCESS_TOKEN}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${update_message_uri}    data=${data}        headers=&{PUT_MESSAGE_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Verify Topic Message
    [Arguments]    ${topic_url}    ${property_and_value}
    ${topic}=    Replace String    ${topic_url}    staging.    stg.
    FOR    ${value}    IN RANGE   0    ${max_partition}
        ${RESP}=            Get Request       ${GATEWAY_SESSION}      ${topic}${value}    headers=&{GATEWAY_HEADER}
        Set Test Variable   ${RESP}
        Response Correct Code    ${SUCCESS_CODE}
        ${resp_str}=    Replace String    ${RESP.text}    \\"    ${SPACE}
        ${resp_str}=    Remove String    ${resp_str}    \'
        ${is_found}=    Run Keyword And Ignore Error	  Element should exist    ${resp_str}    ${property_and_value}
        Exit For Loop IF    '${is_found}[0]'=='PASS'
    END
    Should Be True	'${is_found}[0]'=='PASS'
