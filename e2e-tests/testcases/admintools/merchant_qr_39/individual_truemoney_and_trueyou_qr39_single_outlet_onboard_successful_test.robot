*** Settings ***
Documentation    E2E tests for Merchant - Tag39 Epic
...    ASCO2O-23377: #39 Onboarding - TMN Merchant Operation Status
...    https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1731395799/Receiving+updates+from+TrueMoney+to+ASC+Merchant+Platform

Resource    ../../../../api/resources/init.robot
Resource    ../../../../api/resources/testdata/${ENV}/merchant/merchant_data.robot
Resource    ../../../../api/keywords/merchant/category_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/sub_category_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/brand_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/shop_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/terminal_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/call_verification_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/document_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/file_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/fraud_resource_keywords.robot
Resource    ../../../../api/keywords/cms/content_resource_keywords.robot
Resource    ../../../../api/keywords/rpp_merchant/terminal_v2_resource_keywords.robot

Resource    ../../../../web/resources/init.robot
Resource    ../../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../../web/keywords/admintools/common/common_keywords.robot
Resource    ../../../../web/keywords/admintools/call_verification_qr_39/brand_call_verification_keywords.robot
Resource    ../../../../web/keywords/admintools/fraud_approval/fraud_admin_approval_keywords.robot
Resource    ../../../../web/resources/testdata/alpha/true_you_deal_management/true_you_deal_management_testdata.robot
Resource    ../../../../web/keywords/deal_management/common/common_keywords.robot
Resource    ../../../../web/keywords/deal_management/partner_requests/partner_requests_detail_keywords.robot

Resource    ../../../../web/resources/testdata/alpha/truemoney_admin_portal/truemoney_admin_portal_testdata.robot
Resource    ../../../../web/keywords/truemoney_admin_portal/common/truemoney_admin_portal_common_keywords.robot
Resource    ../../../../web/keywords/truemoney_admin_portal/merchant_management/merchant_profile_keywords.robot
Resource    ../../../../web/keywords/truemoney_admin_portal/merchant_management/shop_profile_keywords.robot
Resource    ../../../../web/keywords/truemoney_admin_portal/merchant_management/shop_contract_approval_list_keywords.robot

# scope: merchantv2.shopContractTmn.write,shop.write,terminal.write,file.write,kyb.document.write,shop.kyb.write,merchantv2.brand.read,merchantv2.brand.actAsAdmin,brand.kyb.write,merchantv2.category.read,merchantv2.subcategory.read
# permission: merchantv2.brand.read,merchantv2.brand.actAsAdmin,merchantv2.callver.write,merchantv2.brandFraud.actAsAdmin
Test Setup    Run Keywords    Open Browser With Option    ${ADMIN_TOOLS_URL}
...    AND    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
...    AND    Generate Robot Automation Header    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
Test teardown    Run Keywords    Switch To Non Angular JS Site
...    AND    Open Browser With Option    ${TRUE_MONEY_ADMIN_PORTAL_URL}
...    AND    Login TrueMoney Admin Portal    ${TRUE_MONEY_ADMIN_PORTAL_USERNAME}    ${TRUE_MONEY_ADMIN_PORTAL_PASSWORD}
...    AND    Remove TrueMoney Account    ${TRUEMONEY_BRAND_ID}    ${TRUEMONEY_SHOP_ID}
...    AND    Update TrueMoney Merchant Operation Status    ${TRUEMONEY_BRAND_ID}    UNCERTIFICATED
...    AND    Update TrueMoney Merchant Operation Status    ${TRUEMONEY_BRAND_ID}    PENDING
...    AND    Update TrueMoney Merchant Operation Status    ${TRUEMONEY_BRAND_ID}    CERTIFICATED_FAILED
...    AND    Switch To Angular JS Site
...    AND    Clean Environment
...    AND    Delete All Sessions

*** Variables ***
${category_name_en}    Food & Drink
# /o2o-api-automation/api/resources/testdata/merchant/upload_files
${jpeg_owner_image}    jpeg_owner_image.jpeg
${jpeg_owner_certificate}    jpeg_owner_certificate.jpeg
${png_vat_registration}    png_vat_registration.png
${pdf_bank_passbook}    pdf_bank_passbook.pdf
${jpeg_household_registration}    jpeg_household_registration.jpeg
${jpeg_company_registration}    jpeg_company_registration.jpeg
${jpeg_rental_contract}    jpeg_rental_contract.jpeg
${jpeg_other}    jpeg_other.jpeg

${jpeg_brand_image_logo}    jpeg_brand_image_logo.jpeg
${jpeg_brand_image_store_front}    jpeg_brand_image_store_front.jpeg
${png_brand_image_menu}    png_brand_image_menu.png
${jpeg_brand_image_map}    jpeg_brand_image_map.jpeg
${jpeg_brand_image_other}    jpeg_brand_image_other.jpeg

${jpeg_shop_image_logo}    jpeg_shop_image_logo.jpeg
${jpeg_shop_image_store_front}    jpeg_shop_image_store_front.jpeg
${png_shop_image_menu}    png_shop_image_menu.png
${jpeg_shop_image_map}    jpeg_shop_image_map.jpeg
${jpeg_shop_image_other}    jpeg_shop_image_other.jpeg

