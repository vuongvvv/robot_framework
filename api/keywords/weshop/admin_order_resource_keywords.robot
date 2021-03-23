*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
Get Admin Get All Shop Orders
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /weshop/api/admin/orders    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Admin Order By Id
    [Arguments]    ${order_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /weshop/api/admin/orders/${order_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Verify All Statues In Order 
    [Arguments]    ${order_id}    ${order_status}    ${payment_status}    ${delivery_status}    
    Get Admin Order By Id    ${order_id}
    Response Should Contain Property With Value    .orderStatus    ${order_status}
    Response Should Contain Property With Value    .paymentStatus    ${payment_status}
    Response Should Contain Property With Value    .deliveryStatus    ${delivery_status}
                
Fetch Wefresh Order Id
    ${TEST_WEFRESH_ORDER_ID}=    Get Property Value From Json By Index    .orderProvider.orderId    0    
    Set Test Variable    ${TEST_WEFRESH_ORDER_ID}
    
Fetch Shipping Information
    ${TEST_DRIVER_TRACKING_NUMBER}=    Get Property Value From Json By Index    .driverTrackNumber    0
    ${TEST_ALI_REFERENCE}=    Get Property Value From Json By Index    .driverAliRef    0    
    Set Test Variable    ${TEST_DRIVER_TRACKING_NUMBER} 
    Set Test Variable    ${TEST_ALI_REFERENCE}