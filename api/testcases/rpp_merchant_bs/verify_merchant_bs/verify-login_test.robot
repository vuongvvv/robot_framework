*** Settings ***
Resource    ../../../resources/init.robot
Resource        ../../../keywords/rpp_merchant_bs/login_keywords.robot
Resource        ../../../keywords/common/rpp_gateway_common.robot
Test Setup      Create RPP Gateway Header
Test Teardown    Delete All Sessions        

*** Test Cases ***
TC_O2O_10328  
    [Documentation]   Verification 'User Login' API by all data are correct
    [Tags]    Regression    Smoke    Sanity        
    Post Api Login     { "username":"${RPP_AUTOMATE_SALE_USER}", "password":"${RPP_AUTOMATE_SALE_PASSWORD}", "user_type":"sale" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With Value    data.username    ${RPP_AUTOMATE_SALE_USER}
    Response Should Contain Property With Value    data.content_type    sale
    Response Should Contain Property With String Value    data.accessToken

TC_O2O_10329
    [Documentation]   Verification 'User Login' API by some data is wrong
    [Tags]    Regression    Smoke    
    Post Api Login     { "username":"egg33", "password":"1234", "user_type":"sale" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    status.code    ${400}
    Response Should Contain Property With Value    status.message    Bad Request
    Response Should Contain Property With Value    error.message    กรุณากรอกชื่อผู้ใช้งานและรหัสผ่านให้ถูกต้อง