*** Test Cases ***
TC_O2O_24620
    [Documentation]    [O2O Merchant Onboard - Tag39] Fraud admin can update Category, Sub Category, Brand Fraud Approval status on "Brand Fraud Approval" page
    [Tags]    E2EExclude    o2o-merchant    cms    trueyou    truemoney    rpp-merchant-bs-api    rpp-merchanttransaction-ms-api    webhook    o2o-uaa    bifrost    platform-gateway    o2o-gateway    o2o-admintools    kafka
    Get Search Category
    Fetch Category Id From Name    ${category_name_en}
    Get Search Sub Category
    Fetch Sub Category Id From Category Id    ${TEST_DATA_CATEGORY_ID}
    # create brand
    Post Create Brand    { "brandName": { "th": "${TEST_DATA_BRAND_NAME_TH}", "en": "${TEST_DATA_BRAND_NAME_EN}", "default": "th" }, "description": "${TEST_DATA_BRAND_DESCRIPTION}", "category": "${TEST_DATA_CATEGORY_ID}", "subCategory": "${TEST_DATA_SUB_CATEGORY_ID}" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Brand Mongo Id
    Fetch Property From Response    .brandId    TEST_DATA_BRAND_ID
    
    # create shop
    Post Create Shop    ${TEST_DATA_BRAND_MONGO_ID}    { "shopAddresses": { "address": "${TEST_DATA_SHOP_ADDRESS}", "city": "${TEST_DATA_SHOP_CITY}", "country": "${TEST_DATA_SHOP_COUNTRY}", "district": "${TEST_DATA_SHOP_DISTRICT}", "geolocation": "13.6601781,100.6254328", "postcode": "${TEST_DATA_SHOP_POST_CODE}", "districtId": "${TEST_DATA_SHOP_DISTRICT_ID}", "subDistrictId": "${TEST_DATA_SHOP_SUB_DISTRICT_ID}", "provinceId": "${TEST_DATA_SHOP_PROVINCE_ID}" }, "shopCategories": [ "FOOD", "SERVICE" ], "shopContacts": [ { "email": "${TEST_DATA_SHOP_EMAIL}", "fullName": "${TEST_DATA_SHOP_SHOP_CONTACTS_FULL_NAME}", "phone": "${TEST_DATA_SHOP_PHONE}" } ], "shopDetails": { "description": "${TEST_DATA_SHOP_SHOP_DETAILS_DESCRIPTION}", "openHours": { "sun": "08:00-19:00", "mon": "", "tue": "08:00-19:00", "wed": "08:00-19:00", "thu": "08:00-19:00", "fri": "08:00-19:00", "sat": "08:00-19:00" } }, "shopName": { "default": "th", "en": "${TEST_DATA_SHOP_NAME_EN}", "th": "${TEST_DATA_SHOP_NAME_TH}" }, "status": "ACTIVE", "shopType": [ "OFFLINE", "ONLINE" ] }
    Extract And Store Shop Mongo Id From Response
    Response Correct Code    ${CREATED_CODE}

    # create terminal
    Post Create Terminal    ${SHOP_MONGO_ID}    { "terminalName": { "th": "${TEST_DATA_TERMINAL_NAME_TH}", "en": "${TEST_DATA_TERMINAL_NAME_EN}", "default": "en" }, "terminalType": "${TEST_DATA_TERMINAL_TERMINAL_TYPE}", "description": "${TEST_DATA_TERMINAL_DESCRIPTION}", "status": "INACTIVE" }
    Response Correct Code    ${CREATED_CODE}
    
    # create brand truemoney
    Post Brand Kyb With Provider    ${TEST_DATA_BRAND_MONGO_ID}    truemoney    { "operatorEmail": "${TEST_DATA_BRAND_TRUEMONEY_OPERATOR_EMAIL}", "businessType": "INDIVIDUAL", "isVat20Registration": "true", "taxId": "000000000009", "merchantDetailContactEmail": "${TEST_DATA_BRAND_TRUEMONEY_MERCHANT_DETAIL_CONTACT_EMAIL}", "merchantDetailContactPhoneNumber": "${TEST_DATA_BRAND_TRUEMONEY_MERCHANT_DETAIL_CONTACT_PHONE_NUMBER}", "merchantDetailContactAddress": "${TEST_DATA_BRAND_TRUEMONEY_MERCHANT_DETAIL_CONTACT_ADDRESS}", "merchantDetailContactAddressSubDistrictId": "1", "merchantDetailContactAddressDistrictId": "1", "merchantDetailContactAddressProvinceId": "1", "merchantDetailContactAddressPostcode": "10200", "merchantDetailMerchantOfficialNameThai": "${TEST_DATA_BRAND_TRUEMONEY_MERCHANT_DETAIL_MERCHANT_OFFICIAL_NAME_THAI}", "merchantDetailMerchantOfficialNameEnglish": "${TEST_DATA_BRAND_TRUEMONEY_MERCHANT_DETAIL_MERCHANT_OFFICIAL_NAME_ENGLISH}", "bankDetailAccountType": "${TEST_DATA_BRAND_TRUEMONEY_BANK_DETAIL_ACCOUNT_TYPE}", "bankDetailBankAccountName": "${TEST_DATA_BRAND_TRUEMONEY_BANK_DETAIL_ACCOUNT_NAME}", "bankDetailBankAccountNumber": "${TEST_DATA_BRAND_TRUEMONEY_BANK_DETAIL_ACCOUNT_NUMBER}", "bankDetailBankCode": "${TEST_DATA_BRAND_TRUEMONEY_BANK_DETAIL_BANK_CODE}", "businessOwnerDetailBirthDate": "${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_BIRTHDAY}", "businessOwnerDetailGender": "MALE", "businessOwnerDetailIdentificationType": "THAI_ID", "businessOwnerDetailIdentificationNumber": "${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_IDENTIFICATION_NUMBER}", "businessOwnerDetailJcNumber": "${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_JC_NUMBER}", "businessOwnerDetailOccupation": "${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_OCCUPATION}", "businessOwnerDetailOwnerFirstName": "${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_FIRST_NAME}", "businessOwnerDetailOwnerLastName": "${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_LAST_NAME}", "businessOwnerDetailCurrentAddress": "${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_CURRENT_ADDRESS}", "businessOwnerDetailCurrentAddressSubDistrictId": "182", "businessOwnerDetailCurrentAddressDistrictId": "30", "businessOwnerDetailCurrentAddressProvinceId": "1", "businessOwnerDetailCurrentAddressPostcode": "10900", "companyDetailBranchName": "${TEST_DATA_BRAND_TRUEMONEY_COMPANY_DETAIL_BRANCH_NAME}", "companyDetailBranchType": "HEADQUARTER", "companyDetailCommercialRegisteredNameThai": "????????????????????????????????????", "companyDetailCommercialRegisteredNameEnglish": "branch test", "companyDetailCommercialRegistrationNumber": "000000000009", "companyDetailCompanyEmail": "${TEST_DATA_BRAND_TRUEMONEY_COMPANY_DETAIL_COMPANY_EMAIL}", "companyDetailCompanyPhone": "${TEST_DATA_BRAND_TRUEMONEY_COMPANY_DETAIL_COMPANY_PHONE_NUMBER}", "companyDetailRepresentativeFirstName": "???????????????????????????", "companyDetailRepresentativeLastName": "??????????????????????????????????????????", "isAllowClarifyWithHoldingTax": "true", "merchantAttributeLocation": "13.0214509,77.5383601", "walletAccountNumber": "${TEST_DATA_BRAND_TRUEMONEY_WALLET_ACCOUNT_NUMBER}", "settlementType": "wallet", "registerChannel": "appagent", "dipchip": "yes", "businessOwnerDetailContactMobilePhoneNumber": "${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_CONTACT_PHONE_NUMBER}", "businessOwnerDetailContactEmail": "${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_CONTACT_EMAIL}" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId    BRAND_TRUEMONEY_CONTENT_ID
    
    # create brand trueyou
    Post Brand Kyb With Provider    ${TEST_DATA_BRAND_MONGO_ID}    trueyou    { "channel": "appretail", "brandNameTh": "${TEST_DATA_BRAND_TRUEYOU_BRAND_NAME_THAI}", "brandNameEn": "${TEST_DATA_BRAND_TRUEYOU_BRAND_NAME_ENGLISH}", "brandDescription": "${TEST_DATA_BRAND_TRUEYOU_BRAND_DESCRIPTION}", "brandRequest": "11", "brandSpec": "Online", "brandAddress": "${TEST_DATA_BRAND_TRUEYOU_BRAND_ADDRESS}", "brandAddressRoad": "${TEST_DATA_BRAND_TRUEYOU_BRAND_ADDRESS_ROAD}", "brandAddressProvinceId": "1", "brandAddressDistrictId": "1", "brandAddressSubdistrictId": "1", "brandAddressPostcode": "10200", "brandAddressCountry": "Thailand", "brandTelephone": "${TEST_DATA_BRAND_TRUEYOU_BRAND_TELEPHONE}", "brandTelephone2": "${TEST_DATA_BRAND_TRUEYOU_BRAND_TELEPHONE_2}", "brandAddressLatitude": "13.888", "brandAddressLongitude": "100.898", "contactTitle": "??????????????????", "contactName": "${TEST_DATA_BRAND_TRUEYOU_CONTACT_NAME}", "contactLastname": "${TEST_DATA_BRAND_TRUEYOU_CONTACT_LAST_NAME}", "contactTelephone": "${TEST_DATA_BRAND_TRUEYOU_CONTACT_TELEPHONE}", "contactEmail": "${TEST_DATA_BRAND_TRUEYOU_CONTACT_EMAIL}", "privilegeTrueOffer": "???????????????????????????????????? 150 ?????????????????????????????? 1 ????????? 600 ml | ?????? 1%", "privilegeTrueTerm": "????????????????????????????????????????????? 2 ??????", "privilegeRedFlag": "0", "pointOfPurchaseAddress": "${TEST_DATA_BRAND_TRUEYOU_POINT_OF_PURCHASE_ADDRESS}", "pointOfPurchaseAddressRoad": "${TEST_DATA_BRAND_TRUEYOU_POINT_OF_PURCHASE_ADDRESS_ROAD}", "pointOfPurchaseAddressDistrictId": "4", "pointOfPurchaseAddressSubdistrictId": "28", "pointOfPurchaseAddressProvinceId": "1", "pointOfPurchaseAddressPostcode": "10500", "shopAddress": "${TEST_DATA_BRAND_TRUEYOU_SHOP_ADDRESS}", "shopAddressRoad": "${TEST_DATA_BRAND_TRUEYOU_SHOP_ADDRESS_ROAD}", "shopAddressProvinceId": "1", "shopAddressDistrictId": "1", "shopAddressSubdistrictId": "1", "shopAddressPostcode": "10200" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId    BRAND_TRUEYOU_CONTENT_ID
    Fetch Property From Response    refId    BRAND_TRUEYOU_REF_ID
    
    # create shop TrueMoney
    Post Shop Kyb With Provider    ${SHOP_MONGO_ID}    truemoney    { "englishName": "${TEST_DATA_SHOP_TRUE_MONEY_ENGLISH_NAME}", "thaiName": "${TEST_DATA_SHOP_TRUE_MONEY_THAI_NAME}", "registerEnglishName": "${TEST_DATA_SHOP_TRUE_MONEY_REGISTER_ENGLISH_NAME}", "registerThaiName": "${TEST_DATA_SHOP_TRUE_MONEY_REGISTER_THAI_NAME}", "locationInfoLongitude": "100.5660648", "locationInfoLatitude": "13.7644702", "description": "${TEST_DATA_SHOP_TRUE_MONEY_DESCRIPTION}", "branchName": "${TEST_DATA_SHOP_TRUE_MONEY_BRANCH_NAME}", "businessType": "INDIVIDUAL", "contactEmail": "${TEST_DATA_SHOP_TRUE_MONEY_CONTACT_EMAIL}", "contactPhone": "${TEST_DATA_SHOP_TRUE_MONEY_CONTACT_PHONE}", "contactAddressAddress": "${TEST_DATA_SHOP_TRUE_MONEY_CONTACT_ADDRESSES_ADDRES}", "contactAddressDistrictId": "4", "contactAddressSubDistrictId": "28", "contactAddressProvinceId": "1", "contactAddressPostcode": "10500", "shopLocationAddressAddress": "${TEST_DATA_SHOP_TRUE_MONEY_SHOP_LOCATION_ADDRESS_ADDRESS}", "shopLocationAddressDistrictId": "30", "shopLocationAddressSubDistrictId": "182", "shopLocationAddressProvinceId": "1", "shopLocationAddressPostcode": "10900", "billingAddressAddress": "${TEST_DATA_SHOP_TRUE_MONEY_BILLING_ADDRESSES_ADDRES}", "billingAddressDistrictId": "4", "billingAddressSubDistrictId": "28", "billingAddressProvinceId": "1", "billingAddressPostcode": "10500", "taxId": "1101400000111", "accountType": "${TEST_DATA_SHOP_TRUE_MONEY_BANK_ACCOUNT_TYPE}", "bankAccountNumber": "${TEST_DATA_SHOP_TRUE_MONEY_BANK_ACCOUNT_NUMBER}", "bankAccountName": "${TEST_DATA_SHOP_TRUE_MONEY_BANK_ACCOUNT_NAME}", "bankCode": "${TEST_DATA_SHOP_TRUE_MONEY_BANK_CODE}", "walletAccountName": "${TEST_DATA_SHOP_TRUE_MONEY_WALLET_ACCOUNT_NAME}", "walletAccountNumber": "${TEST_DATA_SHOP_TRUE_MONEY_WALLET_ACCOUNT_NUMBER}" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId    SHOP_TRUEMONEY_CONTENT_ID
    Fetch Property From Response    refId    SHOP_TRUEMONEY_REF_ID
    
    # create shop TrueYou
    Post Shop Kyb With Provider    ${SHOP_MONGO_ID}    trueyou    { "channel": "appagent", "shopNameTh": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_NAME_TH}", "shopNameEn": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_NAME_EN}", "shopBrandTypeId": "1", "shopArea": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_AREA}", "shopAddress": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_ADDRESS}", "shopAddress2": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_ADDRESS_2}", "shopProvinceId": "1", "shopDistrictId": "30", "shopSubDistrictId": "182", "shopZipcode": "10900", "shopTelephone": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_TELEPHONE}", "shopTelephone2": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_TELEPHONE_2}", "shopTax": "1234567890123", "shopMapLatitude": "13.7237433", "shopMapLongitude": "100.5183629", "shopLinkWebSite": "https://www.wemall.com/", "shopLinkFacebook": "https://www.facebook.com/WeMall/", "shopLinkInstagram": "https://www.instagram.com/wemall_official/", "shopContactPersonFullName": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_CONTACT_PERSON_FULL_NAME}", "shopContactPersonTell": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_CONTACT_PERSON_TELL}", "shopContactPersonEmail": "${TEST_DATA_SHOP_TRUE_YOU_SHOP_CONTACT_PERSON_EMAIL}", "shopHeadquater": "1" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId    SHOP_TRUEYOU_CONTENT_ID

    # create shop constract TrueMoney
    Post Request Create Shop Contract TrueMoney    ${SHOP_MONGO_ID}    { "contractBasicProductCode": "51051000100000000023", "contractBasicContractName": "${TEST_DATA_SHOP_CONSTRACT_TRUE_MONEY_CONTRACT_BASIC_CONTRACT_NAME}", "contractBasicSignedTime": "2020-03-10T22:44:55+07:00", "contractBasicEffectTime": "2020-03-20T06:44:55+07:00", "contractBasicExpiryTime": "2020-03-20T06:44:55+07:00", "contractBasicExpiryType": "NOTIFY", "contractBasicLastModifier": "${TEST_DATA_SHOP_CONSTRACT_TRUE_MONEY_CONTRACT_BASIC_LAST_MODIFIER}", "contractBasicContractStatus": "DRAFT", "contractBasicEffectType": "IMMEDIATE", "contractBasicMemo": "test cha", "contractBasicProjectCode": "TRUEYOU", "contractBasicTmnSettlement": true, "productConditionCutoffTime": "0030", "productConditionSettlementTime": "0229", "productConditionSettleCurrency": "THB", "productConditionOrderMode": "API", "productConditionProductMode": "DIRECTPAY", "productConditionAcquiringMode": "DIRECTPAY", "productConditionStagePaymentType": "PAYMENT_IN_FULL", "productConditionSettleStrategy": "BY_TIME_CYCLE", "productConditionSettleCycle": "T+2", "productConditionSettleAccountType": "WALLET", "productConditionSettleActorType": "SHOP", "productConditionSettleAmountThresholdCurrency": "THB", "productConditionSettleAmountThresholdValue": "10", "productConditionCardIndexNo": "12345678", "productConditionTaxRefCode": "TH", "productConditionFeeItemsFeeCalcBasis": "TRADING_AMOUNT", "productConditionFeeItemsChargeTarget": "RECEIVER", "productConditionFeeItemsFeeCalcMethod": "FULL_CALCULATION", "productConditionFeeItemsFeeSettleMode": "REALTIME", "productConditionFeeItemsChargeMode": "INNER_DEDUCT", "productConditionFeeItemsChargeCurrency": "THB", "productConditionFeeItemsPaymentOffset": true, "productConditionFeeItemsPayMethodFeeInfosFixedFeeAmountCurrency": "THB", "productConditionFeeItemsPayMethodFeeInfosFixedFeeAmountValue": "0", "productConditionFeeItemsPayMethodFeeInfosPayMethods": "BALANCE", "productConditionFeeItemsPayMethodFeeInfosFeeRate": "1", "productConditionFeeItemsPayMethodFeeInfosMinPaymentAmount": "1", "productConditionFeeItemsPayMethodFeeInfosMaxPaymentAmount": "6000", "productConditionFeeItemsPayMethodFeeInfosOmiseMerchantCode": "RETAIL", "productConditionFeeItemsPayMethodFeeInfosRefundConditionSupportRefund": true, "productConditionFeeItemsPayMethodFeeInfosRefundConditionSupportPartialRefund": true, "productConditionFeeItemsPayMethodFeeInfosRefundConditionRefundExpiryTime": "365", "productConditionFeeItemsPayMethodFeeInfosRefundConditionRefundCurrency": "THB", "productConditionFeeItemsPayMethodFeeInfosRefundConditionRefundFee": true, "productConditionFeeItemsPayMethodFeeInfosCancelConditionSupportCancel": true }
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId    SHOP_CONTRACT_TRUEMONEY_CONTENT_ID
    
    # create brand call verification
    Post Save Brand Call Verification By Refid    ${TEST_DATA_BRAND_MONGO_ID}    { "deviceType": [ "QR39" ], "provider": "${TEST_DATA_BRAND_CALL_VERIFICATION_PROVIDER}", "businessType": "INDIVIDUAL", "firstName": "${TEST_DATA_BRAND_CALL_VERIFICATION_FIRST_NAME}", "lastName": "${TEST_DATA_BRAND_CALL_VERIFICATION_LAST_NAME}", "birthDate": "${TEST_DATA_BRAND_CALL_VERIFICATION_BIRTHDAY}", "brandContactEmail": "${TEST_DATA_BRAND_CALL_VERIFICATION_BRAND_CONTACT_EMAIL}", "brandContactPhone": "${TEST_DATA_BRAND_CALL_VERIFICATION_BRAND_CONTACT_PHONE}", "brandAddress": "${TEST_DATA_BRAND_CALL_VERIFICATION_BRAND_ADDRESS}", "brandSubDistrictId": "28", "brandDistrictId": "4", "brandProvinceId": "1", "brandPostCode": "10500", "startDatePrivilege": "${TEST_DATA_BRAND_CALL_VERIFICATION_START_DATE_PRIVILEGE}", "endDatePrivilege": "${TEST_DATA_BRAND_CALL_VERIFICATION_END_DATE_PRIVILEGE}", "trueCardPrivilege": "${TEST_DATA_BRAND_CALL_VERIFICATION_TRUE_CARD_PRIVILEGE}", "redCardPrivilege": "${TEST_DATA_BRAND_CALL_VERIFICATION_RED_CARD_PRIVILEGE}", "blackCardPrivilege": "${TEST_DATA_BRAND_CALL_VERIFICATION_BLACK_CARD_PRIVILEGE}", "registerChannel": "appretail", "saleId": "gg", "saleCode": "${TEST_DATA_BRAND_CALL_VERIFICATION_SALE_CODE}" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId        BRAND_CALL_VERIFICATION_CONTENT_ID
    
    # create shop callverfication
    Post Save Shop Call Verification By Refid    ${SHOP_MONGO_ID}    { "deviceType": [ "QR39" ], "provider": "${TEST_DATA_SHOP_CALL_VERIFICATION_PROVIDER}", "businessType": "INDIVIDUAL", "walletAccountNumber": "${TEST_DATA_SHOP_CALL_VERIFICATION_WALLET_ACCOUNT_NUMBER}", "shopAddress": "${TEST_DATA_SHOP_CALL_VERIFICATION_SHOP_ADDRESS}", "shopSubDistrictId": "801", "shopDistrictId": "101", "shopProvinceId": "7", "shopPostCode": "15150", "registerChannel": "appretail", "saleId": "555", "saleCode": "${TEST_DATA_SHOP_CALL_VERIFICATION_SALE_CODE}" }
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId        SHOP_CALL_VERIFICATION_CONTENT_ID
    
    # save private file to brand truemoney
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    OWNER_IMAGE    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_owner_image}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    OWNER_CERTIFICATE    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_owner_certificate}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    VAT_REGISTRATION    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${png_vat_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    BANK_PASSBOOK    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${pdf_bank_passbook}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    HOUSEHOLD_REGISTRATION    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_household_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    COMPANY_REGISTRATION    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_company_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    RENTAL_CONTRACT    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_rental_contract}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    OTHER    BRAND
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_other}
    Response Correct Code    ${SUCCESS_CODE}
    
    # save private file to brand trueyou
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    OWNER_IMAGE    BRAND
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_owner_image}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    OWNER_CERTIFICATE    BRAND
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_owner_certificate}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    VAT_REGISTRATION    BRAND
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${png_vat_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    BANK_PASSBOOK    BRAND
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${pdf_bank_passbook}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    HOUSEHOLD_REGISTRATION    BRAND
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_household_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    COMPANY_REGISTRATION    BRAND
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_company_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    RENTAL_CONTRACT    BRAND
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_rental_contract}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${TEST_DATA_BRAND_MONGO_ID}    OTHER    BRAND
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_other}
    Response Correct Code    ${SUCCESS_CODE}

    # save public file to brand provider 
    Post Upload File    ${TEST_DATA_BRAND_MONGO_ID}    BRAND_IMAGE_LOGO    ${jpeg_brand_image_logo}
    Response Correct Code    ${CREATED_CODE}
    Post Upload File    ${TEST_DATA_BRAND_MONGO_ID}    BRAND_IMAGE_STORE_FRONT    ${jpeg_brand_image_store_front}
    Response Correct Code    ${CREATED_CODE}
    Post Upload File    ${TEST_DATA_BRAND_MONGO_ID}    BRAND_IMAGE_MENU    ${png_brand_image_menu}
    Response Correct Code    ${CREATED_CODE}
    Post Upload File    ${TEST_DATA_BRAND_MONGO_ID}    BRAND_IMAGE_MAP    ${jpeg_brand_image_map}
    Response Correct Code    ${CREATED_CODE}
    Post Upload File    ${TEST_DATA_BRAND_MONGO_ID}    BRAND_IMAGE_OTHER    ${jpeg_brand_image_other}
    Response Correct Code    ${CREATED_CODE}
    
    # save private file to shop provider - TrueMoney
    Generate Content To Upload    ${SHOP_MONGO_ID}    OWNER_IMAGE    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_owner_image}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    OWNER_CERTIFICATE    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_owner_certificate}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    VAT_REGISTRATION    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${png_vat_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    BANK_PASSBOOK    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${pdf_bank_passbook}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    HOUSEHOLD_REGISTRATION    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_household_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    COMPANY_REGISTRATION    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_company_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    RENTAL_CONTRACT    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_rental_contract}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    OTHER    SHOP
    Post Upload    truemoney    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_other}
    Response Correct Code    ${SUCCESS_CODE}
    
    # save private file to shop provider - TrueYou
    Generate Content To Upload    ${SHOP_MONGO_ID}    OWNER_IMAGE    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_owner_image}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    OWNER_CERTIFICATE    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_owner_certificate}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    VAT_REGISTRATION    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${png_vat_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    BANK_PASSBOOK    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${pdf_bank_passbook}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    HOUSEHOLD_REGISTRATION    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_household_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    COMPANY_REGISTRATION    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_company_registration}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    RENTAL_CONTRACT    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_rental_contract}
    Response Correct Code    ${SUCCESS_CODE}
    Generate Content To Upload    ${SHOP_MONGO_ID}    OTHER    SHOP
    Post Upload    trueyou    ${TEST_DATA_UPLOAD_CONTENT}    ${jpeg_other}
    Response Correct Code    ${SUCCESS_CODE}
    
    # save public file to shop provider
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_LOGO    ${jpeg_shop_image_logo}
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId    SHOP_IMAGE_LOGO_CONTENT_ID
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_STORE_FRONT    ${jpeg_shop_image_store_front}
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId    SHOP_IMAGE_STORE_FRONT_CONTENT_ID
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_MENU    ${png_shop_image_menu}
    Response Correct Code    ${CREATED_CODE}
    Fetch Property From Response    contentId    SHOP_IMAGE_MENU_CONTENT_ID
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_MAP    ${jpeg_shop_image_map}
    Response Correct Code    ${CREATED_CODE}
    Post Upload File    ${SHOP_MONGO_ID}    SHOP_IMAGE_OTHER    ${jpeg_shop_image_other}
    Response Correct Code    ${CREATED_CODE}
    
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-callverification    ${BRAND_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    DRAFT
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-callverification    ${SHOP_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    DRAFT
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${BRAND_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    DRAFT
    Response Property Should Be Equal As String    data.fraudStatus    DRAFT
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    DRAFT
    # ??? https://docs.google.com/spreadsheets/d/1RxkjwrZBIEKizK60E0sDXH17aLJ_mpENMA_CggOSV5U/edit#gid=929319168
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-contract-truemoney    ${SHOP_CONTRACT_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    ONBOARD_IN_PROGRESS
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${BRAND_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    DRAFT
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${SHOP_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    DRAFT
    
    # update brand callver status to WAITING_REVIEW
    Put Update Brand Call Verification By Refid    ${TEST_DATA_BRAND_MONGO_ID}    { "callVerStatus": "WAITING_REVIEW" }
    Response Correct Code    ${SUCCESS_CODE}
    
    # Wait Data To Sync On Cms    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${SHOP_TRUEYOU_CONTENT_ID}    data.status    CALLVER_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-callverification    ${BRAND_CALL_VERIFICATION_CONTENT_ID}
    # Response Property Should Be Equal As String    data.callVerStatus    WAITING_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-callverification    ${SHOP_CALL_VERIFICATION_CONTENT_ID}
    # Response Property Should Be Equal As String    data.callVerStatus    WAITING_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${BRAND_TRUEMONEY_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    CALLVER_REVIEW
    # Response Property Should Be Equal As String    data.fraudStatus    DRAFT
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEMONEY_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    CALLVER_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-contract-truemoney    ${SHOP_CONTRACT_TRUEMONEY_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    ONBOARD_IN_PROGRESS
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${BRAND_TRUEYOU_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    CALLVER_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${SHOP_TRUEYOU_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    CALLVER_REVIEW
    
    # brand call verfication admin approval
    Navigate On Left Menu Bar     Call Verification (QR39)    Brand
    brand_call_verification_keywords.Clear Search Results
    brand_call_verification_keywords.Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    brand_call_verification_keywords.Verify Brand Information    service_type=TrueMoney + Trueyou    business_type=INDIVIDUAL    
    ...    brand_name_th=${TEST_DATA_BRAND_NAME_TH}    owner_name_th=${TEST_DATA_BRAND_CALL_VERIFICATION_FIRST_NAME}${SPACE}${TEST_DATA_BRAND_CALL_VERIFICATION_LAST_NAME}    brand_name_en=${TEST_DATA_BRAND_NAME_EN}    owner_name_en=-
    ...    mobile=${TEST_DATA_BRAND_CALL_VERIFICATION_BRAND_CONTACT_PHONE}    email=${TEST_DATA_BRAND_CALL_VERIFICATION_BRAND_CONTACT_EMAIL}    date_of_birth=${TEST_DATA_BRAND_CALL_VERIFICATION_BIRTHDAY_ADMINTOOLS}
    ...    start_end_privilege=${TEST_DATA_BRAND_CALL_VERIFICATION_START_END_DATE_PRIVILEGE_ADMINTOOLS}    true_card_privilege=${TEST_DATA_BRAND_CALL_VERIFICATION_TRUE_CARD_PRIVILEGE}    red_card_privilege=${TEST_DATA_BRAND_CALL_VERIFICATION_RED_CARD_PRIVILEGE}    black_card_privilege=${TEST_DATA_BRAND_CALL_VERIFICATION_BLACK_CARD_PRIVILEGE}
    ...    category=Food & Drink    sub_category=Shabu/Sukiyaki    address=${TEST_DATA_BRAND_CALL_VERIFICATION_BRAND_ADDRESS}    province=Bangkok    district=Bang Rak    sub_district=Maha Phruettharam    post_code=10500
    ...    lang=en
    brand_call_verification_keywords.Verify Shop Information    shop_name_th=${TEST_DATA_SHOP_NAME_TH}    shop_name_en=${TEST_DATA_SHOP_NAME_EN}
    ...    business_type=INDIVIDUAL    wallet_no=${TEST_DATA_SHOP_CALL_VERIFICATION_WALLET_ACCOUNT_NUMBER_ADMINTOOLS}    shop_type=Offline,Online
    ...    address=${TEST_DATA_SHOP_CALL_VERIFICATION_SHOP_ADDRESS}    province=Loburi    district=Tha Wung   sub_district=Hua Samrong    post_code=15150
    # Edit Call Verification Details    call_verification_status=Attempt1
    # Click Save Brand Call Verification Information
    # Search Call Verification    call_verification_status=All
    # brand_call_verification_keywords.Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    # Edit Call Verification Details    call_verification_status=Attempt2
    # Click Save Brand Call Verification Information
    # brand_call_verification_keywords.Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    # Edit Call Verification Details    call_verification_status=SMS
    # Click Save Brand Call Verification Information
    # brand_call_verification_keywords.Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    Edit Call Verification Details    call_verification_status=Passed
    Click Save Brand Call Verification Information
    
    # Wait Data To Sync On Cms    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEYOU_CONTENT_ID}    data.status    FRAUD_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-callverification    ${BRAND_CALL_VERIFICATION_CONTENT_ID}
    # Response Property Should Be Equal As String    data.callVerStatus    PASSED
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-callverification    ${SHOP_CALL_VERIFICATION_CONTENT_ID}
    # Response Property Should Be Equal As String    data.callVerStatus    PASSED
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${BRAND_TRUEMONEY_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    FRAUD_REVIEW
    # Response Property Should Be Equal As String    data.fraudStatus    WAITING_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEMONEY_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    FRAUD_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-contract-truemoney    ${SHOP_CONTRACT_TRUEMONEY_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    ONBOARD_IN_PROGRESS
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${BRAND_TRUEYOU_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    FRAUD_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${SHOP_TRUEYOU_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    FRAUD_REVIEW
    
    # Fraud admin approval
    Navigate On Left Menu Bar     Fraud Approval    Brand
    fraud_admin_approval_keywords.Clear Search Results
    Search Merchants    brand_id=${TEST_DATA_BRAND_ID}
    fraud_admin_approval_keywords.Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    # update status to Revise
    Edit Fraud Approval Status    Revise    remark=update status to REVISE
    Save Fraud Approval Information
    # access to the edit Fraud Approval page again
    fraud_admin_approval_keywords.Search Merchants    fraud_status=All
    fraud_admin_approval_keywords.Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    # verify category, sub category, and status are updated
    Verify Fraud Review    dipchip=YES    revise_no=1
    ...    fraud_status=Revise    remark=update status to REVISE
    
    # Wait Data To Sync On Cms    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${BRAND_TRUEMONEY_CONTENT_ID}    data.fraudStatus    REVISE
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${BRAND_TRUEMONEY_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    FRAUD_REVIEW
    # Response Property Should Be Equal As String    data.fraudStatus    REVISE
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${BRAND_TRUEYOU_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    FRAUD_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEMONEY_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    FRAUD_REVIEW
    # Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${SHOP_TRUEYOU_CONTENT_ID}
    # Response Property Should Be Equal As String    data.status    FRAUD_REVIEW
    
    # update status to Passed
    Edit Fraud Approval Status    Passed
    Save Fraud Approval Information
    
    Wait Data To Sync On Cms    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEMONEY_CONTENT_ID}    data.tmnShopId    300000000
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-callverification    ${BRAND_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    PASSED
    Response Property Should Be Equal As String    data.saleCode    ${TEST_DATA_BRAND_CALL_VERIFICATION_SALE_CODE}
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-callverification    ${SHOP_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    PASSED
    Response Property Should Be Equal As String    data.saleCode    ${TEST_DATA_SHOP_CALL_VERIFICATION_SALE_CODE}
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${BRAND_TRUEMONEY_CONTENT_ID}
    Fetch Property From Response    data.tmnBrandId    TRUEMONEY_BRAND_ID
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    Response Property Should Be Equal As String    data.fraudStatus    PASSED
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEMONEY_CONTENT_ID}
    Fetch Property From Response    data.tmnShopId    TRUEMONEY_SHOP_ID
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-contract-truemoney    ${SHOP_CONTRACT_TRUEMONEY_CONTENT_ID}
    Fetch Property From Response    data.tmnContractShopId    TRUEMONEY_SHOP_CONTRACT_ID
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    # ASCO2O-19174: When Fraud Admin approved [TMN+TY] merchant registration, then brand onboarded to TrueYou - DONE
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${BRAND_TRUEYOU_CONTENT_ID}
    Response Should Contain Property Matches Regex    data."trueYouBrandId"    \\d{5}
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    # Failed
    # Response Property Should Be Equal As String    data.tmnStatus    WAITING
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${SHOP_TRUEYOU_CONTENT_ID}
    Fetch Property From Response    data."shopTrueYouId"    SHOP_TRUEYOU_TRUEYOU_SHOP_ID
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    Response Should Contain Property Matches Regex    data."shopTrueYouId"    \\d{15}
    
    # ASCO2O-19172: When Fraud Admin approved [TMN+TY] merchant registration, then shop, shop contract, terminal onboarded to TrueMoney - DONE
    Get All Content    ${TEST_DATA_CMS_PROJECT_ID}    terminal-truemoney    data.shopRefId=${SHOP_TRUEMONEY_REF_ID}
    Fetch Property From Response    .id    TERMINAL_TRUEMONEY_REF_ID
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    terminal-truemoney    ${TERMINAL_TRUEMONEY_REF_ID}
    Fetch Property From Response    data.terminalTmnId    TERMINAL_TRUEMONEY_ID
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    
    # access to the edit Fraud Approval page again
    Sort By Column    Modified Date/Time
    fraud_admin_approval_keywords.Click Edit By Brand Id    ${TEST_DATA_BRAND_ID}
    # verify category, sub category, and status are updated
    Verify Fraud Review    dipchip=YES    revise_no=1
    ...    fraud_status=Passed    remark=${EMPTY}
    Clean Environment
    
    # ASCO2O-19172: When Fraud Admin approved [TMN+TY] merchant registration, then shop, shop contract, terminal onboarded to TrueMoney
    Switch To Non Angular JS Site
    Open Browser With Option    ${TRUE_MONEY_ADMIN_PORTAL_URL}
    Login TrueMoney Admin Portal    ${TRUE_MONEY_ADMIN_PORTAL_USERNAME}    ${TRUE_MONEY_ADMIN_PORTAL_PASSWORD}
    Go To Url    https://backoffice-ui.tmn-dev.com/core/merchant-management/merchants/${TRUEMONEY_BRAND_ID}
    Verify Business Owner Detail    business_type=INDIVIDUAL    identification_document_type=THAI_ID    thai_id=${TEST_DATA_BRAND_TRUEMONEY_THAI_ID_ON_TRUEMONEY_ADMIN_PORTAL}
    Verify Merchant Detail    contact_address_address=${TEST_DATA_BRAND_CALL_VERIFICATION_BRAND_ADDRESS}    contact_address_sub_district=??????????????????????????????    contact_address_district=??????????????????    contact_address_city_province=???????????????????????????????????????    contact_address_postcode=10500
    ...    billing_address_address=${TEST_DATA_BRAND_TRUEMONEY_BUSINESS_OWNER_DETAIL_CURRENT_ADDRESS}    billing_address_sub_district=???????????????    billing_address_district=?????????????????????    billing_address_city_province=???????????????????????????????????????    billing_address_postcode=10900
    Verify Brand Kyb Documents    owner_certificate-${TEST_DATA_BRAND_MONGO_ID}    vat_registration-${TEST_DATA_BRAND_MONGO_ID}    bank_passbook-${TEST_DATA_BRAND_MONGO_ID}
    ...    shop_map-${TEST_DATA_BRAND_MONGO_ID}    shop_photo-${TEST_DATA_BRAND_MONGO_ID}    rental_contract-${TEST_DATA_BRAND_MONGO_ID}
    ...    household_registration-${TEST_DATA_BRAND_MONGO_ID}    company_registration-${TEST_DATA_BRAND_MONGO_ID}
    Go To Url    https://backoffice-ui.tmn-dev.com/core/merchant-management/merchants/${TRUEMONEY_BRAND_ID}/shops/${TRUEMONEY_SHOP_ID}
    Verify Contact Information    address=${TEST_DATA_SHOP_TRUE_MONEY_CONTACT_ADDRESSES_ADDRES}    sub_district=??????????????????????????????    district=??????????????????    city_province=???????????????????????????????????????    post_code=10500
    Verify Billing Address    address=${TEST_DATA_SHOP_TRUE_MONEY_BILLING_ADDRESSES_ADDRES}    sub_district=??????????????????????????????    district=??????????????????    city_province=???????????????????????????????????????    post_code=10500
    Verify Terminal List    ${TERMINAL_TRUEMONEY_ID}    ${TEST_DATA_TERMINAL_NAME_EN}    ${TEST_DATA_TERMINAL_TERMINAL_TYPE}    ACTIVE
    Verify Shop Kyb Documents    owner_certificate-${SHOP_MONGO_ID}    vat_registration-${SHOP_MONGO_ID}    bank_passbook-${SHOP_MONGO_ID}
    ...    shop_map-${SHOP_MONGO_ID}    shop_photo-${SHOP_MONGO_ID}    rental_contract-${SHOP_MONGO_ID}
    ...    household_registration-${SHOP_MONGO_ID}    company_registration-${SHOP_MONGO_ID}
    Verify Contract Signed    ${TRUEMONEY_SHOP_CONTRACT_ID}    ${TEST_DATA_SHOP_CONSTRACT_TRUE_MONEY_CONTRACT_BASIC_CONTRACT_NAME}    MRT    ${TEST_DATA_SHOP_CONSTRACT_TRUE_MONEY_CONTRACT_BASIC_LAST_MODIFIER}    DRAFT    
    Clean Environment
    
    # ASCO2O-19174: When Fraud Admin approved [TMN+TY] merchant registration, then brand onboarded to TrueYou
    Open Browser With Option    ${TRUE_YOU_DEAL_MANAGEMENT_URL}
    Login Deal Management    ${DEAL_MANAGEMENT_APPROVER_USERNAME}    ${DEAL_MANAGEMENT_APPROVER_PASSWORD}
    Navigate To Deal Management Menu    RPP-EDC    PROSPECT
    Get First Partner Id On Merchant Table
    Go To Url    ${TRUE_YOU_DEAL_MANAGEMENT_URL}/rpp/edit/${TEST_DATA_PARTNER_ID}
    Verify Partner Requests Detail Information    ref_id=${BRAND_TRUEYOU_REF_ID}    mid=${SHOP_TRUEYOU_TRUEYOU_SHOP_ID}
    Verify Shop Address    road=${TEST_DATA_BRAND_TRUEYOU_BRAND_ADDRESS_ROAD}
    Verify CHRM Information    ${SHOP_IMAGE_STORE_FRONT_CONTENT_ID}    ${SHOP_IMAGE_MENU_CONTENT_ID}    ${SHOP_IMAGE_LOGO_CONTENT_ID}    ${SHOP_TRUEYOU_CONTENT_ID}
    Clean Environment
    
    # https://truemoney.atlassian.net/browse/ASCO2O-24019
    Open Browser With Option    ${TRUE_MONEY_ADMIN_PORTAL_URL}
    Login TrueMoney Admin Portal    ${TRUE_MONEY_ADMIN_PORTAL_USERNAME}    ${TRUE_MONEY_ADMIN_PORTAL_PASSWORD}
    Update TrueMoney Merchant Operation Status    ${TRUEMONEY_BRAND_ID}    CERTIFICATED
    
    Wait Data To Sync On Cms    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${BRAND_TRUEMONEY_CONTENT_ID}    data.status    APPROVE
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-callverification    ${BRAND_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    PASSED
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-callverification    ${SHOP_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    PASSED
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${BRAND_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    APPROVE
    Response Property Should Be Equal As String    data.fraudStatus    PASSED
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-contract-truemoney    ${SHOP_CONTRACT_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${BRAND_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${SHOP_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    Response Should Not Contain Property    data.tmnShopStatus
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    terminal-truemoney    ${TERMINAL_TRUEMONEY_REF_ID}
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    
    Approve Shop Contract Approval    ${TRUEMONEY_SHOP_ID}
    Clean Environment
    
    Wait Data To Sync On Cms    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEMONEY_CONTENT_ID}    data.status    APPROVE
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-callverification    ${BRAND_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    PASSED
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-callverification    ${SHOP_CALL_VERIFICATION_CONTENT_ID}
    Response Property Should Be Equal As String    data.callVerStatus    PASSED
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-truemoney    ${BRAND_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    APPROVE
    Response Property Should Be Equal As String    data.fraudStatus    PASSED
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-truemoney    ${SHOP_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    APPROVE
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-contract-truemoney    ${SHOP_CONTRACT_TRUEMONEY_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    APPROVE
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    brand-trueyou    ${BRAND_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    shop-trueyou    ${SHOP_TRUEYOU_CONTENT_ID}
    Response Property Should Be Equal As String    data.status    WAITING_REVIEW
    Response Property Should Be Equal As String    data.tmnShopStatus    APPROVE
    Get Content    ${TEST_DATA_CMS_PROJECT_ID}    terminal-truemoney    ${TERMINAL_TRUEMONEY_REF_ID}
    Response Property Should Be Equal As String    data.status    APPROVE
    
    # https://truemoney.atlassian.net/browse/ASCO2O-24526
    # TMN + TY already approved on their side
    # Should create merchant tag29 on merchant-transaction and merchant tag39 able to have all ability same as merchant tag29 with service type TMN + TY
    # merchant data are created in MTransaction DB with flagged but without documents information|
    # Get Merchant    ${TEST_DATA_CMS_PROJECT_ID}    tmn_merchant_id=${TRUEMONEY_BRAND_ID}
    # and rpp-address is created correctly
    # and rpp-previlege data is created correctly
    # and rpp-location data is created correctly
    # and rpp-merchant data is created correctly
    
    # https://truemoney.atlassian.net/browse/ASCO2O-26918
    # Get Search    tmnTerminalId=${TERMINAL_TRUEMONEY_ID}
    # Response Correct Code    ${SUCCESS_CODE}
    # Response Should Contain Property With Value    content..tmnTerminalId    ${TERMINAL_TRUEMONEY_ID}
    
    # TO DO: https://truemoney.atlassian.net/browse/ASCO2O-25537