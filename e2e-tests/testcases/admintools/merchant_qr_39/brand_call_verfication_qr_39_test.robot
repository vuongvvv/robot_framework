*** Settings ***
Documentation     [O2O Merchant Onboard - Tag39] Callver admin & Fraud admin flow
...    ASCO2O-16661: As an admin, I want to have an admintool to approve before onboarding at TrueYou and TrueMoney, so that I call and verify merchant information
...    ASCO2O-25543: #39 TY call verification revise field

Resource    ../../../../api/resources/init.robot
Resource    ../../../../web/resources/init_robot_browser.robot
Resource    ../../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../../web/keywords/admintools/common/common_keywords.robot
Resource    ../../../../web/keywords/admintools/call_verification_qr_39/brand_call_verification_keywords.robot
Resource    ../../../../api/keywords/merchant/call_verification_resource_keywords.robot

# permission: merchantv2.shop.actAsAdmin,merchantv2.shop.read
Test Setup    Run Keywords    Open Browser With Option    ${ADMIN_TOOLS_URL}
...    AND    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
...    AND    Generate Robot Automation Header    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
Test teardown    Run Keywords    Clean Environment
...    AND    Delete All Sessions

*** Variables ***
@{brands_table_column_headers}    Brand ID    Brand Name (TH)    Brand Name (EN)    Call Verification Status    Provider    Registration Channel    Registration Date/Time    Modified Date/Time    Modified By    Actions
${edit_address}    188 ถนน สุขุมวิท 101/1 แขวง บางนา เขตบางนา กรุงเทพมหานคร
${edit_land_line}    66-61009532
${edit_email}    o2o.qatesting.edit@gmail.com

${edit_shop_1_name_th}    อภิสิทธิ์อดิศักดิ์
${edit_shop_1_name_en}    Emma Olivia
${edit_shop_1_contact_person_email_address}    o2o.qatesting.second@gmail.com
${edit_shop_1_contact_person_land_line}    66-61009073
${edit_shop_1_contact_full_name}    อรรถสิทธิ์ อัษฎา
${edit_shop_2_name_th}    อัญชลีพรอนุชา
${edit_shop_2_name_en}    Sofia Madison
${edit_shop_2_contact_person_email_address}    o2o.qatesting@gmail.com
${edit_shop_2_contact_person_land_line}    66-61009561
${edit_shop_2_contact_full_name}    Madison Elizabeth

