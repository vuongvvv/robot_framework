*** Settings ***
Documentation    E2E tests for Merchant - Tag39 Epic
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/${ENV}/merchant/merchant_data.robot
Resource    ../../../keywords/merchant/category_resource_keywords.robot
Resource    ../../../keywords/merchant/sub_category_resource_keywords.robot
Resource    ../../../keywords/merchant/brand_resource_keywords.robot
Resource    ../../../keywords/merchant/shop_resource_keywords.robot
Resource    ../../../keywords/merchant/terminal_resource_keywords.robot
Resource    ../../../keywords/merchant/call_verification_resource_keywords.robot
Resource    ../../../keywords/merchant/document_resource_keywords.robot
Resource    ../../../keywords/merchant/file_resource_keywords.robot
Resource    ../../../keywords/merchant/fraud_resource_keywords.robot
Resource    ../../../keywords/cms/content_resource_keywords.robot

# scope: merchantv2.shopContractTmn.write,shop.write,terminal.write,file.write,kyb.document.write,shop.kyb.write,merchantv2.brand.read,merchantv2.brand.actAsAdmin,brand.kyb.write,merchantv2.category.read,merchantv2.subcategory.read
# permission: merchantv2.brand.read,merchantv2.brand.actAsAdmin,merchantv2.callver.write,merchantv2.brandFraud.actAsAdmin
Test Setup   Generate Robot Automation Header    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
${category_name_en}    Food & Drink
# /o2o-api-automation/api/resources/testdata/merchant/upload_files
${upload_brand_image}    jpeg_brand_image_logo.jpeg
${upload_brand_pdf}    brand.pdf
${upload_brand_image_logo}    jpeg_brand_image_logo.jpeg
${upload_shop_image}    jpeg_shop_image_logo.jpeg
${shop_image_store_front_1}    shop_image_store_front_1.jpeg
${shop_image_store_front_2}    shop_image_store_front_2.jpeg
${shop_image_store_front_3}    shop_image_store_front_3.jpeg
${shop_image_store_front_4}    shop_image_store_front_4.png
${shop_image_store_front_5}    shop_image_store_front_5.jpeg
${upload_shop_bank_passbook}    pdf_bank_passbook.pdf
${upload_brand_bank_passbook}    bank_passbook_pdf.pdf
${upload_owner_certificate}    jpeg_owner_certificate.jpeg

@{category_id_list}    ${1}    ${2}    ${3}    ${4}    ${5}    ${6}    ${11}
@{category_list_name_en}    Food & Drink    Shopping    Health & Wellness    Travel & Transportation    Entertainment    Education    Service
@{category_list_name_th}    อาหารและเครื่องดื่ม    ช้อปปิ้ง    สุขภาพและความงาม    ท่องเที่ยวและเดินทาง    บันเทิง    การศึกษา    บริการต่างๆ

