*** Settings ***
Documentation    Tests to verify that updateMerchantTemplate api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification_producer/notification_producer_keywords.robot

# permission_name=notification.template.update
Suite Setup    Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}
Suite Teardown     Delete All Sessions

*** Variables ***
@{status_list}    ACTIVE    INACTIVE
${not_exist_template_id}    999999999

*** Test Cases ***
TC_O2O_06925
    [Documentation]    [NotificationProducer][updateMerchantTemplate] Request with "notification.template.update" permission returns 200
    [Tags]    Regression    High    Smoke    UnitTest
    Put Update Merchant Template    { "id": 1, "action": "TY_REJECT", "senderName": "TrueYou", "type": "SMS", "template": "ร้านของท่านไม่ผ่านการพิจารณาอนุมัติเป็นพันธมิตรร้านค้ากับทรู เนื่องจากรายการไม่สมบูรณ์ กรุณาลงทะเบียนอีกครั้งเพื่อยืนยันการสมัคร คลิก http://onelink.to/smartmerchant" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${1}
    Response Should Contain Property With Value    action    TY_REJECT
    Response Should Contain Property With Value    senderName    TrueYou
    Response Should Contain Property With Value    type    SMS
    Response Should Contain Property With Value    template    ร้านของท่านไม่ผ่านการพิจารณาอนุมัติเป็นพันธมิตรร้านค้ากับทรู เนื่องจากรายการไม่สมบูรณ์ กรุณาลงทะเบียนอีกครั้งเพื่อยืนยันการสมัคร คลิก http://onelink.to/smartmerchant
    Response Should Contain Property Value Include In List    status    ${status_list}

TC_O2O_06927
    [Documentation]    [NotificationProducer][updateMerchantTemplate] Request with not exist template returns 400
    [Tags]    Regression    Medium    Smoke    UnitTest    Sanity
    Put Update Merchant Template    { "id": ${not_exist_template_id}, "action": "TY_REJECT", "senderName": "TrueYou", "type": "SMS", "template": "ร้านของท่านไม่ผ่านการพิจารณาอนุมัติเป็นพันธมิตรร้านค้ากับทรู เนื่องจากรายการไม่สมบูรณ์ กรุณาลงทะเบียนอีกครั้งเพื่อยืนยันการสมัคร คลิก http://onelink.to/smartmerchant" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    entityName    template
    Response Should Contain Property With Value    errorKey    TEMPLATE_NOT_FOUND
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Not found an existing template
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.TEMPLATE_NOT_FOUND
    Response Should Contain Property With Value    params    template
    
TC_O2O_06926
    [Documentation]    [NotificationProducer][updateMerchantTemplate] Request without "notification.template.update" permission returns 403
    [Tags]    Regression    High    UnitTest
    [Setup]    Generate Robot Automation Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
    Put Update Merchant Template    { "id": 1, "action": "TY_REJECT", "senderName": "TrueYou", "type": "SMS", "template": "ร้านของท่านไม่ผ่านการพิจารณาอนุมัติเป็นพันธมิตรร้านค้ากับทรู เนื่องจากรายการไม่สมบูรณ์ กรุณาลงทะเบียนอีกครั้งเพื่อยืนยันการสมัคร คลิก http://onelink.to/smartmerchant" }
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${${FORBIDDEN_CODE}}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/merchant/templates
    Response Should Contain Property With Value    message    error.http.403