# pre-condition note:
# Brand & Shop information should be created and change status to be WAITING_REVIEW
# test data: TC_O2O_22845
*** Test Cases ***
TC_O2O_23475
    [Documentation]    [O2O Merchant Onboard - Tag39] Callver admin flow can view Brand Information, and Shop information in both English & Thai
    [Tags]    Regression    E2E    High    o2o-admintools    o2o-merchant    cms
    Navigate On Left Menu Bar     Call Verification (QR39)    Brand
    Verify Brand Table Column Headers    ${brands_table_column_headers}
    Get Search Brand Callverification    brandEn=robot automation test&provider=TMN_TY&registerChannel=appretail&callVerStatus=WAITING_REVIEW&sort=createdDate,desc
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Brand Id
    
    Clear Search Results
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    
    Verify Brand Information    service_type=TrueMoney + Trueyou    business_type=INDIVIDUAL    
    ...    brand_name_th=ทดสอบ แบรนด์กรู๊ท_ส้ม    owner_name_th=robot automation    brand_name_en=robot automation test    owner_name_en=-
    ...    mobile=66-610095616    email=o2o.qatesting@gmail.com    date_of_birth=18/04/1990
    ...    start_end_privilege=2020-05-12 to 2021-05-12    true_card_privilege=8881518883597131    red_card_privilege=8881518883597131    black_card_privilege=8891578890779082
    ...    category=Food & Drink    sub_category=Shabu/Sukiyaki    address=61/5 ตรอกขุนนาวา ถนนพระราม4    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    ...    lang=en
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 1    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 1    business_type=INDIVIDUAL    wallet_no=0610095616    shop_type=Offline,Online
    ...    address=${SPACE}5555/111 สุขุมวิท    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    ...    contact_person_email_address=o2o.qatesting@gmail.com    contact_person_mobile_phone=66-610095616    contact_full_name=Robot Automation Test
    
    Navigate To Main Menu And Sub Main Menu    Language    ไทย
    Verify Brand Information    service_type=TrueMoney + Trueyou    business_type=INDIVIDUAL    
    ...    brand_name_th=ทดสอบ แบรนด์กรู๊ท_ส้ม    owner_name_th=robot automation    brand_name_en=robot automation test    owner_name_en=-
    ...    mobile=66-610095616    email=o2o.qatesting@gmail.com    date_of_birth=18/04/1990
    ...    start_end_privilege=2020-05-12 to 2021-05-12    true_card_privilege=8881518883597131    red_card_privilege=8881518883597131    black_card_privilege=8891578890779082
    ...    category=อาหารและเครื่องดื่ม    sub_category=ชาบู/สุกียากี้    address=61/5 ตรอกขุนนาวา ถนนพระราม4    province=กรุงเทพมหานคร    district=บางรัก    sub_district=มหาพฤฒาราม    post_code=10500
    ...    lang=th
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 1    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 1    business_type=INDIVIDUAL    wallet_no=0610095616    shop_type=Offline,Online
    ...    address=${SPACE}5555/111 สุขุมวิท    province=กรุงเทพมหานคร    district=บางรัก    sub_district=มหาพฤฒาราม    post_code=10500
    ...    contact_person_email_address=o2o.qatesting@gmail.com    contact_person_mobile_phone=66-610095616    contact_full_name=Robot Automation Test
    ...    lang=th
    Navigate To Main Menu And Sub Main Menu     ภาษา     English
    
    Click Load More Shop Button
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 1    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 1    business_type=INDIVIDUAL    wallet_no=0610095616    shop_type=Offline,Online
    ...    address=${SPACE}5555/111 สุขุมวิท    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    ...    contact_person_email_address=o2o.qatesting@gmail.com    contact_person_mobile_phone=66-610095616    contact_full_name=Robot Automation Test
    ...    shop_order=1
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 2    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 2    business_type=INDIVIDUAL    wallet_no=0610095616    shop_type=Offline
    ...    address=${SPACE}5555/111 สุขุมวิท    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    ...    contact_person_email_address=o2o.qatesting.second@gmail.com    contact_person_mobile_phone=66-610090735    contact_full_name=การทดสอบระบบอัตโนมัติของหุ่นยนต์
    ...    shop_order=2
    Click Cancel Button
    
    # click view button can only show, but not edit
    Click View By Brand Id    ${TEST_DATA_BRAND_ID}
    Verify Elements On View Brand Information Page Are Disabled
    
