*** Settings ***
Documentation    Verify users can upload / add delivery status / and approve the brand new merchant
Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/rpp_merchant_bs/login_keywords.robot
Resource    ../../../api/keywords/rpp_merchant_bs/merchant_keywords.robot
Resource    ../../../api/keywords/common/date_time_common.robot

Resource    ../../resources/init_non_angular.robot
Resource    ../../resources/testdata/${ENV}/audit_web/audit_web_testdata.robot
Resource    ../../../web/keywords/audit_web/common/common_keywords.robot
Resource    ../../../web/keywords/audit_web/login/login_page_keywords.robot
Resource    ../../../web/keywords/audit_web/merchant_list/merchant_list_page_keywords.robot
Resource    ../../../web/keywords/audit_web/merchant_details/merchant_details_page_keywords.robot

Test Setup    Run Keywords    Get Date With Format And Increment    %d/%m/%Y    1 day    
...    AND    Open Browser With Option    ${AUDIT_WEB_URL}
Test Teardown    Run Keywords    Delete All Sessions    
...    AND    Clean Environment

*** Variables ***
${merchant_name_en}    Test_verify_merchant_
${merchant_name_th}    ทดสอบ_ตรวจสอบเมอชานต์_
${delivery_status}    DELIVERED (ส่งสินค้าสำเร็จ)
${action_by}    Sendit (Sendit)
${expected_delivery_status}    DELIVERED
${registration_type}    Makro
${qrcode_device_type_code}    ${3}
${tmn_service_type_code}    ${5}

*** Test Cases ***
TC_O2O_11606
    [Documentation]    Verify Sale user can upload merchant pictures, Sendit user can add QR code delivery information, and Fraud user approve the brand new merchant
    [Tags]    Sanity    Smoke   E2E    audit-web    trueyou
    #Create merchant via BS service
    Generate Merchant Bs Header    ${RPP_AUTOMATE_SALE_USER}    ${RPP_AUTOMATE_SALE_PASSWORD}    
    Prepare Body For Create Merchant    ${merchant_name_en}    ${merchant_name_th}    ${qrcode_device_type_code}    ${tmn_service_type_code}
    Post Api Create Merchant    ${FINAL_BODY}
    Fetch Property From Response    data.id    MERCHANT_MONGO_ID
    
    #Sale user upload merchant images
    Login To Audit Web   ${AUDIT_WEB_SALE_USERNAME}    ${AUDIT_WEB_SALE_PASSWORD}
    Search Need To Operate Stores    search_property=ค้นหาชื่อร้านภาษาไทย    search_data=${MERCHANT_NAME_TH_RAND}
    Click Magnifier Icon On Top Of Search Result
    Select Merchant Registration Type    ${registration_type}
    Search Need To Operate Stores    search_property=ค้นหาชื่อร้านภาษาไทย    search_data=${MERCHANT_NAME_TH_RAND}
    Click Magnifier Icon On Top Of Search Result
    Upload Merchant Images
    Clean Environment
    
    #Sendit user update QR code delivery status    
    Open Browser With Option    ${AUDIT_WEB_URL}
    Login To Audit Web   ${AUDIT_WEB_SENDIT_USERNAME}    ${AUDIT_WEB_SENDIT_PASSWORD}
    Search QR Code Merchants    search_end_date=${DESIRED_DATE}
    Click Pencil Icon On Top Of Search Result    ${MERCHANT_MONGO_ID}
    Add Delivery Status Information    ${delivery_status}    ${action_by}    ${expected_delivery_status}
    Clean Environment

    #Fraud user approve merchant TMN status
    Open Browser With Option    ${AUDIT_WEB_URL}
    Login To Audit Web   ${AUDIT_WEB_FRAUD_USERNAME}    ${AUDIT_WEB_FRAUD_PASSWORD}
    Go To Url    ${AUDIT_WEB_URL}/engine/store/${MERCHANT_MONGO_ID}
    Verify Merchant Detail Page Should Contain Information    ชื่อร้าน (TH)   ${MERCHANT_NAME_TH_RAND}
    Verify Merchant Detail Page Should Contain Information    อีเว้นท์ / ประเภทการสมัคร    ${registration_type}
    Verify Merchant Detail Page Should Contain Information    สถานะการสมัคร    WAITING
    Verify Merchant Detail Page Should Contain Information    โดย    sendit
    Update TMN Status    REJECT
    Go To Url    ${AUDIT_WEB_URL}/engine/store/${MERCHANT_MONGO_ID}
    Verify Merchant Detail Page Should Contain Information    ชื่อร้าน (TH)   ${MERCHANT_NAME_TH_RAND}
    Verify Merchant Detail Page Should Contain Information    สถานะการสมัคร    REJECT
    Verify Merchant Detail Page Should Contain Information    สถานะทรูมันนี่    REJECT    