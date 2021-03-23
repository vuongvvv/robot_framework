*** Settings ***
Documentation     [O2O Merchant Onboard - Tag39] Callver admin & Fraud admin flow

Resource    ../../../../api/resources/init.robot
Resource    ../../../../web/resources/init.robot
Resource    ../../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../../web/keywords/admintools/common/common_keywords.robot
Resource    ../../../../web/keywords/admintools/fraud_approval/fraud_admin_approval_keywords.robot
Resource    ../../../../api/keywords/merchant/fraud_resource_keywords.robot

# permission: merchantv2.brandFraud.actAsAdmin,merchantv2.shop.actAsAdmin,merchantv2.shop.read
Test Setup    Run Keywords    Open Browser With Option    ${ADMIN_TOOLS_URL}
...    AND    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
...    AND    Navigate On Left Menu Bar     Fraud Approval    Brand
Test teardown    Clean Environment

*** Variables ***
@{merchants_table_column_headers}    Brand ID    Thai ID    Brand Name (TH)    Brand Name (EN)    TrueMoney Wallet No.    Fraud Approval Status    Registration Channel    Registration Date/Time    Modified Date/Time    Modified By    Actions
@{merchants_table_column_headers_with_data}    Brand ID    Thai ID    Brand Name (TH)    Brand Name (EN)    TrueMoney Wallet No.    Fraud Approval Status    Registration Channel    Registration Date/Time    Modified Date/Time    Modified By
${edit_address}    188 ถนน สุขุมวิท 101/1 แขวง บางนา เขตบางนา กรุงเทพมหานคร
${test_brand_name_en}    TrueYou And TrueMoney Test
${test_true_money_wallet_no_66_format}    66610095616
${test_true_money_wallet_no_0_format}    0610095616

# pre-condition note:
# Brand & Shop information should be created and change status to be WAITING_REVIEW
# test data: TC_O2O_22845 -> TC_O2O_23476
*** Test Cases ***
TC_O2O_24467
    [Documentation]    [O2O Merchant Onboard - Tag39] Fraud admin can view "Brand Fraud Approval" page
    [Tags]    Regression    E2E    High    o2o-admintools    o2o-merchant    cms
    Verify Table Column Headers    ${merchants_table_column_headers}
    
    # verify sort function
    Clear Search Results
    Verify Data Exist On Column Headers    ${merchants_table_column_headers_with_data}
    Sort By Column    Brand ID    desc
    Verify Data On Column Is Sorting    Brand ID    desc
    Sort By Column    Brand ID    asc
    Verify Data On Column Is Sorting    Brand ID    asc
    
    # verify search function
    Search Merchants    brand_name_en=${test_brand_name_en}
    Verify Data By Column    Brand Name (EN)    ${test_brand_name_en}
    Clear Search Results
    
    Search Merchants    registration_channel=App Agent
    Verify Data By Column    Registration Channel    App Agent
    Clear Search Results
    
    Search Merchants    true_money_wallet_no=${test_true_money_wallet_no_66_format}
    Verify Data By Column    TrueMoney Wallet No.    ${test_true_money_wallet_no_0_format}
    Clear Search Results
    
    Search Merchants    true_money_wallet_no=${test_true_money_wallet_no_0_format}
    Verify Data By Column    TrueMoney Wallet No.    ${test_true_money_wallet_no_0_format}
    
