*** Settings ***
Resource    bitfinex_common.robot
Resource    ../../../utility/common/string_common.robot

*** Keywords ***
Post New Order
    [Documentation]    Submit a new Order, can be used to create margin, exchange, and derivative orders.
    [Arguments]    ${payload}    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    
    ${json_payload_body}    Replace String From Right    ${payload}    }     , "request": "/v1/order/new", "nonce": "${${current_date}}" }
    
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/order/new    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Multiple New Orders
    [Documentation]    Submit several new orders at once, can be used to create margin, exchange, and derivative orders.
    [Arguments]    ${payload}    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    ${json_payload_body}    Replace String From Right    ${payload}    }     , "request": "/v1/order/new/multi", "nonce": "${${current_date}}" }
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/order/new/multi    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Cancel Order
    [Arguments]    ${order_id}    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    ${json_payload_body}    Set Variable    { "order_id": ${order_id}, "request": "/v1/order/cancel", "nonce": "${${current_date}}" }
    
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/order/cancel    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Cancel Multiple Order
    [Arguments]    ${payload}    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    # ${json_payload_body}    Replace String From Right    ${payload}    }     , "request": "/v1/order/cancel/multi", "nonce": "${${current_date}}" }
    ${json_payload_body}    Set Variable    { "order_ids": ${payload}, "request": "/v1/order/cancel/multi", "nonce": "${${current_date}}" }
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/order/cancel/multi    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Cancel All Orders
    Create Authenticated Header    /v1/order/cancel/all
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/order/cancel/all    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Order Status
    [Arguments]    ${order_id}    ${api_key}=${BITFINEX_API_KEY}    ${api_secret}=${BITFINEX_API_SECRET}
    ${current_date}    Get Current Date    result_format=epoch
    ${current_date}    Evaluate    ${current_date}*1000
    ${json_payload_body}    Set Variable    { "order_id": ${order_id}, "request": "/v1/order/status", "nonce": "${${current_date}}" }
    
    ${base64_payload}    Encode Base64 String    ${json_payload_body}
    ${signature}    Encode SHA384    ${BITFINEX_API_SECRET}    ${base64_payload}
    
    &{BITFINEX_V1_HEADER}    Create Dictionary    X-BFX-APIKEY=${api_key}    X-BFX-PAYLOAD=${base64_payload}    X-BFX-SIGNATURE=${signature}
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/order/status    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}
    
Post Active Order
    Create Authenticated Header    /v1/orders
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/orders    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}

Post Order History
    [Documentation]    https://docs.bitfinex.com/v1/reference#rest-auth-orders-history
    Create Authenticated Header    /v1/orders/hist
    ${RESP}    Post Request    ${BITFINEX_SESSION_V1}    /v1/orders/hist    headers=&{BITFINEX_V1_HEADER}
    Set Test Variable    ${RESP}