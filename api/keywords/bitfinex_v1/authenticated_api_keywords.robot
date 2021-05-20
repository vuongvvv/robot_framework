*** Settings ***
Resource    bitfinex_common.robot     

*** Keywords ***
Post Account Infor
    Create Authenticated Header    /v1/account_infos
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/account_infos    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Account Fee
    Create Authenticated Header    /v1/account_fees
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/account_fees    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Summary
    Create Authenticated Header    /v1/summary
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/summary    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Deposit
    [Arguments]    ${method}    ${wallet_name}    ${renew}=0    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    ${json_payload_body}    Set Variable    { "method":"${method}", "wallet_name":"${wallet_name}","renew": ${renew}, "request": "/v1/deposit/new", "nonce": "${${current_date}}" }
    
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/deposit/new    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Transfer Between Wallets
    [Arguments]    ${amount}    ${currency}    ${wallet_from}    ${wallet_to}    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    ${json_payload_body}    Set Variable    { "amount":"${amount}", "currency":"${currency}","walletfrom": "${wallet_from}","walletto": "${wallet_to}", "request": "/v1/transfer", "nonce": "${${current_date}}" }
    
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/transfer    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Key Permissions
    Create Authenticated Header    /v1/key_info
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/key_info    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Margin Information
    Create Authenticated Header    /v1/margin_infos
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/margin_infos    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Wallet Balances
    Create Authenticated Header    /v1/balances
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/balances    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}