TC_O2O_24449
    [Documentation]    [O2O Merchant Onboard - Tag39] Fraud admin can view Brand, Owner information, Fraud Review in both English & Thai
    [Tags]    Regression    E2E    High    o2o-admintools    o2o-merchant    cms
    Generate Robot Automation Header    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
    Get Search Brand Fraud    brandEn=${test_brand_name_en}&registerChannel=appagent&fraudStatus=WAITING_REVIEW&sort=createdDate,desc
    Fetch Property From Response    .brandId    TEST_DATA_BRAND_ID
    
    Clear Search Results
    Click View By Brand Id    ${TEST_DATA_BRAND_ID}
    
    # verify brand information
    Verify Brand Information    brand_name_th=ร้านค้าทดสอบนะ    business_type=INDIVIDUAL
    ...    brand_name_en=${test_brand_name_en}    service_type=TrueMoney + Trueyou 
    ...    category=${SPACE}Food & Drink${SPACE}    register_channel=App Agent
    ...    sub_category=${SPACE}Shabu/Sukiyaki${SPACE}    settlement_type=WALLET
    ...    address=61/5 ตรอกขุนนาวา ถนนพระราม4    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    
    # verify owner information
    Verify Owner Information    owner_name=ทดสอบ ทดสอบ    thai_id=1234567890123
    ...    mobile=66-610090735    true_money_wallet_no=0610095616
    ...    email=o2o.qatesting.second@gmail.com        date_of_birth=01/01/1999        
    ...    address=12345    province=Bangkok    district=Phra Nakhon    sub_district=Phra Borom Maha Ratchawang    post_code=10200
    
    # verify shops information
    Click Load More Shop Button
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 1    contact_name=Robot Automation Test
    ...    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 1    mobile=66-610095616
    ...    address=5555/111 สุขุมวิท    email=o2o.qatesting@gmail.com
    ...    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 2    contact_name=การทดสอบระบบอัตโนมัติของหุ่นยนต์
    ...    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 2    mobile=66-610090735
    ...    address=5555/111 สุขุมวิท    email=o2o.qatesting.second@gmail.com
    ...    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    ...    shop_order=2
    
    # verify fraud review
    Verify Fraud Review    dipchip=YES    revise_no=0
    ...    fraud_status=Waiting for Review    remark=${EMPTY}
    
    # verify documents
    Verify Brand And Shop Documents
        
    # change to Thai language
    Navigate To Main Menu And Sub Main Menu    Language    ไทย
    
    # verify brand information
    Verify Brand Information    brand_name_th=ร้านค้าทดสอบนะ    business_type=INDIVIDUAL
    ...    brand_name_en=${test_brand_name_en}    service_type=TrueMoney + Trueyou 
    ...    category=${SPACE}อาหารและเครื่องดื่ม${SPACE}    register_channel=App Agent
    ...    sub_category=${SPACE}ชาบู/สุกียากี้${SPACE}    settlement_type=WALLET
    ...    address=61/5 ตรอกขุนนาวา ถนนพระราม4    province=กรุงเทพมหานคร    district=บางรัก    sub_district=มหาพฤฒาราม    post_code=10500
    ...    lang=th
    
    # verify owner information
    Verify Owner Information    owner_name=ทดสอบ ทดสอบ    thai_id=1234567890123
    ...    mobile=66-610090735    true_money_wallet_no=0610095616
    ...    email=o2o.qatesting.second@gmail.com        date_of_birth=01/01/1999        
    ...    address=12345    province=กรุงเทพมหานคร    district=พระนคร    sub_district=พระบรมมหาราชวัง    post_code=10200
    ...    lang=th
    
    # verify shops information
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 1    contact_name=Robot Automation Test
    ...    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 1    mobile=66-610095616
    ...    address=5555/111 สุขุมวิท    email=o2o.qatesting@gmail.com
    ...    province=กรุงเทพมหานคร    district=บางรัก    sub_district=มหาพฤฒาราม    post_code=10500
    ...    lang=th
    
    Verify Shop Information    shop_name_th=ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 2    contact_name=การทดสอบระบบอัตโนมัติของหุ่นยนต์
    ...    shop_name_en=Robot Automation Test 29012020 @truedigital Branch 2    mobile=66-610090735
    ...    address=5555/111 สุขุมวิท    email=o2o.qatesting.second@gmail.com
    ...    province=กรุงเทพมหานคร    district=บางรัก    sub_district=มหาพฤฒาราม    post_code=10500
    ...    shop_order=2    lang=th

    # verify fraud review
    Verify Fraud Review    dipchip=YES    revise_no=0
    ...    fraud_status=Waiting for Review    remark=${EMPTY}
    ...    lang=th
    
    # verify documents
    Verify Brand And Shop Documents
    
