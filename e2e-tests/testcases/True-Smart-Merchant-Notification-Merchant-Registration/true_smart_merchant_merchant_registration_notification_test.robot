*** Settings ***
Documentation    E2E test for O2O-7136 - True Smart Merchant - Notification (Merchant Registration)

Resource    ../../../api/resources/init.robot
Resource    ../../../web/resources/init.robot
Resource    ../../../api/keywords/merchant_publisher/merchant_message_keywords.robot
Resource    ../../../web/keywords/admintools/notification-producer/histories_keywords.robot
Resource    ../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../api/keywords/notification_producer/notification_producer_keywords.robot

# scope:merchantTx.create,sms.read
# permission_group_name: Notification Template Admin Group,Notification History Admin Group
Test Setup    Run Keywords    Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}
...    AND    Get Template Id    action.equals=TY_REJECT&type.equals=SMS
...    AND    Put Update Template Status    { "id": ${TEST_DATA_TEMPLATE_ID}, "status": "ACTIVE" }
Test Teardown    Run Keywords    Delete All Sessions
...    AND    Clean Environment

*** Variables ***
${contact_number}    66-639-202-324

*** Test Cases ***
TC_O2O_07528
    [Documentation]    [E2E][NotificationMerchantRegistration] When TrueYou, or TrueMoney update Merchant Registration status to Reject, SMS message will be sent to the merchant's phone number
    [Tags]    Regression    High    E2E    Sanity    Smoke
    Put Publish Merchant Updated Event    TY_REJECT    { "createBy": "rpp_merchant", "createDate": "2019-05-16T21:31:34.196", "modifyBy": "rpp_merchant", "modifyDate": "2019-05-16T21:31:34.196", "id": 104594, "merchantId": "4608157", "trueyouId": "31208882418", "tmnMerchantId": "9455718", "businessType": "INDIVIDUAL", "categoryId": "90cdg8c080f2b6b699e5b711d13d4man", "categoryName": "pam", "storeTypeId": 1, "storeTypeName": "ไม่มีสาขา", "registerChannel": "APP_AGENT", "storeNameTh": "ร้านแป๋มเอง_แป๋มแป๋ม55", "storeNameEn": "Beauty_Pam store", "thaiId": "6753644811633", "titleId": 3, "titleName": "นางสาว", "firstName": "โรบอททดสอบ", "lastName": "ทดสอบโรบอท", "contactNo": "${contact_number}", "storeDetail": "shopping", "storeContactNo1": "${contact_number}", "storeContactNo2": "${contact_number}", "storeWebsite": null, "storeFacebook": "www.Beauty_Pam.com", "storeLineAt": "Beauty_Pam_LineAt", "storeTwitter": "Beauty_Pam_Twitter", "storeInstagram": "Beauty_Pam_Instagram", "email": "sipahtsanan.kit@ascendcorp.com", "lineId": "Beauty_Pam", "lineAt": "Beauty_Pam_LineAt", "refId": "19zrCUOvvu67qfypbI2hrmfXfB7aqB4f", "titleOtherName": null, "taxId": null, "deviceType": "QRCODE", "serviceTypes": [ "TMN", "TRUEYOU", "ECOM" ], "status": "APPROVE", "gender": "female", "tmnApiKey": null, "birthdate": "1990-09-09", "tmnStatus": null, "trueyouStatus": "REJECTED", "tmnApproveDate": "2018-10-25T16:37:16", "trueyouApproveDate": "2018-10-26T16:37:16", "approveDate": "2018-10-25T16:37:16", "merchantGroups": null, "subCategoryId": null, "subCategoryName": null, "tmnOperatorId": null, "tmnUrlQrCode": null, "tmnStatusRemark": null, "trueyouStatusRemark": null }
    Open Browser With Option    ${ADMIN_TOOLS_URL}
    Login Backoffice    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}
    Click the Hamburger Menu
    Navigate On Right Menu Bar    Notification Producer    Merchant History
    Search Histories    ${TEST_DATA_TEMPLATE_SENDERNAME}
    Click View Button On Row    1
    Text Value Of Locator Should Be    ${lbl_history_field}    66639202324    Contact
    Text Value Of Locator Should Be    ${lbl_history_field}    TY_REJECT    Action
    Text Value Of Locator Should Be    ${lbl_history_field}    SMS    Type
    Text Value Of Locator Should Be    ${lbl_history_field}    ${TEST_DATA_TEMPLATE_TEMPLATE}    Template
    Text Value Of Locator Should Be    ${lbl_history_field}    ${TEST_DATA_TEMPLATE_SENDERNAME}    Sender Name
    Text Value Of Locator Should Be    ${lbl_history_field}    ${EMPTY}    Remark
    Date Value Of Locator Greater Than    ${lbl_history_field}    today    Created Date