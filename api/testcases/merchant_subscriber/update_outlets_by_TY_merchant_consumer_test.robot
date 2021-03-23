*** Settings ***
Documentation    Tests to verify TY Merchant Consumer can update all the outlets belong to the merchant from WAITING to IN_PROGRESS in Master Merchant
Resource    ../../resources/init.robot
Resource    ../../keywords/common/gateway_common.robot
Resource    ../../keywords/rpp_merchant/outlet_v_2_resource_keywords.robot
Resource    ../../keywords/merchant_subscriber/topic_message_management.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${MERCHANT_SUBSCRIBER_USERNAME}    ${MERCHANT_SUBSCRIBER_PASSWORD}    merchant.merchant.write,merchant.outlet.write,merchant.outlet.read,merchant.outlet.actAsAdmin,merchantTx.create    permission_name=merchantPublisher.msg.actAsAdmin,merchantSubscriber.msg.actAsAdmin
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${merchantPub_merchant_topic_url}    /messagetool/api/topics/${ENV}.merchantPub-merchant/messages?page=1&size=25&sort=desc&partitionNumber=
${merchantSub_merchant_trueyou_topic_url}    /messagetool/api/topics/${ENV}.merchantSub-merchant-trueyou/messages?page=1&size=25&sort=desc&partitionNumber=
${merchantSub_outlet_trueyou_topic_url}    /messagetool/api/topics/${ENV}.merchantSub-outlet-trueyou/messages?page=1&size=25&sort=desc&partitionNumber=

*** Test Cases ***
TC_O2O_06584
    [Documentation]    [TY Merchant] Verify TY Merchant Consumer can update all the outlets belong to the merchant from WAITING to IN_PROGRESS in Master Merchant
    [Tags]    Regression    High    MerchantSubscriber    Smoke
    Get Random Merchant IDs Follow Business Instruction
    Post Create Merchant    {"merchantId":"${MERCHANT_BRAND_ID}","trueyouId":"${MERCHANT_TY_ID}","tmnMerchantId":"${MERCHANT_TMN_ID}","refId":"${MERCHANT_BRAND_ID}","businessType":"INDIVIDUAL","categoryId":"5948d60ee1382323583e31c7","storeTypeId":1,"registerChannel":"mobile_admin_register","storeContactNo1":"0821022951","storeContactNo2":"0821022951","storeNameTh":"ร้านแพนเค้กของออโตเมทพูล","storeNameEn":"Pancake shop of Automate Pool team","storeDetail":"Mobile maketing","storeWebsite":"https://automate-pool-pancake.com","storeFacebook":"www.facebook.com/automate-pool-pancake","storeLineAt":"@automate-pool-pancake","storeTwitter":"automate-pool-pancake@twitter","storeInstagram":"automate-pool-pancake","thaiId":"1234567890123","taxId":"1234567890123","titleId":1,"titleOtherName":"-","firstName":"James","lastName":"Liew","email":"automate-pool-pancake@hotmail.com","contactNo":"0123456789","lineAt":"@automate-pool-pancake","lineId":"automate-pool-pancake","deviceType":"EDC","status":"WAITING","serviceTypes":["TMN","TY"],"birthdate":"2018-01-30","gender":"male","tmnStatus":"WAITING","trueyouStatus":"WAITING","tmnApproveDate":"2018-01-30T17:30:11","trueyouApproveDate":"2018-01-30T17:30:11","approveDate":"2018-01-30T17:30:11","tmnApiKey":"","road":null,"address":"222/9","addressType":"merchant","postCode":"10140","districtId":1,"provinceId":1,"subdistrictId":1}
    Get Random Outlets IDs Follow Business Instruction    1
    Post Create Outlets And Address Ref Merchant Id    { "outlets": [ { "addresses": [ { "address": "automate-pool-pancake-outlet", "addressType": "store", "contentType": "test e2e", "districtId": 1, "latitude": "53.286518", "longtitude": "-6.416770", "postCode": "10250", "provinceId": 1, "road": "Ascesnd", "subdistrictId": 6 } ], "contactPersons": [ { "birthDate": "1988-10-10", "email": "automate-pool-pancake-outlet@ascendcorp.com", "firstNameEn": "TestAscend", "firstNameTh": "ทดสอบแอสเซนด์", "gender": "Female", "lastNameEn": "Only", "lastNameTh": "ออนลี่", "mobileNo": "66-823103265", "occupation": "Testing", "passportNo": null, "phoneNo": "020000000", "refId": 1234567890123, "refType": "CID", "thaiId": "1529900321000", "titleId": 2, "titleOtherName": null } ], "merchantId": ${MERCHANT_SEQUENCE_ID}, "franchisee": true, "headQuarter": true, "outletDetail": "Test Outlet details", "outletNameEn": "automate-pool-pancake-outlet", "outletNameTh": "แพนเค้ก เอ้าท์เล็ท ", "registerChannel": "app_sale_agent", "saleId": "0002", "status": "WAITING", "tmnOutletId": "@{OUTLET_TMN_ID}[0]", "tmnStatus": "WAITING", "trueyouStatus": "WAITING", "outletId": "@{OUTLET_EXTERNAL_ID}[0]","trueyouId": "@{OUTLET_TY_ID}[0]" } ] }
    Put Message Into Merchant Topic    TY_APPROVE    {"id": ${MERCHANT_SEQUENCE_ID},"merchantId": "${MERCHANT_BRAND_ID}","trueyouStatus": "APPROVE"}
    Response Correct Code    ${ACCEPTED_CODE}
    Verify Topic Message    ${merchantPub_merchant_topic_url}    .payload:contains("id :${MERCHANT_SEQUENCE_ID}")&.payload:contains("trueyouStatus : APPROVE")
    Verify Topic Message     ${merchantSub_merchant_trueyou_topic_url}    .payload:contains("id :${MERCHANT_SEQUENCE_ID}")&.payload:contains("trueyouStatus : APPROVE")
    Get Search Outlet By Id    ${OUTLET_SEQUENCE_ID}
    Response Should Contain Property With Value    .'trueyouStatus'    IN_PROGRESS
#    Comment out the last test step since following toggle are off in STG:
#    - merchantPubOutletTmnInProgress
#    - merchantPubOutletTrueYouInProgress
#    Verify Topic Message    ${merchantSub_outlet_trueyou_topic_url}    .payload:contains("id :${OUTLET_SEQUENCE_ID}")&.headers.action:contains("TY_IN_PROGRESS")&.headers.API_VERSION:contains("2")