TC_O2O_25426
    [Documentation]    [O2O Merchant Onboard - Tag39] Fraud admin can reject Brand Fraud Approval status on "Brand Fraud Approval" page
    [Tags]    Regression    E2E    High    o2o-admintools    o2o-merchant    cms
    Generate Robot Automation Header    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
    Get Search Brand Fraud    brandEn=${test_brand_name_en}&registerChannel=appagent&fraudStatus=WAITING_REVIEW&sort=createdDate,desc
    Fetch Property From Response    .brandId    TEST_DATA_BRAND_ID
    
    Clear Search Results
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    
    # update category & sub category
    Edit Brand Information    category=${SPACE}Entertainment${SPACE}    sub_category=${SPACE}Karaoke${SPACE}
    
    # verify Fraud Review - Fraud status dropdown list
    Verify Fraud Status Dropdown Items    Waiting for Review    Revise    Rejected    Passed
    
    # update status to Revise
    Edit Fraud Approval Status    Revise    remark=update status to REVISE
    Save Fraud Approval Information
    
    # access to the edit Fraud Approval page again
    Search Merchants    fraud_status=All
    Sort By Column    Modified Date/Time
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    
    # verify category, sub category, and status are updated
    Verify Brand Information    brand_name_th=ร้านค้าทดสอบนะ    business_type=INDIVIDUAL
    ...    brand_name_en=${test_brand_name_en}    service_type=TrueMoney + Trueyou 
    ...    category=${SPACE}Entertainment${SPACE}    register_channel=App Agent
    ...    sub_category=${SPACE}Karaoke${SPACE}    settlement_type=WALLET
    ...    address=61/5 ตรอกขุนนาวา ถนนพระราม4    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    Verify Fraud Review    dipchip=YES    revise_no=1
    ...    fraud_status=Revise    remark=update status to REVISE
    
    # verify Fraud Review - Fraud status dropdown list
    Verify Fraud Status Dropdown Items    Revise    Rejected    Passed
    
    # update category & sub category back to the original value
    Edit Brand Information    category=${SPACE}Food & Drink${SPACE}    sub_category=${SPACE}Shabu/Sukiyaki${SPACE}
    
    # change status to Rejected, then change status to Revise
    Edit Fraud Approval Status    Rejected    update status to REJECTED
    Edit Fraud Approval Status    Revise
    Verify Fraud Review    dipchip=YES    revise_no=1
    ...    fraud_status=Revise    remark=update status to REVISE
    
    # change status to Passed, then change status to Revise
    Edit Fraud Approval Status    Passed
    Edit Fraud Approval Status    Revise
    Verify Fraud Review    dipchip=YES    revise_no=1
    ...    fraud_status=Revise    remark=update status to REVISE
    
    # user revise information -> TO BE ADDED
    
    # update status to REVISE -> TO BE ADDED
    
    # user revise information -> TO BE ADDED
    
    # update status to Rejected or Passed
    Edit Fraud Approval Status    Rejected    update status to REJECTED
    Save Fraud Approval Information
    
    # access to the edit Fraud Approval page again
    Sort By Column    Modified Date/Time
    Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    
    # verify category, sub category, and status are updated
    Verify Brand Information    brand_name_th=ร้านค้าทดสอบนะ    business_type=INDIVIDUAL
    ...    brand_name_en=${test_brand_name_en}    service_type=TrueMoney + Trueyou 
    ...    category=${SPACE}Food & Drink${SPACE}    register_channel=App Agent
    ...    sub_category=${SPACE}Shabu/Sukiyaki${SPACE}    settlement_type=WALLET
    ...    address=61/5 ตรอกขุนนาวา ถนนพระราม4    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    Verify Fraud Review    dipchip=YES    revise_no=1
    ...    fraud_status=Rejected    remark=update status to REJECTED
    Verify User Is Not Allowed To Update Fraud Approval Status When Status Is Passed Or Rejected