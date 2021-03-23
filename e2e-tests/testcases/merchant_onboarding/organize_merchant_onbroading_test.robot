*** Settings ***
Documentation    E2E test for Merchant onbroading process for Organize merchant
...  And Refer to https://truemoney.atlassian.net/browse/ASCO2O-27885
Resource        ../../../api/resources/init.robot
Resource        ../../../api/keywords/common/rpp_common.robot
Resource        ../../../api/keywords/rpp_merchant/merchant_resource_keywords.robot
Resource        ../../../api/keywords/rpp_merchant/activation_code_resource_keywords.robot
Resource        ../../../api/keywords/rpp_merchant/outlet_v_1_resource_keywords.robot
Resource        ../../../api/keywords/rpp_merchant/outlet_v_2_resource_keywords.robot
Resource        ../../../api/keywords/rpp_merchant/merchant_registration_resource_keywords.robot
Resource        ../../../api/keywords/rpp_payment/rpp_api_keywords.robot
Resource        ../../../api/keywords/rpp_merchant_bs/login_keywords.robot
Resource        ../../../api/keywords/rpp_merchant_bs/merchant_keywords.robot
Resource        ../../../web/resources/init.robot
Resource        ../../../web/keywords/retail_admin_portal/common/common_keywords.robot
Resource        ../../../web/keywords/retail_admin_portal/merchant_management/merchant_list_keywords.robot
Resource        ../../../web/keywords/retail_admin_portal/merchant_management/merchant_profile_keywords.robot
Resource        ../../../web/keywords/truemoney_admin_portal/merchant_management/shop_profile_keywords.robot
Resource        ../../../web/keywords/deal_management/common/common_keywords.robot
Resource        ../../../web/keywords/deal_management/partner_requests/partner_requests_list_keywords.robot
Resource        ../../../web/keywords/deal_management/partner_requests/partner_requests_detail_keywords.robot
Resource        ../../../web/keywords/deal_management/campaign_detail/campaign_detail_keywords.robot
Resource        ../../../api/keywords/common/date_time_common.robot
Resource        ../../../web/resources/testdata/alpha/truemoney_admin_portal/truemoney_admin_portal_testdata.robot
Resource        ../../../web/resources/testdata/alpha/true_you_deal_management/true_you_deal_management_testdata.robot

Test Setup    Run Keywords    Generate Robot Automation Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
...  AND    Generate Merchant Bs Header    ${RPP_AUTOMATE_SALE_USER}    ${RPP_AUTOMATE_SALE_PASSWORD}
...  AND    Create Merchant Via API
...  AND    Open Browser With Option    ${TRUE_YOU_DEAL_MANAGEMENT_URL}    JS_Site=${False}
...  AND    Login Deal Management    ${DEAL_MANAGEMENT_APPROVER_USERNAME}    ${DEAL_MANAGEMENT_APPROVER_PASSWORD}
...  AND    Navigate To Deal Management Menu    RPP-EDC    PROSPECT
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions    AND    Clean Environment
Test Template    Template - Create Merchant And Manage Merchant With Conditions

*** Variables ***
${merchant_th_name}    ทดสอบเมอร์ชันต์โดยภัทร
${merchant_en_name}    tbp_merchant_automate
${outlet_name_th}    ทดสอบเอ้าเลทโดยภัทร
${outlet_name_en}    tbp_outlet_automate

#revise reason
${revise_reason_detail_is_not_clearly}    รายละเอียดร้านค้าไม่ชัดเจน
${revise_reason_inappropriate_privileges}    สิทธิพิเศษไม่เหมาะสม
${revise_reason_picture_is_bad}    รูปภาพไม่ชัดเจน

#reject reason
${reject_reason_product_late}    รอสินค้าตามรายการส่งเสริมการขายนาน จึงขอยกเลิก
${reject_reason_miscommunicate}    รอสื่อประชาสัมพันธ์นาน จึงขอยกเลิก
${reject_reason_wait_edc}    รอเครื่อง EDC นาน จึงขอยกเลิก
${reject_reason_change_location}    ย้ายสถานที่
${reject_reason_close_down}    เลิกกิจการ
${reject_reason_no_need}    เปลี่ยนใจยกเลิกการสมัคร
${reject_reason_revise_longer_than_ninety}    ยกเลิกจากสถานะ Revise > 90วัน

${txt_reason}    tbp_reason

*** Test Cases ***
#TC can run on ALPHA only since STAGING environment is not ready
TC_O2O_10887
    [Documentation]    Ensure user can create new outlet for merchant (Service Type TY+TMN and Device type EDC).
    [Tags]     ExcludeSanity    ExcludeSmoke
    Approve

TC_O2O_27885_2
    [Documentation]    Ensure user can create new outlet for merchant (Service Type TY+TMN and Device type EDC) And Reject Merchant for some reason.
    [Tags]     ExcludeSanity    ExcludeSmoke
    Reject

