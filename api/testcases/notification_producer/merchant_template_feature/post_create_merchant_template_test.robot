*** Settings ***
Documentation    Tests to verify that createMerchantTemplate api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification_producer/notification_producer_keywords.robot

# permission_name=notification.template.create
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}
Test Teardown     Delete All Sessions

*** Variables ***
${special_chars_sender_name}    se$nd%^

*** Test Cases ***
TC_O2O_06908
    [Documentation]    [NotificationProducer][createMerchantTemplate] Request with "notification.template.create" permission returns 200
    [Tags]    Regression    High    Smoke    UnitTest
    Post Create Merchant Template    { "action": "TY_REJECT", "senderName": "TrueYou", "type": "SMS", "template": "ร้านของท่านไม่ผ่านการพิจารณาอนุมัติเป็นพันธมิตรร้านค้ากับทรู เนื่องจากรายการไม่สมบูรณ์ กรุณาลงทะเบียนอีกครั้งเพื่อยืนยันการสมัคร คลิก http://onelink.to/smartmerchant" }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Number String    id
    Response Should Contain Property With Value    action    TY_REJECT
    Response Should Contain Property With Value    senderName    TrueYou
    Response Should Contain Property With Value    type    SMS
    Response Should Contain Property With Value    template    ร้านของท่านไม่ผ่านการพิจารณาอนุมัติเป็นพันธมิตรร้านค้ากับทรู เนื่องจากรายการไม่สมบูรณ์ กรุณาลงทะเบียนอีกครั้งเพื่อยืนยันการสมัคร คลิก http://onelink.to/smartmerchant
    Response Should Contain Property With Value    status    INACTIVE

TC_O2O_06917
    [Documentation]    [NotificationProducer][createMerchantTemplate] Request with "senderName" field has special characters returns 400
    [Tags]    Regression    Medium    Smoke    UnitTest    Sanity
    Post Create Merchant Template    { "action": "TY_REJECT", "senderName": "${special_chars_sender_name}", "type": "SMS", "template": "ร้านของท่านไม่ผ่านการพิจารณาอนุมัติเป็นพันธมิตรร้านค้ากับทรู เนื่องจากรายการไม่สมบูรณ์ กรุณาลงทะเบียนอีกครั้งเพื่อยืนยันการสมัคร คลิก http://onelink.to/smartmerchant" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    entityName    template
    Response Should Contain Property With Value    errorKey    SENDER_NAME_INVALID_FORMAT
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    SMS Sender Name must match with ^[a-zA-Z0-9_]*$ pattern
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.SENDER_NAME_INVALID_FORMAT
    Response Should Contain Property With Value    params    template