*** Test Cases ***
TC_O2O_22845
    [Documentation]    [O2O Merchant Onboard - Tag39] TSM Onboarding flow - TrueMoney Only
    [Tags]    E2E    o2o-merchant    cms
    Get Search Category
    Response Property Should Be Equal To List    .categoryId    ${category_id_list}
    Response Property Should Be Equal To List    .categoryNameTh    ${category_list_name_th}
    Response Property Should Be Equal To List    .categoryNameEn    ${category_list_name_en}
    
    Fetch Category Id From Name    ${category_name_en}
    Get Search Sub Category
    Fetch Sub Category Id From Category Id    ${TEST_DATA_CATEGORY_ID}
    # create brand
    Post Create Brand    { "brandName": { "th": "ทดสอบ แบรนด์กรู๊ท_ส้ม", "en": "robot automation test", "default": "th" }, "description": "robot automation test ร้านทดสอบ", "category": "${TEST_DATA_CATEGORY_ID}", "subCategory": "${TEST_DATA_SUB_CATEGORY_ID}" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Brand Mongo Id
    Fetch Brand Id Test Data
    
    # create shop
    Post Create Shop    ${TEST_DATA_BRAND_MONGO_ID}    { "shopAddresses": { "address": "5555/111 สุขุมวิท", "city": "BKK", "country": "TH", "district": "Bangna", "geolocation": "13.6601781,100.6254328", "postcode": "10500", "districtId": "4", "subDistrictId": "28", "provinceId": "1" }, "shopCategories": [ "FOOD", "SERVICE" ], "shopContacts": [ { "email": "o2o.qatesting@gmail.com", "fullName": "Robot Automation Test", "phone": "66-610095616" } ], "shopDetails": { "description": "test", "openHours": { "sun": "08:00-19:00", "mon": "", "tue": "08:00-19:00", "wed": "08:00-19:00", "thu": "08:00-19:00", "fri": "08:00-19:00", "sat": "08:00-19:00" } }, "shopName": { "default": "th", "en": "Robot Automation Test 29012020 @truedigital Branch 1", "th": "ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 1" }, "status": "ACTIVE", "shopType": [ "OFFLINE", "ONLINE" ] }
    Extract And Store Shop Mongo Id From Response
    Response Correct Code    ${CREATED_CODE}
    Response Property Should Be Equal As String    brandRefId    ${TEST_DATA_BRAND_MONGO_ID}
    Response Property Should Be Equal As String    status    ACTIVE

    # create terminal
    Post Create Terminal    ${SHOP_MONGO_ID}    { "terminalName": { "th": "ชื่อเทอมินอลทดสอบ", "en": "robot automation test", "default": "en" }, "terminalType": "QR", "description": "Robot Automation Test ทดสอบ&Test", "status": "INACTIVE" }
    Response Correct Code    ${CREATED_CODE}
    Response Property Should Be Equal As String     status    INACTIVE
    
    # create brand truemoney
    Post Brand Kyb With Provider    ${TEST_DATA_BRAND_MONGO_ID}    truemoney    { "operatorEmail": "o2o.qatesting@gmail.com", "businessType": "INDIVIDUAL", "isVat20Registration": "true", "taxId": "000000000009", "merchantDetailContactEmail": "o2o.qatesting@gmail.com", "merchantDetailContactPhoneNumber": "66-610095616", "merchantDetailContactAddress": "1223", "merchantDetailContactAddressSubDistrictId": "1", "merchantDetailContactAddressDistrictId": "1", "merchantDetailContactAddressProvinceId": "1", "merchantDetailContactAddressPostcode": "10200", "merchantDetailMerchantOfficialNameThai": "ร้านค้าทดสอบนะ", "merchantDetailMerchantOfficialNameEnglish": "TrueYou And TrueMoney Test", "bankDetailAccountType": "SAVING", "bankDetailBankAccountName": "ทดสอบบัญชี", "bankDetailBankAccountNumber": "1234567890", "bankDetailBankCode": "SCB", "businessOwnerDetailBirthDate": "19990101", "businessOwnerDetailGender": "MALE", "businessOwnerDetailIdentificationType": "THAI_ID", "businessOwnerDetailIdentificationNumber": "1234567890123", "businessOwnerDetailJcNumber": "JC1234567890", "businessOwnerDetailOccupation": "0001", "businessOwnerDetailOwnerFirstName": "ทดสอบ", "businessOwnerDetailOwnerLastName": "ทดสอบ", "businessOwnerDetailCurrentAddress": "12345", "businessOwnerDetailCurrentAddressSubDistrictId": "1", "businessOwnerDetailCurrentAddressDistrictId": "1", "businessOwnerDetailCurrentAddressProvinceId": "1", "businessOwnerDetailCurrentAddressPostcode": "10200", "companyDetailBranchName": "branch test", "companyDetailBranchType": "HEADQUARTER", "companyDetailCommercialRegisteredNameThai": "ทดสอบร้านค้า", "companyDetailCommercialRegisteredNameEnglish": "branch test", "companyDetailCommercialRegistrationNumber": "000000000009", "companyDetailCompanyEmail": "o2o.qatesting@gmail.com", "companyDetailCompanyPhone": "66-610095616", "companyDetailRepresentativeFirstName": "เจ้าของนะ", "companyDetailRepresentativeLastName": "นามสกุลเจ้าของ", "isAllowClarifyWithHoldingTax": "true", "merchantAttributeLocation": "13.021450,77.538360", "walletAccountNumber": "66-610095616", "settlementType": "wallet", "registerChannel": "appagent", "dipchip": "yes", "businessOwnerDetailContactMobilePhoneNumber": "66-610090735", "businessOwnerDetailContactEmail": "o2o.qatesting.second@gmail.com" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Content Id    BRAND_TRUEMONEY
    Response Property Should Be Equal As String     status    DRAFT
    Response Property Should Be Equal As String     provider    TRUEMONEY
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${TEST_DATA_BRAND_TRUEMONEY_CONTENT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    data.categoryId    ${TEST_DATA_CATEGORY_ID}
    Response Property Should Be Equal As String    data.mccCode    ${TEST_DATA_SUB_CATEGORY_ID}
    Response Property Should Be Equal As String    data.status    DRAFT
    Response Property Should Be Equal As String    data.refId    ${TEST_DATA_BRAND_MONGO_ID}
    Response Property Should Be Equal As String    data.businessOwnerDetailContactMobilePhoneNumber    66-610090735
    Response Property Should Be Equal As String    data.businessOwnerDetailContactEmail    o2o.qatesting.second@gmail.com
    # verify fraud-resource - /api/frauds/brand/{brandId}
    Get Brand Fraud Detail    ${TEST_DATA_BRAND_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    brandOwnerMobile    66-610090735
    Response Property Should Be Equal As String    brandOwnerEmail    o2o.qatesting.second@gmail.com

    # create brand trueyou
    Post Brand Kyb With Provider    ${TEST_DATA_BRAND_MONGO_ID}    trueyou    { "channel": "appretail", "brandNameTh": "ร้านส้มเองค่ะ01", "brandNameEn": "SomStroe01", "brandDescription": "brandDescription", "brandRequest": "11", "brandSpec": "Online", "brandAddress": "61/5 ตรอกขุนนาวา", "brandAddressRoad": "พระราม4", "brandAddressProvinceId": "1", "brandAddressDistrictId": "1", "brandAddressSubdistrictId": "1", "brandAddressPostcode": "10200", "brandAddressCountry": "Thailand", "brandTelephone": "66-610095616", "brandTelephone2": "66-610095616", "brandAddressLatitude": "13.888", "brandAddressLongitude": "100.898", "contactTitle": "นางสาว", "contactName": "ชุดาภา", "contactLastname": "มูลสูงเนิน", "contactTelephone": "66-610095616", "contactEmail": "o2o.qatesting@gmail.com", "privilegeTrueOffer": "เมื่อสั่งครบ 150 แถมเป็ปซี่ 1 ขวด 600 ml | ลด 1%", "privilegeTrueTerm": "สำหรับลูกค้าทรู 2 ปี", "privilegeRedFlag": "0", "pointOfPurchaseAddress": "61/5 ตรอกขุนนาวา", "pointOfPurchaseAddressRoad": "พระราม4", "pointOfPurchaseAddressDistrictId": "4", "pointOfPurchaseAddressSubdistrictId": "28", "pointOfPurchaseAddressProvinceId": "1", "pointOfPurchaseAddressPostcode": "10500", "shopAddress": "61/5 ตรอกขุนนาวา", "shopAddressRoad": "พระราม4", "shopAddressProvinceId": "1", "shopAddressDistrictId": "1", "shopAddressSubdistrictId": "1", "shopAddressPostcode": "10200" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Content Id    BRAND_TRUEYOU
    Response Property Should Be Equal As String     status    DRAFT
    Response Property Should Be Equal As String     provider    TRUEYOU
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${TEST_DATA_BRAND_TRUEYOU_CONTENT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    data.brandType    ${TEST_DATA_CATEGORY_ID}
    Response Property Should Be Equal As String    data.brandSubType    ${TEST_DATA_SUB_CATEGORY_ID}
    Response Property Should Be Equal As String    data.status    DRAFT
    Response Property Should Be Equal As String    data.refId    ${TEST_DATA_BRAND_MONGO_ID}
    
    # create shop TrueMoney
    Post Shop Kyb With Provider    ${SHOP_MONGO_ID}    truemoney    { "englishName": "Robot Automation Test TrueMoney Shop", "thaiName": "ส้มตำ เจ้แดง", "registerEnglishName": "Robot Automation Co., Ltd.", "registerThaiName": "ส้มตำ เจ้แดง จำกัด", "locationInfoLongitude": "100.5660648", "locationInfoLatitude": "13.7644702", "description": "อร่อยนะจะบอกให้", "branchName": "สามย่าน", "businessType": "INDIVIDUAL", "contactEmail": "o2o.qatesting@gmail.com", "contactPhone": "66-610095616", "contactAddressAddress": "13/45 จุฬาซอย สาม", "contactAddressDistrictId": "4", "contactAddressSubDistrictId": "28", "contactAddressProvinceId": "1", "contactAddressPostcode": "10500", "shopLocationAddressAddress": "13/45 จุฬาซอย สาม", "shopLocationAddressDistrictId": "4", "shopLocationAddressSubDistrictId": "28", "shopLocationAddressProvinceId": "1", "shopLocationAddressPostcode": "10500", "billingAddressAddress": "13/45 จุฬาซอย สาม", "billingAddressDistrictId": "4", "billingAddressSubDistrictId": "28", "billingAddressProvinceId": "1", "billingAddressPostcode": "10500", "taxId": "1101400000111", "accountType": "SAVING", "bankAccountNumber": "1174200780", "bankAccountName": "robot automation", "bankCode": "SCB", "walletAccountName": "robot automation", "walletAccountNumber": "66-610095616" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Content Id    SHOP_TRUEMONEY
    Response Property Should Be Equal As String     status    DRAFT
    Response Property Should Be Equal As String     provider    TRUEMONEY
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${TEST_DATA_SHOP_TRUEMONEY_CONTENT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    data.status    DRAFT
    Response Property Should Be Equal As String    data.refId    ${SHOP_MONGO_ID}
    
    # create shop TrueYou
    Post Shop Kyb With Provider    ${SHOP_MONGO_ID}    trueyou    { "channel": "appagent", "shopNameTh": "ร้านส้มเองค่ะ01", "shopNameEn": "robotAutomationTest", "shopBrandTypeId": "1", "shopArea": "AAA", "shopAddress": "61/5 ตรอกขุนนาวา", "shopAddress2": "พระราม4", "shopProvinceId": "1", "shopDistrictId": "30", "shopSubDistrictId": "182", "shopZipcode": "10900", "shopTelephone": "66-610095616", "shopTelephone2": "66-610095616", "shopTax": "1234567890123", "shopMapLatitude": "13.7237433", "shopMapLongitude": "100.5183629", "shopLinkWebSite": "https://www.wemall.com/", "shopLinkFacebook": "https://www.facebook.com/WeMall/", "shopLinkInstagram": "https://www.instagram.com/wemall_official/", "shopContactPersonFullName": "Robot Automation", "shopContactPersonTell": "66-610095616", "shopContactPersonEmail": "o2o.qatesting@gmail.com", "shopHeadquater": "1" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Content Id    SHOP_TRUEYOU
    Response Property Should Be Equal As String     status    DRAFT
    Response Property Should Be Equal As String     provider    TRUEYOU
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${TEST_DATA_SHOP_TRUEYOU_CONTENT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    data.status    DRAFT
    Response Property Should Be Equal As String    data.refId    ${SHOP_MONGO_ID}
    
    # create shop constract TrueMoney
    Post Request Create Shop Contract TrueMoney    ${SHOP_MONGO_ID}    { "contractBasicProductCode": "51051000100000000023", "contractBasicContractName": "GN Online Auto Debit - 010000000011739551769", "contractBasicSignedTime": "2020-03-10T22:44:55+07:00", "contractBasicEffectTime": "2020-03-20T06:44:55+07:00", "contractBasicExpiryTime": "2020-03-20T06:44:55+07:00", "contractBasicExpiryType": "NOTIFY", "contractBasicLastModifier": "o2o.qatesting@gmail.com", "contractBasicContractStatus": "DRAFT", "contractBasicEffectType": "IMMEDIATE", "contractBasicMemo": "test cha", "contractBasicProjectCode": "TRUEYOU", "contractBasicTmnSettlement": true, "productConditionCutoffTime": "0030", "productConditionSettlementTime": "0229", "productConditionSettleCurrency": "THB", "productConditionOrderMode": "API", "productConditionProductMode": "DIRECTPAY", "productConditionAcquiringMode": "DIRECTPAY", "productConditionStagePaymentType": "PAYMENT_IN_FULL", "productConditionSettleStrategy": "BY_TIME_CYCLE", "productConditionSettleCycle": "T+2", "productConditionSettleAccountType": "WALLET", "productConditionSettleActorType": "SHOP", "productConditionSettleAmountThresholdCurrency": "THB", "productConditionSettleAmountThresholdValue": "10", "productConditionCardIndexNo": "12345678", "productConditionTaxRefCode": "TH", "productConditionFeeItemsFeeCalcBasis": "TRADING_AMOUNT", "productConditionFeeItemsChargeTarget": "RECEIVER", "productConditionFeeItemsFeeCalcMethod": "FULL_CALCULATION", "productConditionFeeItemsFeeSettleMode": "REALTIME", "productConditionFeeItemsChargeMode": "INNER_DEDUCT", "productConditionFeeItemsChargeCurrency": "THB", "productConditionFeeItemsPaymentOffset": true, "productConditionFeeItemsPayMethodFeeInfosFixedFeeAmountCurrency": "THB", "productConditionFeeItemsPayMethodFeeInfosFixedFeeAmountValue": "0", "productConditionFeeItemsPayMethodFeeInfosPayMethods": "BALANCE", "productConditionFeeItemsPayMethodFeeInfosFeeRate": "1", "productConditionFeeItemsPayMethodFeeInfosMinPaymentAmount": "1", "productConditionFeeItemsPayMethodFeeInfosMaxPaymentAmount": "6000", "productConditionFeeItemsPayMethodFeeInfosOmiseMerchantCode": "RETAIL", "productConditionFeeItemsPayMethodFeeInfosRefundConditionSupportRefund": true, "productConditionFeeItemsPayMethodFeeInfosRefundConditionSupportPartialRefund": true, "productConditionFeeItemsPayMethodFeeInfosRefundConditionRefundExpiryTime": "365", "productConditionFeeItemsPayMethodFeeInfosRefundConditionRefundCurrency": "THB", "productConditionFeeItemsPayMethodFeeInfosRefundConditionRefundFee": true, "productConditionFeeItemsPayMethodFeeInfosCancelConditionSupportCancel": true }
    Response Correct Code    ${CREATED_CODE}
    Fetch Content Id    SHOP_CONTRACT_TRUEMONEY
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-contract-truemoney    ${TEST_DATA_SHOP_CONTRACT_TRUEMONEY_CONTENT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    data.status    ONBOARD_IN_PROGRESS
    Response Property Should Be Equal As String    data.refId    ${SHOP_MONGO_ID}
    
    # create brand call verification
    Post Save Brand Call Verification By Refid    ${TEST_DATA_BRAND_MONGO_ID}    { "deviceType": [ "QR39" ], "provider": "TMN_TY", "businessType": "INDIVIDUAL", "firstName": "robot", "lastName": "automation", "birthDate": "19900418", "brandContactEmail": "o2o.qatesting@gmail.com", "brandContactPhone": "66-610095616", "brandAddress": "61/5 ตรอกขุนนาวา ถนนพระราม4", "brandSubDistrictId": "28", "brandDistrictId": "4", "brandProvinceId": "1", "brandPostCode": "10500", "startDatePrivilege": "2020-05-11T17:37:15.222Z", "endDatePrivilege": "2021-05-11T17:37:15.222Z", "trueCardPrivilege": "8881518883597131", "redCardPrivilege": "8881518883597131", "blackCardPrivilege": "8891578890779082", "registerChannel": "appretail", "saleId": "gg" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Content Id    BRAND_CALL_VERIFICATION
    Response Property Should Be Equal As String     callVerStatus    DRAFT
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-callverification    ${TEST_DATA_BRAND_CALL_VERIFICATION_CONTENT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    data.category    ${TEST_DATA_CATEGORY_ID}
    Response Property Should Be Equal As String    data.subCategory    ${TEST_DATA_SUB_CATEGORY_ID}
    Response Property Should Be Equal As String    data.callVerStatus    DRAFT
    Response Property Should Be Equal As String    data.refId    ${TEST_DATA_BRAND_MONGO_ID}
    
    # create shop callverfication
    Post Save Shop Call Verification By Refid    ${SHOP_MONGO_ID}    { "deviceType": [ "QR39" ], "provider": "TMN_TY", "businessType": "INDIVIDUAL", "walletAccountNumber": "66-610095616", "shopAddress": " 5555/111 สุขุมวิท", "shopSubDistrictId": "28", "shopDistrictId": "4", "shopProvinceId": "1", "shopPostCode": "10500", "registerChannel": "appretail", "saleId": "555" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Content Id    SHOP_CALL_VERIFICATION
    Response Property Should Be Equal As String     callVerStatus    DRAFT
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-callverification    ${TEST_DATA_SHOP_CALL_VERIFICATION_CONTENT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    data.callVerStatus    DRAFT
    Response Property Should Be Equal As String    data.refId    ${SHOP_MONGO_ID}
    
    # save private file to brand truemoney
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    OWNER_IMAGE    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${upload_brand_image}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String     status    DRAFT
    Fetch Content Id    BRAND_TRUEMONEY
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${TEST_DATA_BRAND_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.documentOwnerImage.dataContentType    image/jpeg
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    OWNER_CERTIFICATE    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${upload_owner_certificate}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    BANK_PASSBOOK    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${upload_brand_bank_passbook}
    Response Correct Code    ${SUCCESS_CODE}

    # save private file to brand trueyou
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    RENTAL_CONTRACT    BRAND
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${upload_brand_pdf}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String     status    DRAFT
    Fetch Content Id    BRAND_TRUEYOU
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${TEST_DATA_BRAND_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.documentRentalContract.dataContentType    application/pdf
    
    # save public file to brand provider 
    Post Upload File    ${TEST_DATA_BRAND_MONGO_ID}    BRAND_IMAGE_LOGO    ${upload_brand_image_logo}
    Response Correct Code    ${CREATED_CODE}
    Response Property Should Be Equal As String    refId    ${TEST_DATA_BRAND_MONGO_ID}
    Fetch Content Id    BRAND_PROVIDER

    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-image    ${TEST_DATA_BRAND_PROVIDER_CONTENT_ID}
    Response Property Should Be Equal As String    data.image.dataContentType    image/jpeg
    Response Property Should Be Equal As String    data.image.type    PUBLIC_FILE
    Response Property Should Be Equal As String    data.refId    ${TEST_DATA_BRAND_MONGO_ID}
    Response Property Should Be Equal As String    data.fileType    BRAND_IMAGE_LOGO
    Response Property Should Be Equal As String    contentType.name    brand-image
    Response Property Should Be Equal As String    contentType.alias    brand-image
    
    # save private file to shop provider - TrueMoney
    Generate Content To Upload    ${SHOP_MONGO_ID}    OWNER_IMAGE    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${upload_shop_image}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String     status    DRAFT
    Fetch Content Id    SHOP_TRUEMONEY
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${TEST_DATA_SHOP_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.documentOwnerImage.dataContentType    image/jpeg
    
    # save private file to shop provider - TrueYou
    Generate Content To Upload    ${SHOP_MONGO_ID}    BANK_PASSBOOK    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${upload_shop_bank_passbook}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String     status    DRAFT
    Fetch Content Id    SHOP_TRUEYOU
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${TEST_DATA_SHOP_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.documentBankPassbook.dataContentType    application/pdf
    
    # save public file to shop provider
    # ASCO2O-24137: [Improvement] Brand Fraud Approval Detail page - to show all shop images instead of 1 image
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_STORE_FRONT    ${shop_image_store_front_1}
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_STORE_FRONT    ${shop_image_store_front_2}
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_STORE_FRONT    ${shop_image_store_front_3}
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_STORE_FRONT    ${shop_image_store_front_4}
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_STORE_FRONT    ${shop_image_store_front_5}
    Response Correct Code    ${CREATED_CODE}
    Response Property Should Be Equal As String    refId    ${SHOP_MONGO_ID}
    Fetch Content Id    SHOP_PROVIDER
    # check content on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-image    ${TEST_DATA_SHOP_PROVIDER_CONTENT_ID}
    Response Property Should Be Equal As String    data.image.dataContentType    image/jpeg
    Response Property Should Be Equal As String    data.image.type    PUBLIC_FILE
    Response Property Should Be Equal As String    data.refId    ${SHOP_MONGO_ID}
    Response Property Should Be Equal As String    data.fileType    SHOP_IMAGE_STORE_FRONT
    Response Property Should Be Equal As String    contentType.name    shop-image
    Response Property Should Be Equal As String    contentType.alias    shop-image
    
    # create second shop in the same brand
    Post Create Shop    ${TEST_DATA_BRAND_MONGO_ID}    { "shopAddresses": { "address": "5555/111 สุขุมวิท", "city": "BKK", "country": "TH", "district": "Bangna", "geolocation": "13.6601781,100.6254328", "postcode": "10500", "districtId": "4", "subDistrictId": "28", "provinceId": "1" }, "shopCategories": [ "FOOD", "SERVICE" ], "shopContacts": [ { "email": "o2o.qatesting.second@gmail.com", "fullName": "การทดสอบระบบอัตโนมัติของหุ่นยนต์", "phone": "66-610090735" } ], "shopDetails": { "description": "test", "openHours": { "sun": "08:00-19:00", "mon": "", "tue": "08:00-19:00", "wed": "08:00-19:00", "thu": "08:00-19:00", "fri": "08:00-19:00", "sat": "08:00-19:00" } }, "shopName": { "default": "th", "en": "Robot Automation Test 29012020 @truedigital Branch 2", "th": "ชื่อร้านกรู๊ท ทดสอบ 29012020 @ตึกทรู สาขาที่ 2" }, "status": "ACTIVE", "shopType": [ "OFFLINE" ] }
    Extract And Store Shop Mongo Id From Response
    Response Correct Code    ${CREATED_CODE}
    Response Property Should Be Equal As String    brandRefId    ${TEST_DATA_BRAND_MONGO_ID}
    Response Property Should Be Equal As String    status    ACTIVE
    # create terminal
    Post Create Terminal    ${SHOP_MONGO_ID}    { "terminalName": { "th": "ชื่อเทอมินอลทดสอบ", "en": "robot automation test", "default": "en" }, "terminalType": "QR", "description": "Robot Automation Test ทดสอบ&Test", "status": "INACTIVE" }
    Response Correct Code    ${CREATED_CODE}
    # create shop TrueMoney
    Post Shop Kyb With Provider    ${SHOP_MONGO_ID}    truemoney    { "englishName": "Robot Automation Test TrueMoney Shop", "thaiName": "ส้มตำ เจ้แดง", "registerEnglishName": "Robot Automation Co., Ltd.", "registerThaiName": "ส้มตำ เจ้แดง จำกัด", "locationInfoLongitude": "100.5660648", "locationInfoLatitude": "13.7644702", "description": "อร่อยนะจะบอกให้", "branchName": "สามย่าน", "businessType": "INDIVIDUAL", "contactEmail": "o2o.qatesting@gmail.com", "contactPhone": "66-610095616", "contactAddressAddress": "13/45 จุฬาซอย สาม", "contactAddressDistrictId": "4", "contactAddressSubDistrictId": "28", "contactAddressProvinceId": "1", "contactAddressPostcode": "10500", "shopLocationAddressAddress": "13/45 จุฬาซอย สาม", "shopLocationAddressDistrictId": "4", "shopLocationAddressSubDistrictId": "28", "shopLocationAddressProvinceId": "1", "shopLocationAddressPostcode": "10500", "billingAddressAddress": "13/45 จุฬาซอย สาม", "billingAddressDistrictId": "4", "billingAddressSubDistrictId": "28", "billingAddressProvinceId": "1", "billingAddressPostcode": "10500", "taxId": "1101400000111", "accountType": "SAVING", "bankAccountNumber": "1174200780", "bankAccountName": "robot automation", "bankCode": "SCB", "walletAccountName": "robot automation", "walletAccountNumber": "66-610095616" }
    Response Correct Code    ${CREATED_CODE}
    # create shop TrueYou
    Post Shop Kyb With Provider    ${SHOP_MONGO_ID}    trueyou    { "channel": "appagent", "shopNameTh": "ร้านส้มเองค่ะ01", "shopNameEn": "robotAutomationTest", "shopBrandTypeId": "1", "shopArea": "AAA", "shopAddress": "61/5 ตรอกขุนนาวา", "shopAddress2": "พระราม4", "shopProvinceId": "1", "shopDistrictId": "30", "shopSubDistrictId": "182", "shopZipcode": "10900", "shopTelephone": "66-610095616", "shopTelephone2": "66-610095616", "shopTax": "1234567890123", "shopMapLatitude": "13.7237433", "shopMapLongitude": "100.5183629", "shopLinkWebSite": "https://www.wemall.com/", "shopLinkFacebook": "https://www.facebook.com/WeMall/", "shopLinkInstagram": "https://www.instagram.com/wemall_official/", "shopContactPersonFullName": "Robot Automation", "shopContactPersonTell": "66-610095616", "shopContactPersonEmail": "o2o.qatesting@gmail.com", "shopHeadquater": "1" }
    Response Correct Code    ${CREATED_CODE}
    # create shop constract TrueMoney
    Post Request Create Shop Contract TrueMoney    ${SHOP_MONGO_ID}    { "contractBasicProductCode": "51051000100000000023", "contractBasicContractName": "GN Online Auto Debit - 010000000011739551769", "contractBasicSignedTime": "2020-03-10T22:44:55+07:00", "contractBasicEffectTime": "2020-03-20T06:44:55+07:00", "contractBasicExpiryTime": "2020-03-20T06:44:55+07:00", "contractBasicExpiryType": "NOTIFY", "contractBasicLastModifier": "o2o.qatesting@gmail.com", "contractBasicContractStatus": "DRAFT", "contractBasicEffectType": "IMMEDIATE", "contractBasicMemo": "test cha", "contractBasicProjectCode": "TRUEYOU", "contractBasicTmnSettlement": true, "productConditionCutoffTime": "0030", "productConditionSettlementTime": "0229", "productConditionSettleCurrency": "THB", "productConditionOrderMode": "API", "productConditionProductMode": "DIRECTPAY", "productConditionAcquiringMode": "DIRECTPAY", "productConditionStagePaymentType": "PAYMENT_IN_FULL", "productConditionSettleStrategy": "BY_TIME_CYCLE", "productConditionSettleCycle": "T+2", "productConditionSettleAccountType": "WALLET", "productConditionSettleActorType": "SHOP", "productConditionSettleAmountThresholdCurrency": "THB", "productConditionSettleAmountThresholdValue": "10", "productConditionCardIndexNo": "12345678", "productConditionTaxRefCode": "TH", "productConditionFeeItemsFeeCalcBasis": "TRADING_AMOUNT", "productConditionFeeItemsChargeTarget": "RECEIVER", "productConditionFeeItemsFeeCalcMethod": "FULL_CALCULATION", "productConditionFeeItemsFeeSettleMode": "REALTIME", "productConditionFeeItemsChargeMode": "INNER_DEDUCT", "productConditionFeeItemsChargeCurrency": "THB", "productConditionFeeItemsPaymentOffset": true, "productConditionFeeItemsPayMethodFeeInfosFixedFeeAmountCurrency": "THB", "productConditionFeeItemsPayMethodFeeInfosFixedFeeAmountValue": "0", "productConditionFeeItemsPayMethodFeeInfosPayMethods": "BALANCE", "productConditionFeeItemsPayMethodFeeInfosFeeRate": "1", "productConditionFeeItemsPayMethodFeeInfosMinPaymentAmount": "1", "productConditionFeeItemsPayMethodFeeInfosMaxPaymentAmount": "6000", "productConditionFeeItemsPayMethodFeeInfosOmiseMerchantCode": "RETAIL", "productConditionFeeItemsPayMethodFeeInfosRefundConditionSupportRefund": true, "productConditionFeeItemsPayMethodFeeInfosRefundConditionSupportPartialRefund": true, "productConditionFeeItemsPayMethodFeeInfosRefundConditionRefundExpiryTime": "365", "productConditionFeeItemsPayMethodFeeInfosRefundConditionRefundCurrency": "THB", "productConditionFeeItemsPayMethodFeeInfosRefundConditionRefundFee": true, "productConditionFeeItemsPayMethodFeeInfosCancelConditionSupportCancel": true }
    Response Correct Code    ${CREATED_CODE}
    # create shop callverfication
    Post Save Shop Call Verification By Refid    ${SHOP_MONGO_ID}    { "deviceType": [ "QR39" ], "provider": "TMN_TY", "businessType": "INDIVIDUAL", "walletAccountNumber": "66-610095616", "shopAddress": " 5555/111 สุขุมวิท", "shopSubDistrictId": "28", "shopDistrictId": "4", "shopProvinceId": "1", "shopPostCode": "10500", "registerChannel": "appretail", "saleId": "555" }
    Response Correct Code    ${CREATED_CODE}
    # save private file to shop provider - TrueMoney
    Generate Content To Upload    ${SHOP_MONGO_ID}    OWNER_IMAGE    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${upload_shop_image}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String     status    DRAFT
    # save private file to shop provider - TrueYou
    Generate Content To Upload    ${SHOP_MONGO_ID}    BANK_PASSBOOK    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${upload_shop_bank_passbook}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String     status    DRAFT
    # save public file to shop provider
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_STORE_FRONT    ${upload_shop_image}
    Response Correct Code    ${CREATED_CODE}
    Response Property Should Be Equal As String    refId    ${SHOP_MONGO_ID}

    # update brand callver status to WAITING_REVIEW
    Put Update Brand Call Verification By Refid    ${TEST_DATA_BRAND_MONGO_ID}    { "callVerStatus": "WAITING_REVIEW" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    callVerStatus    WAITING_REVIEW
    # verify brand callver status on CMS
    Wait Data To Sync On Cms    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${TEST_DATA_SHOP_TRUEYOU_CONTENT_ID}    data.status    CALLVER_REVIEW
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-callverification    ${TEST_DATA_BRAND_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    WAITING_REVIEW
    # verify brand truemoney status on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${TEST_DATA_BRAND_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    CALLVER_REVIEW
    # verify brand trueyou status on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${TEST_DATA_BRAND_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    CALLVER_REVIEW
    # verify shop callver status on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-callverification    ${TEST_DATA_SHOP_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    WAITING_REVIEW
    # verify shop truemoney status on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${TEST_DATA_SHOP_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    CALLVER_REVIEW
    # verify shop trueyou status on CMS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${TEST_DATA_SHOP_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    CALLVER_REVIEW
