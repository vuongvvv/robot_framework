*** Settings ***
Resource    ../../../resources/init.robot
Resource        ../../../keywords/rpp_merchant_bs/login_keywords.robot
Resource        ../../../keywords/rpp_merchant_bs/merchant_keywords.robot
Resource    ../../../keywords/rpp_merchant/merchant_registration_resource_keywords.robot
Resource    ../../../keywords/rpp_merchant/merchant_resource_keywords.robot

Test Setup    Generate Merchant Bs Header    ${RPP_AUTOMATE_SALE_USER}    ${RPP_AUTOMATE_SALE_PASSWORD}
Test Teardown    Delete All Sessions        

*** Variables ***
${real_merchant_id}                  5b925af53416175d3417de42
${fake_merchant_id}                  5b9253417de42
${merchant_name_en}               Test_verify_merchant_
${merchant_name_th}               ทดสอบ_ตรวจสอบเมอชานต์_

*** Test Cases ***
TC_O2O_10330
    [Documentation]   Verification 'get merchant detail' API by Inputting id truly exist
    [Tags]    Regression    Smoke
    Get Api Merchant Detail     ${real_merchant_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With Value    data.id    ${real_merchant_id}

TC_O2O_10331
    [Documentation]   Verification 'get merchant detail' API by Inputting id doesn't truly exist
    [Tags]    Regression    Smoke
    Get Api Merchant Detail     ${fake_merchant_id}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    status.code    ${400}
    Response Should Contain Property With Value    status.message    Bad Request
    Response Should Contain Property With Value    error.message    Mission Fail

TC_O2O_10332
    [Documentation]   Verification 'Create merchant' API by Inputting data correctly
    [Tags]    merchant-bs-api    manual
    Prepare Body For Create Merchant    ${merchant_name_en}    ${merchant_name_th}
    Post Api Create Merchant     ${finalbody}
    Fetch Java Merchant Id
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With String Value    data.id
    Response Should Contain Property With String Value    data.merchant_id
    
    Generate Robot Automation Header    ${RPP_MERCHANT_USERNAME}    ${RPP_MERCHANT_PASSWORD}
    Get All Merchant Registrations Raw    java_merchant_id=${TEST_DATA_JAVA_MERCHANT_ID}
    Fetch Merchant Id
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .merchant_name.en    ${MERCHANT_NAME_EN_RAND}
    
    Post Update True Money Status    ${TEST_DATA_MERCHANT_ID}    { "status": "reject", "remark" : "robot reject" }
    Response Correct Code    ${SUCCESS_CODE}
    Post Update True You Status    ${TEST_DATA_MERCHANT_ID}    { "status": "reject", "remark" : "robot reject" }
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_10333 
    [Documentation]   Verification 'Update merchant' API
    [Tags]    Regression    Smoke
    Prepare Body For Update Merchant
    Put Api Update Merchant     ${body}    ${endpoint}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With String Value    data.success  