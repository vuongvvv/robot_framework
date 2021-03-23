*** Settings ***
Resource    ../../../resources/init.robot
Resource    ../../../keywords/rpp_merchant_bs/login_keywords.robot
Resource        ../../../keywords/rpp_merchant_bs/product_keywords.robot
Test Setup    Generate Merchant Bs Header    ${RPP_AUTOMATE_SALE_USER}    ${RPP_AUTOMATE_SALE_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
&{valid_card_and_phone}    card_no=1309900877760    truemoveh=0851053395
&{valid_card_and_invalid_phone}    card_no=1309900877760    truemoveh=0634474265
&{invalid_card_and_valid_phone}    card_no=1099640087776    truemoveh=0851053395

*** Test Cases ***
TC_O2O_10335
    [Documentation]   Verification 'Check product' API by inputting data correctly
    [Tags]    Regression    Smoke    ASCO2O-22624
    Get Api Check Product    ${valid_card_and_phone}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With Value    data.status    success
    Response Should Contain Property With Value    data.message    หมายเลขสินค้าและบริการเข้าเงื่อนไขทรู รายเดือน 599 กรุณายืนยันเพื่อเข้าร่วมโครงการ

TC_O2O_10336
    [Documentation]   Verification 'Check product' API by inputting data invalid truemoveh
    [Tags]    Regression    Smoke    ASCO2O-22624
    Get Api Check Product    ${valid_card_and_invalid_phone}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With Value    data.status    fail
    Response Should Contain Property With Value    data.message    หมายเลขสินค้าและบริการไม่มีในระบบ กรุณาตรวจสอบเบอร์โทรศัพท์อีกครั้ง

TC_O2O_10337
    [Documentation]   Verification 'Check product' API by inputting data invalid cardNo
    [Tags]    Regression    Smoke    ASCO2O-22624
    Get Api Check Product    ${invalid_card_and_valid_phone}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With Value    data.status    fail
    Response Should Contain Property With Value    data.message     หมายเลขบัตรประชาชนของท่านไม่มีในระบบ${SPACE*2}กรุณาตรวจสอบชื่อ,${SPACE}เลขบัตรประชาชน${SPACE}ของผู้จดทะเบียนสินค้าและบริการที่ใช้อ้างอิง${SPACE}ให้ตรงกับชื่อเจ้าของกิจการ