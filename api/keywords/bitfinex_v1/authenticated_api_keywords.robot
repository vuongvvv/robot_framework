*** Settings ***
     

*** Keywords ***
Post Account Infor
    [Arguments]    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    ${json_payload_body}    Set Variable    { "request": "/v1/account_infos", "nonce": "${${current_date}}" }
    
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/account_infos    json=${json_payload_body}    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Account Fee
    [Arguments]    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    ${json_payload_body}    Set Variable    { "request": "/v1/account_fees", "nonce": "${${current_date}}" }
    
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/account_fees    json=${json_payload_body}    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}