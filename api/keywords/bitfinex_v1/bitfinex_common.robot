*** Settings ***
Library    RequestsLibrary    
Library    DateTime
Library    Collections        
Library    ../../python_library/common/EncodeLibrary.py   

*** Keywords ***
Create Bitfinex V1 Session
    Create Session    ${BITFINEX_SESSION_V1}    ${BITFINEX_HOST_V1}    verify=true
    
Create Authenticated Header
    [Arguments]    ${endpoint}    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    ${json_payload_body}    Set Variable    { "request": "${endpoint}", "nonce": "${${current_date}}" }
    
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}