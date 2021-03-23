*** Settings ***
Resource    ../../../resources/init.robot
Resource        ../../../keywords/rpp_merchant_bs/login_keywords.robot
Resource        ../../../keywords/rpp_merchant_bs/location_keyword.robot

Test Setup      Generate Merchant Bs Header    ${RPP_AUTOMATE_SALE_USER}    ${RPP_AUTOMATE_SALE_PASSWORD}
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_10334
    [Documentation]   Verification 'search location'
    [Tags]    Regression    Sanity    Smoke   
    Get Api Search Location
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain All Property Values Are String    data..merchant_id
    Response Should Contain All Property Values Are String    data..merchant_name.th
    Response Should Contain All Property Values Are String    data..merchant_name.en
    Response Should Contain Property Matches Regex    data..latitude    \\d+.\\d+
    Response Should Contain Property Matches Regex    data..longitude    \\d+.\\d+
    Response Should Contain All Property Values Are String   data..status