TC_O2O_27885_3
    [Documentation]    Ensure user can create new outlet for merchant (Service Type TY+TMN and Device type EDC) And Revise Merchant for edit.
    [Tags]     ExcludeSanity    ExcludeSmoke
    Revise

*** Keywords ***
Template - Create Merchant And Manage Merchant With Conditions
    [Arguments]    ${condition}
    Run keyword if    '${condition}' == 'Approve'    Search Merchant And Approve Merchant Flow
    ...  ELSE IF    '${condition}' == 'Revise'    Search Merchant And Revise Merchant Flow
    ...  ELSE IF   '${condition}' == 'Reject'    Search Merchant And Reject Merchant Flow

Search Merchant And Approve Merchant Flow
    Verify Outlet Has Been Created
    Approve Merchant in True Money Admin Portal
    Check Merchant Status
    Verify Outlet Has Been Approved
    Switch Browser    1
    Approve Merchant in CHRM Deal Management
    Validate Merchant to Approve Status Via API

Search Merchant And Revise Merchant Flow
    Search Merchant From Textboxs    Merchant Name=${MERCHANT_NAME_EN_RAND}
    Click On Magnifier Icon
    Update Merchant Status And Input Reason    revise    ${revise_reason_picture_is_bad}    ${txt_reason}
    Navigate To Deal Management Menu    RPP-EDC    PROSPECT
    Search Merchant From Textboxs    Merchant Name=${MERCHANT_NAME_EN_RAND}
    Validate Merchant Status    ${MERCHANT_NAME_EN_RAND}    REVISE

Search Merchant And Reject Merchant Flow
    Search Merchant From Textboxs    Merchant Name=${MERCHANT_NAME_EN_RAND}
    Click On Magnifier Icon
    Update Merchant Status And Input Reason    reject    ${reject_reason_close_down}    ${txt_reason}
    Navigate To Deal Management Menu    RPP-EDC    PROSPECT
    Search Merchant From Textboxs    Merchant Name=${MERCHANT_NAME_EN_RAND}
    Validate Merchant Status    ${MERCHANT_NAME_EN_RAND}    CANCEL

Create Merchant Via API
    Create RPP Gateway Header
    Post Api Login     { "username":"${RPP_AUTOMATE_SALE_USER}", "password":"${RPP_AUTOMATE_SALE_PASSWORD}", "user_type":"sale" }
    Get Accesstoken
    Prepare Body For Create Merchant    ${merchant_en_name}    ${merchant_th_name}
    Post Api Create Merchant     ${finalbody}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With String Value    data.id
    Response Should Contain Property With String Value    data.merchant_id

    Get Merchant Information    storeNameEn=${MERCHANT_NAME_EN_RAND}
    Get Merchant Sequence ID
    Response Should Contain Property With Value    content..status    WAITING
    Response Should Contain Property With Value    content..tmnStatus    WAITING
    Response Should Contain Property With Value    content..'trueyouStatus'    WAITING

Verify Outlet Has Been Created
    Get Unix Time Stamp From Current Date    timestamp
#    Ignore Multi Outlet
#    Post Create Outlets And Address Ref Merchant Id    { "outlets": [ { "addresses": [ { "address": "TEST New Multi Outlet", "addressType": "store", "contentType": "test e2e", "districtId": 1, "latitude": "53.286518", "longtitude": "-6.416770", "postCode": "10250", "provinceId": 1, "road": "Ascesnd", "subdistrictId": 6 } ], "contactPersons": [ { "birthDate": "1988-10-10", "email": "pancake-automate-pool@ascend.com", "firstNameEn": "Ascend", "firstNameTh": "แอสเซนด์", "gender": "Female", "lastNameEn": "Only", "lastNameTh": "ออนลี่", "mobileNo": "66-864403645", "occupation": "Testing", "passportNo": null, "phoneNo": "020000000", "refId": 1234567890123, "refType": "CID", "thaiId": "${ACCOUNT_VALUE}", "titleId": 2, "titleOtherName": null } ], "merchantId": "${MERCHANT_SEQUENCE_ID}", "franchisee": true, "headQuarter": true, "outletDetail": "Test Outlet details", "outletNameEn": "${outlet_name_en}${UNIX_TIME_STAMP}", "outletNameTh": "${outlet_name_th}${UNIX_TIME_STAMP} ", "registerChannel": "app_sale_agent", "saleId": "0002", "status": "DRAFT", "tmnOutletId": null, "tmnStatus": "WAITING", "trueyouStatus": "WAITING" }] }
#    Response Correct Code    ${CREATED_CODE}
#    Response Should Contain Property With Value    outlets..outletNameEn    ${outlet_name_en}${UNIX_TIME_STAMP}
#    Response Should Contain Property With Value    outlets..status    WAITING
#    Response Should Contain Property With Value    outlets..tmnStatus    WAITING
#    Response Should Contain Property With Value    outlets.."trueyouStatus"    WAITING

    Get Search Outlet V1 By Merchant Name    ${MERCHANT_NAME_EN_RAND}
    Get Outlet Sequence Id
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    content..status    APPROVE
#    Verify for V2 Only.
#    Response Should Contain Property With Value    tmnStatus    WAITING
#    Response Should Contain Property With Value    "trueyouStatus"    WAITING

    Get Random Activation Code
    Put Create Activation Code For Outlet    ${OUTLET_SEQUENCE_ID}    { "activationCode" : "${RANDOM_ACTIVATION_CODE}", "amount" : 1, "notification": { "email" : "automation.pool@ascendcorp.com", "mobile" : "66-864403645", "receiver": "CUSTOM", "isGroup": true }, "terminal" : { "device" : "EDC" } }
    Get Terminal External ID
    Wait Until Api Keyword Response Property Change    Get Activation Code Information    content..status    CREATED    10    activationCode=${RANDOM_ACTIVATION_CODE}
    Response Should Contain Property With Value    content..status    WAITING_ACTIVATE

