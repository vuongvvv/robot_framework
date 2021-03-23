*** Settings ***
Documentation    Tests to verify that getOutletContactPerson work correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/dummy_data_common.robot
Resource    ../../../keywords/rpp_merchant/outlet_v_2_resource_keywords.robot

# scope: merchant.outlet.read,merchant.merchant.write,merchant.outlet.write
Test Setup    Generate Robot Automation Header    ${RPP_MERCHANT_USERNAME}    ${RPP_MERCHANT_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
${merchant_TMN_TY_json_data}    ../../resources/testdata/rpp-merchant/merchant_resource/create_rpp_merchant_TMN_TY_data.json
${outlet_json_data_with_2_contact}    ../../resources/testdata/rpp-merchant/outlet_v_2_resource/create_rpp_outlet_with_2_contact_person_data.json

*** Test Cases ***
TC_O2O_07564
    [Documentation]    [ContactPersonV2] Verify API returns 200 and multi Contact Persons from outlet
    [Tags]    Regression    High    UnitTest    Smoke    Minos-2019S08
    Get Random Merchant IDs Follow Business Instruction
    Post Create Merchant    {"merchantId":"${MERCHANT_BRAND_ID}","trueyouId":"${MERCHANT_TY_ID}","tmnMerchantId":"${MERCHANT_TMN_ID}","refId":"${MERCHANT_BRAND_ID}","businessType":"INDIVIDUAL","categoryId":"5948d60ee1382323583e31c7","registerChannel":"mobile_admin_register","storeTypeId":1,"storeContactNo1":"0821022951","storeContactNo2":"0821022951","storeNameTh":"ร้านแพนเค้กของออโตเมทพูล","storeNameEn":"Pancake shop of Automate Pool team","storeDetail":"Mobile maketing","storeWebsite":"https://automate-pancake.com","storeFacebook":"www.facebook.com/automate-pancake","storeLineAt":"@automate-pancake","storeTwitter":"automate-pancake@twitter","storeInstagram":"automate-pancake","thaiId":"1234567890123","taxId":"1234567890123","titleId":1,"titleOtherName":"-","firstName":"James","lastName":"Liew","email":"automate-pancake@hotmail.com","contactNo":"0123456789","lineAt":"@automate-pancake","lineId":"automate-pancake","deviceType":"EDC","status":"WAITING","serviceTypes":["TMN","TY"],"birthdate":"2018-01-30","gender":"male","tmnStatus":"WAITING","trueyouStatus":"WAITING","tmnApproveDate":"2018-01-30T17:30:11","trueyouApproveDate":"2018-01-30T17:30:11","approveDate":"2018-01-30T17:30:11","tmnApiKey":"","road":null,"address":"222\/9","addressType":"merchant","postCode":"10140","districtId":1,"provinceId":1,"subdistrictId":1}
    Get Random Outlets IDs Follow Business Instruction    1
    Post Create Outlets And Address Ref Merchant Id    {"outlets":[{"merchantId": ${MERCHANT_SEQUENCE_ID},"outletNameTh":"\u0e2a\u0e22\u0e32\u0e21\u0e41\u0e21\u0e47\u0e04\u0e42\u0e04\u0e2a\u0e32\u0e02\u0e32\u0e08\u0e23\u0e31\u0e0d","outletNameEn":"Jaran Siam Macro","outletDetail":"","headQuarter":true,"registerChannel":"app_sale_agent","franchisee":true,"saleId":"2","addresses":[{"provinceId":1,"districtId":26,"subdistrictId":8933,"address":"99 Ratchadaphisek Rd","road":"222222","postCode":"11400","latitude":"-74.3","longtitude":"-0.3"},{"provinceId":1,"districtId":26,"subdistrictId":8933,"address":"99 Ratchadaphisek Rd","road":"222222","postCode":"11400","latitude":"-74.3","longtitude":"-0.3"}],"contactPersons":[{"titleId":1,"titleOtherName":"","firstNameTh":"ปฐม","lastNameTh":"\u0e43\u0e08\u0e07\u0e32\u0e21","firstNameEn":"","lastNameEn":"","phoneNo":null,"mobileNo":"66-802283800","email":"tung@gmail.com","thaiId":"1234567891234","passportNo":"2299999","birthDate":"2019-02-10","gender":"male","occupation":"developer"},{"titleId":1,"titleOtherName":"","firstNameTh":"สอง","lastNameTh":"\u0e43\u0e08\u0e07\u0e32\u0e21","firstNameEn":"","lastNameEn":"","phoneNo":null,"mobileNo":"66-802283800","email":"tung@gmail.com","thaiId":"1234567891234","passportNo":"2299999","birthDate":"2019-02-10","gender":"male","occupation":"developer"}, {"titleId":1,"titleOtherName":"","firstNameTh":"\u0e19\u0e34\u0e20\u0e32","lastNameTh":"\u0e43\u0e08\u0e07\u0e32\u0e21","firstNameEn":"","lastNameEn":"","phoneNo":null,"mobileNo":"66-802283800","email":"tung@gmail.com","thaiId":"1234567891234","passportNo":"2299999","birthDate":"2019-02-10","gender":"male","occupation":"developer"}], "status": "WAITING", "tmnOutletId": "${OUTLET_TMN_ID}[0]", "tmnStatus": "WAITING", "trueyouStatus": "WAITING","outletId": "${OUTLET_EXTERNAL_ID}[0]","trueyouId": "${OUTLET_TY_ID}[0]"}]}
    Get Outlet Contact Person    ${OUTLET_SEQUENCE_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Successful Response Of Contact Persons   0
    Verify The Successful Response Of Contact Persons   1

TC_O2O_07565
    [Documentation]    [ContactPersonV2] Verify API returns 200 and a Contact Person when outlet has only 1 Contact Person
    [Tags]    Regression    High    UnitTest    Smoke    Minos-2019S08    Sanity
    Get Outlet Id From List Of Outlets By Index   0
    Get Outlet Contact Person    ${OUTLET_SEQUENCE_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    [0].refType    outlet

