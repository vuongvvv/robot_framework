*** Settings ***
Documentation    [API - TSM-service] API for register merchant QR39 - create basic info

Resource    ../../resources/init.robot
Resource    ../../keywords/tsm/merchant_onboard_resource_keywords.robot

Suite Setup    Generate True ID Gateway Header    ${TRUE_ID_USER}    ${TRUE_ID_USER_PASSWORD}

*** Variables ***
${shop_name_th}    ร้านโรบอตเทส หมาป่า
${shop_name_en}    Robot Test Wolverine Store
${owner_detail_firstname_invalid}    ทดสอบชื่อไทย123
${owner_detail_lastname_invalid}    Testlastname#123
${owner_detail_thaiId_invalid}    1234567890111000
${create_merchant_basic_info_body}    {"onboardType":"QR39","billingAddressFrom":"OWNER","ownerDetail":{"title":"นางสาว","firstname":"ชื่อวูฟโรบอตทดสอบ","lastname":"นามสกุลวูฟโรบอตทดสอบ","gender":"FEMALE","birthdate":"19930820","thaiId":"1234567890123","mobileNo":"0909356123","email":"robot@ascendcorp.com","address":{"address":"12/222 ณ หมู่บ้านหมาป่า","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900}},"shopDetail":{"name":{"th":"${shop_name_th}","en":"${shop_name_en}"},"contactNo":"0909356123","categoryId":"11","subCategoryId":"5541","location":{"latitude":"13.660178","longitude":"100.625432"},"address":{"address":"11/10 อีกฝากนึงของโลก","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900},"saleChannel":"1","description":"ร้านหมาป่าใหญ่","saleCode":"12345"}}

*** Test Cases ***
TC_O2O_27524
    [Documentation]    Verify API when send request to create basic info request with data correctly In case: Request with "saleChannnel" = 3
    [Tags]    Regression    High    Smoke
    Create Merchant Onboard Registration    ${create_merchant_basic_info_body}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    brandRefId
    Response Should Contain Property With String Value    shopRefId

TC_O2O_28028
    [Documentation]     Verify API when send request to create basic info request with "onboardType" is missing
    [Tags]    Regression    Low
    Create Merchant Onboard Registration    {"billingAddressFrom":"OWNER","ownerDetail":{"title":"นางสาว","firstname":"ชื่อวูฟโรบอตทดสอบ","lastname":"นามสกุลวูฟโรบอตทดสอบ","gender":"FEMALE","birthdate":"19930820","thaiId":"1234567890123","mobileNo":"0909356123","email":"robot@ascendcorp.com","address":{"address":"12/222 ณ หมู่บ้านหมาป่า","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900}},"shopDetail":{"name":{"th":"${shop_name_th}","en":"${shop_name_en}"},"contactNo":"0909356123","categoryId":"11","subCategoryId":"5541","location":{"latitude":"13.660178","longitude":"100.625432"},"address":{"address":"11/10 อีกฝากนึงของโลก","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900},"saleChannel":"1","description":"ร้านหมาป่าใหญ่","saleCode":"12345"}}
    Response Correct Code    ${BAD_REQUEST_CODE}

TC_O2O_28029
    [Documentation]     Verify API when send request to create basic info request with "onboardType" is null or empty
    [Tags]    Regression    Low
    Create Merchant Onboard Registration    {"onboardType":null,"billingAddressFrom":"OWNER","ownerDetail":{"title":"นางสาว","firstname":"ชื่อวูฟโรบอตทดสอบ","lastname":"นามสกุลวูฟโรบอตทดสอบ","gender":"FEMALE","birthdate":"19930820","thaiId":"1234567890123","mobileNo":"0909356123","email":"robot@ascendcorp.com","address":{"address":"12/222 ณ หมู่บ้านหมาป่า","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900}},"shopDetail":{"name":{"th":"${shop_name_th}","en":"${shop_name_en}"},"contactNo":"0909356123","categoryId":"11","subCategoryId":"5541","location":{"latitude":"13.660178","longitude":"100.625432"},"address":{"address":"11/10 อีกฝากนึงของโลก","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900},"saleChannel":"1","description":"ร้านหมาป่าใหญ่","saleCode":"12345"}}
    Response Correct Code    ${BAD_REQUEST_CODE}

TC_O2O_28037
    [Documentation]    Verify API when send request to create basic info request with "ownerDetail.firstname", "ownerDetail.lastname" is incorrect format
    [Tags]    Regression    Low
    Create Merchant Onboard Registration    {"onboardType":"QR39","billingAddressFrom":"OWNER","ownerDetail":{"title":"นางสาว","firstname":"${owner_detail_firstname_invalid}","lastname":"${owner_detail_lastname_invalid}","gender":"FEMALE","birthdate":"19930820","thaiId":"1234567890123","mobileNo":"0909356123","email":"robot@ascendcorp.com","address":{"address":"12/222 ณ หมู่บ้านหมาป่า","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900}},"shopDetail":{"name":{"th":"${shop_name_th}","en":"${shop_name_en}"},"contactNo":"0909356123","categoryId":"11","subCategoryId":"5541","location":{"latitude":"13.660178","longitude":"100.625432"},"address":{"address":"11/10 อีกฝากนึงของโลก","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900},"saleChannel":"1","description":"ร้านหมาป่าใหญ่","saleCode":"12345"}}
    Response Correct Code    ${BAD_REQUEST_CODE}

TC_O2O_28050
    [Documentation]    Verify API when send request to create basic info request with "ownerDetail.thaiId" length is more than 13 character
    [Tags]    Regression    Low
    Create Merchant Onboard Registration    {"onboardType":"QR39","billingAddressFrom":"OWNER","ownerDetail":{"title":"นางสาว","firstname":"ชื่อวูฟโรบอตทดสอบ","lastname":"นามสกุลวูฟโรบอตทดสอบ","gender":"FEMALE","birthdate":"19930820","thaiId":"${owner_detail_thaiId_invalid}","mobileNo":"0909356123","email":"robot@ascendcorp.com","address":{"address":"12/222 ณ หมู่บ้านหมาป่า","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900}},"shopDetail":{"name":{"th":"${shop_name_th}่า","en":"${shop_name_en}"},"contactNo":"0909356123","categoryId":"11","subCategoryId":"5541","location":{"latitude":"13.660178","longitude":"100.625432"},"address":{"address":"11/10 อีกฝากนึงของโลก","subDistrictId":180,"districtId":30,"provinceId":1,"postCode":10900},"saleChannel":"1","description":"ร้านหมาป่าใหญ่","saleCode":"12345"}}
    Response Correct Code    ${BAD_REQUEST_CODE}