*** Settings ***
Documentation    E2E tests for TrueTown - WeFresh & WeShop integration

Resource    ../../../api/resources/init.robot
Resource    ../../../api/resources/testdata/${ENV}/weshop/weshop_data.robot
Resource    ../../../api/keywords/weshop/admin_order_resource_keywords.robot
Resource    ../../../api/keywords/weshop/shop_order_resource_keywords.robot
Resource    ../../../api/keywords/weshop/otp_payment_resource_keywords.robot
Resource    ../../../api/keywords/weshop/we_shop_webhook_event_resource_keywords.robot

# scope=weshop.order.*,weshop.order.confirm    permission_name=weshop.order.admin
Test Setup    Generate Robot Automation Header    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER_PASSWORD}    gateway=we-platform
Test Teardown    Delete All Sessions

# CREATE_TRUE_TOWN_TEST_DATA
*** Test Cases ***
TC_O2O_21368
    [Documentation]    [WeFresh & WeShop] Customer ordered the food and is delivered successful
    [Tags]     E2E    High    ASCO2O-21569
    Post Create New Shop Order    ${WEFRESH_SHOP_ID}    { "totalPrice": 18, "products": [ { "productId": "${WEFRESH_PRODUCT_ID}", "productNameTh": "ซุปไข่", "productNameEn": "", "price": 8, "quantity": 1, "unit": "DISH", "totalPrice": 8, "remark": "no remark" } ], "shipping": { "method": "delivery", "fee": 10, "name": "string", "phone": "0639202324", "registerNo": "string", "address": { "address": "string", "province": "string", "district": "string", "subDistrict": "string", "postCode": "10900", "country": "string", "longitude": "100.578289", "latitude": "13.6862485" } }, "paymentChannel": "TMN_WALLET_OTP" }
    Fetch Order Id
    Verify All Statues In Order    ${TEST_ORDER_ID}    waiting    waiting    ${null}
    Post Get Otp    ${TRUE_MONEY_ACCOUNT}
    Fetch Otp Ref And Authorization Code
    Post Verify Otp And Charge    ${TEST_ORDER_ID}    { "mobile": "${TRUE_MONEY_ACCOUNT}", "otpRef": "${OTP_REF}", "otpCode": "${TRUE_MONEY_MOCKED_OTP}", "authCode": "${AUTHORIZATIN_CODE}", "store": true }
    Get Order By Id    ${WEFRESH_SHOP_ID}    ${TEST_ORDER_ID}
    Wait WeFresh Order Created
    Get Admin Get All Shop Orders
    Fetch Wefresh Order Id
    # Fetch Shipping Information    
    Verify All Statues In Order    ${TEST_ORDER_ID}    created    success    waiting
    #Driver accepts the order
    Post Wefresh Order Event    ${WEFRESH_SHOP_ID}    { "event": "ORDER", "sub_event": "DRIVER_ASSIGNED", "data": { "order_id": "${TEST_WEFRESH_ORDER_ID}" } }        
    Verify All Statues In Order    ${TEST_ORDER_ID}    pending    success    picking
    #Merchant accepts the order
    Put Update Shop Order    ${WEFRESH_SHOP_ID}    ${TEST_ORDER_ID}    IN_PROGRESS
    Verify All Statues In Order    ${TEST_ORDER_ID}    in_progress    success     picking
    #Merchant prepared the order
    Put Update Shop Order    ${WEFRESH_SHOP_ID}    ${TEST_ORDER_ID}    PREPARED
    Verify All Statues In Order    ${TEST_ORDER_ID}    prepared    success     picking
    #Driver picked up the order
    Post Wefresh Order Event    ${WEFRESH_SHOP_ID}    { "event": "ORDER", "sub_event": "SHIPPING", "data": { "order_id": "${TEST_WEFRESH_ORDER_ID}", "status": "SHIPPING" } }
    Verify All Statues In Order    ${TEST_ORDER_ID}    picked    success     picked
    #Driver delivered the order
    Post Wefresh Order Event    ${WEFRESH_SHOP_ID}    { "event": "ORDER", "sub_event": "COMPLETED", "data": { "order_id": "${TEST_WEFRESH_ORDER_ID}", "status": "COMPLETED" } }
    Verify All Statues In Order    ${TEST_ORDER_ID}    success    success     delivered
    
TC_O2O_21536
    [Documentation]    [WeFresh & WeShop] Customer ordered the food, order accepted by Rider but order rejected by Merchant
    [Tags]     E2E    High    ASCO2O-21569
    Post Create New Shop Order    ${WEFRESH_SHOP_ID}    { "totalPrice": 18, "products": [ { "productId": "${WEFRESH_PRODUCT_ID}", "productNameTh": "ซุปไข่", "productNameEn": "", "price": 8, "quantity": 1, "unit": "DISH", "totalPrice": 8, "remark": "no remark" } ], "shipping": { "method": "delivery", "fee": 10, "name": "string", "phone": "0639202324", "registerNo": "string", "address": { "address": "string", "province": "string", "district": "string", "subDistrict": "string", "postCode": "10900", "country": "string", "longitude": "100.578289", "latitude": "13.6862485" } }, "paymentChannel": "TMN_WALLET_OTP" }
    Fetch Order Id
    Verify All Statues In Order    ${TEST_ORDER_ID}    waiting    waiting    ${null}
    Post Get Otp    ${TRUE_MONEY_ACCOUNT}
    Fetch Otp Ref And Authorization Code
    Post Verify Otp And Charge    ${TEST_ORDER_ID}    { "mobile": "${TRUE_MONEY_ACCOUNT}", "otpRef": "${OTP_REF}", "otpCode": "${TRUE_MONEY_MOCKED_OTP}", "authCode": "${AUTHORIZATIN_CODE}", "store": true }
    Get Order By Id    ${WEFRESH_SHOP_ID}    ${TEST_ORDER_ID}
    Wait WeFresh Order Created
    Get Admin Get All Shop Orders
    Fetch Wefresh Order Id
    # Fetch Shipping Information    
    Verify All Statues In Order    ${TEST_ORDER_ID}    created    success    waiting
    #Driver accepts the order
    Post Wefresh Order Event    ${WEFRESH_SHOP_ID}    { "event": "ORDER", "sub_event": "DRIVER_ASSIGNED", "data": { "order_id": "${TEST_WEFRESH_ORDER_ID}" } }        
    Verify All Statues In Order    ${TEST_ORDER_ID}    pending    success    picking
    #Merchant rejects the order
    Put Update Shop Order    ${WEFRESH_SHOP_ID}    ${TEST_ORDER_ID}    CANCEL
    Verify All Statues In Order    ${TEST_ORDER_ID}    cancel    cancel     cancel    