TC_O2O_22943
    [Documentation]    [O2O Merchant Onboard - Tag39] Callver admin can edit Brand information, and Shop information
    [Tags]    Regression    E2E    High    o2o-admintools    o2o-merchant    cms
    Navigate On Left Menu Bar     Call Verification (QR39)    Brand
    Verify Brand Table Column Headers    ${brands_table_column_headers}
    Get Search Brand Callverification    brandEn=robot automation test&provider=TMN_TY&registerChannel=appretail&callVerStatus=WAITING_REVIEW&sort=createdDate,desc
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Brand Id
    
    Clear Search Results
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    Click Load More Shop Button
    
    # edit brand & shop information
    Edit Brand Information    category=Shopping    sub_category=Skin Care/Hair/Body
    ...    address=${edit_address}    province=Chai Nat    district=Hankha    sub_district=Phrai Nok Yung
    ...    mobile=${edit_land_line}    email=${edit_email}
    Edit Shop Information    shop_name_th=${edit_shop_1_name_th}    shop_name_en=${edit_shop_1_name_en}
    ...    shop_types=Offline    address=${edit_address}    province=Chanthaburi    district=Soi Dao    sub_district=Thap Chang
    ...    contact_person_email_address=${edit_shop_1_contact_person_email_address}    contact_person_mobile_phone=${edit_shop_1_contact_person_land_line}    contact_full_name=${edit_shop_1_contact_full_name}
    Edit Shop Information    shop_name_th=${edit_shop_2_name_th}    shop_name_en=${edit_shop_2_name_en}
    ...    shop_types=Online    address=${edit_address}    province=Chanthaburi    district=Soi Dao    sub_district=Thap Chang
    ...    contact_person_email_address=${edit_shop_2_contact_person_email_address}    contact_person_mobile_phone=${edit_shop_2_contact_person_land_line}    contact_full_name=${edit_shop_2_contact_full_name}
    ...    shop_order=2
    Click Save Brand Call Verification Information
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    Click Load More Shop Button
    Verify Brand Information    service_type=TrueMoney + Trueyou    business_type=INDIVIDUAL    
    ...    brand_name_th=ทดสอบ แบรนด์กรู๊ท_ส้ม    owner_name_th=robot automation    brand_name_en=robot automation test    owner_name_en=-
    ...    mobile=${edit_land_line}    email=${edit_email}    date_of_birth=18/04/1990
    ...    start_end_privilege=2020-05-12 to 2021-05-12    true_card_privilege=8881518883597131    red_card_privilege=8881518883597131    black_card_privilege=8891578890779082    
    ...    category=Shopping    sub_category=Skin Care/Hair/Body    address=${edit_address}    province=Chai Nat    district=Hankha    sub_district=Phrai Nok Yung    post_code=17130    
    Verify Shop Information    shop_name_th=${edit_shop_1_name_th}    shop_name_en=${edit_shop_1_name_en}    business_type=INDIVIDUAL    wallet_no=0610095616
    ...    shop_type=Offline    address=${edit_address}    province=Chanthaburi    district=Soi Dao    sub_district=Thap Chang    post_code=22180
    ...    contact_person_email_address=${edit_shop_1_contact_person_email_address}    contact_person_mobile_phone=${edit_shop_1_contact_person_land_line}    contact_full_name=${edit_shop_1_contact_full_name}
    Verify Shop Information    shop_name_th=${edit_shop_2_name_th}    shop_name_en=${edit_shop_2_name_en}    business_type=INDIVIDUAL    wallet_no=0610095616
    ...    shop_type=Online    address=${edit_address}    province=Chanthaburi    district=Soi Dao    sub_district=Thap Chang    post_code=22180
    ...    contact_person_email_address=${edit_shop_2_contact_person_email_address}    contact_person_mobile_phone=${edit_shop_2_contact_person_land_line}    contact_full_name=${edit_shop_2_contact_full_name}
    ...    shop_order=2
    
    # change brand information back to the original
    Edit Brand Information    category=Food & Drink    sub_category=Shabu/Sukiyaki
    ...    address=61/5 ตรอกขุนนาวา ถนนพระราม4    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam
    ...    mobile=66-610095616    email=o2o.qatesting@gmail.com
    Edit Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 1    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 1
    ...    shop_types=Offline,Online    address=${SPACE}5555/111 สุขุมวิท    province=Bangkok    district=Bang Rak   sub_district=Maha Phruettharam
    ...    contact_person_email_address=o2o.qatesting@gmail.com    contact_person_mobile_phone=66-610095616    contact_full_name=Robot Automation Test
    Edit Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 2    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 2
    ...    shop_types=Offline    address=${SPACE}5555/111 สุขุมวิท    province=Bangkok    district=Bang Rak   sub_district=Maha Phruettharam
    ...    contact_person_email_address=o2o.qatesting.second@gmail.com    contact_person_mobile_phone=66-610090735    contact_full_name=การทดสอบระบบอัตโนมัติของหุ่นยนต์
    ...    shop_order=2
    Click Save Brand Call Verification Information
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    Click Load More Shop Button
    Verify Brand Information    service_type=TrueMoney + Trueyou    business_type=INDIVIDUAL    
    ...    brand_name_th=ทดสอบ แบรนด์กรู๊ท_ส้ม    owner_name_th=robot automation    brand_name_en=robot automation test    owner_name_en=-
    ...    mobile=66-610095616    email=o2o.qatesting@gmail.com    date_of_birth=18/04/1990
    ...    start_end_privilege=2020-05-12 to 2021-05-12    true_card_privilege=8881518883597131    red_card_privilege=8881518883597131    black_card_privilege=8891578890779082
    ...    category=Food & Drink    sub_category=Shabu/Sukiyaki    address=61/5 ตรอกขุนนาวา ถนนพระราม4    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 1    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 1    business_type=INDIVIDUAL    wallet_no=0610095616
    ...    shop_type=Offline,Online    address=${SPACE}5555/111 สุขุมวิท    province=Bangkok    district=Bang Rak   sub_district=Maha Phruettharam    post_code=10500
    ...    contact_person_email_address=o2o.qatesting@gmail.com    contact_person_mobile_phone=66-610095616    contact_full_name=Robot Automation Test
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 2    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 2    business_type=INDIVIDUAL    wallet_no=0610095616
    ...    shop_type=Offline    address=${SPACE}5555/111 สุขุมวิท    province=Bangkok    district=Bang Rak   sub_district=Maha Phruettharam    post_code=10500
    ...    contact_person_email_address=o2o.qatesting.second@gmail.com    contact_person_mobile_phone=66-610090735    contact_full_name=การทดสอบระบบอัตโนมัติของหุ่นยนต์
    ...    shop_order=2