Approve Merchant in True Money Admin Portal
    Open Browser With Option    ${TRUE_MONEY_ADMIN_PORTAL_URL}    headless_mode=${False}    JS_Site=${False}
    Login True Money Admin Portal    ${TRUE_MONEY_ADMIN_PORTAL_USERNAME}    ${TRUE_MONEY_ADMIN_PORTAL_PASSWORD}
    Navigate To True Money Admin Portal Menu    Merchant Management    Merchant List
    Search Merchant By Propety And Value    Merchant Name    ${MERCHANT_NAME_TH_RAND}
    Click Visible Element    ${btn_admin_portal_view}
    Switch To New Window    NEW
    Edit Merchant Status    CERTIFICATED
    Validate Kyb Status And Merchant Status in Admin Portal    CERTIFICATED
    Close Browser

Check Merchant Status
    #Add waiting time for 5s before trigger the cron job
    sleep    5s
    Get Test Data Merchant Id On Mongo Database    merchant_name.en=${MERCHANT_NAME_EN_RAND}
    Create RPP Header
    Get True Money Check Approve    id=${MERCHANT_MONGO_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Get Merchant Information    id=${MERCHANT_SEQUENCE_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    content..status    WAITING
    Response Should Contain Property With Value    content..tmnStatus    APPROVE
    Response Should Contain Property With Value    content.."trueyouStatus"    WAITING

Verify Outlet Has Been Approved
    Wait Until Api Keyword Response Property Change    Get Search Outlet V1 By Merchant Name    content..status    APPROVE    10    ${MERCHANT_NAME_EN_RAND}
    Get Search Outlet V1 By Merchant Name    ${MERCHANT_NAME_EN_RAND}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    content..status    APPROVE
#    Verify for V2 Only.
#    Response Should Contain Property With Value    tmnStatus    APPROVE
#    Response Should Contain Property With Value    "trueyouStatus"    WAITING

Approve Merchant in CHRM Deal Management
    Search Merchant From Textboxs    Merchant Name=${MERCHANT_NAME_EN_RAND}
    Click On Magnifier Icon
    Wait until keyword succeeds    15    1s    Click On Button    Next
    Accept Popups
    Run Keyword And Ignore Error    Wait Until Page Contains    Next    5s
    Wait until keyword succeeds    15    1s    Click On Button    Next
    Input Test Data Campaign Details Popup    ช้อปกับทรู     ของเล่น/เกม    Brief   EDC/GMD    กรุงเทพ-ปริมณฑล
    Clean Environment

Validate Merchant to Approve Status Via API
    Wait Until Api Keyword Response Property Change    Get Search Outlet By Id    "trueyouStatus"    APPROVE    10    ${OUTLET_SEQUENCE_ID}
    Get Merchant Information    id=${MERCHANT_SEQUENCE_ID}
    Get Merchant ID
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    content..status    APPROVE
    Response Should Contain Property With Value    content..tmnStatus    APPROVE
    Response Should Contain Property With Value    content.."trueyouStatus"    APPROVE

    Get Search Outlet By Id    ${OUTLET_SEQUENCE_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    APPROVE
#    Verify for V2 Only.
#    Response Should Contain Property With Value    tmnStatus    APPROVE
#    Response Should Contain Property With Value    "trueyouStatus"    APPROVE
    Get Outlet Id

    Get Activation Code Information      activationCode=${RANDOM_ACTIVATION_CODE}
    Response Should Contain Property With Value    content..status    WAITING_ACTIVATE

    Put Activate Terminal    { "activationCode" : "${RANDOM_ACTIVATION_CODE}", "deviceNumber" : "EDC0001", "merchantId" : "${MERCHANT_ID}", "outletId" : "${OUTLET_ID}", "terminalId" : "${EXTERNAL_TERMINAL_ID}[0]"}
    Get Activation Code Information      activationCode=${RANDOM_ACTIVATION_CODE}
    Response Should Contain Property With Value    content..status    USED
    Get Terminal Information    ${RANDOM_ACTIVATION_CODE}
    Response Should Contain Property With Value    .status    ACTIVATE