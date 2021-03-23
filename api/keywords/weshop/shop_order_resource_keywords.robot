*** Keywords ***
Put Update Shop Order
    [Arguments]    ${shop_id}    ${order_id}    ${status}
    ${payload}=    Set Variable    {"actor": "MERCHANT", "orderStatus": "${status}"}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /weshop/api/shops/${shop_id}/orders/${order_id}    ${payload}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    Sleep    2s
    
Post Create New Shop Order
    [Arguments]    ${shop_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /weshop/api/shops/${shop_id}/orders    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Order By Id
    [Arguments]    ${shop_id}    ${order_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /weshop/api/shops/${shop_id}/orders/${order_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
        
Fetch Order Id
    ${TEST_ORDER_ID}=    Get Property Value From Json By Index    id    0
    Set Test Variable    ${TEST_ORDER_ID}
    
Wait WeFresh Order Created
    #Sleep to wait WeFresh order to be created
    Sleep    10s