TC_O2O_23476
    [Documentation]    [O2O Merchant Onboard - Tag39] Callver admin can change call verifcation status from Waiting for review to Passed
    [Tags]    Regression    E2E    High    o2o-admintools    o2o-merchant    cms
    Navigate On Left Menu Bar     Call Verification (QR39)    Brand
    Verify Brand Table Column Headers    ${brands_table_column_headers}
    Get Search Brand Callverification    brandEn=robot automation test&provider=TMN_TY&registerChannel=appretail&callVerStatus=WAITING_REVIEW&sort=createdDate,desc
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Brand Id
    
    Clear Search Results
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    Verify Elements On View Brand Information Page Are Enabled
    Verify Call Verification Details Status Dropdown Items    Waiting for Review${SPACE}    Attempt1${SPACE}    Passed${SPACE}    Rejected${SPACE}
    Verify Reject Reason And Remark Fields On Call Verification Details Are Disabled
    
    Edit Call Verification Details    call_verification_status=Attempt1
    Click Save Brand Call Verification Information
    
    Search Call Verification    call_verification_status=All
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    
    Verify Elements On View Brand Information Page Are Enabled
    Verify Call Verification Details Status Dropdown Items    Attempt1${SPACE}    Attempt2${SPACE}    Passed${SPACE}    Rejected${SPACE}
    Verify Reject Reason And Remark Fields On Call Verification Details Are Disabled
    Edit Call Verification Details    call_verification_status=Attempt2
    Click Save Brand Call Verification Information
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    Verify Elements On View Brand Information Page Are Enabled
    Verify Call Verification Details Status Dropdown Items    Attempt2${SPACE}    SMS${SPACE}    Passed${SPACE}    Rejected${SPACE}
    Verify Reject Reason And Remark Fields On Call Verification Details Are Disabled
    
    Edit Call Verification Details    call_verification_status=SMS
    Click Save Brand Call Verification Information
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    Verify Elements On View Brand Information Page Are Enabled
    Verify Call Verification Details Status Dropdown Items    SMS${SPACE}    Passed${SPACE}    Rejected${SPACE}
    Verify Reject Reason And Remark Fields On Call Verification Details Are Disabled
    
    Edit Call Verification Details    call_verification_status=Rejected    call_verification_reject_reason=Others    call_verification_remark=Robot Test Remark
    Verify Call Verification Details Reject Reason Dropdown Items    --Please Select--    Registration scam${SPACE}    Business closedown${SPACE}    Merchant reject Terms & Conditions${SPACE}    Merchant cannot be connected/reached${SPACE}    Merchant cancel their registration${SPACE}    Others${SPACE}
    
    Edit Call Verification Details    call_verification_status=Passed
    Click Save Brand Call Verification Information
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    Verify Elements On View Brand Information Page Are Disabled
    Verify Call Verification Details Status Dropdown Is Disabled
    Verify Reject Reason And Remark Fields On Call Verification Details Are Disabled