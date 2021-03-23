*** Settings ***
Resource    ../../../resources/init.robot
Resource        ../../../keywords/rpp_merchant_bs/login_keywords.robot
Resource        ../../../keywords/rpp_merchant_bs/rpp_merchant_bs_keywords.robot
Resource    ../../../keywords/rpp_merchant_bs/merchant_keywords.robot
Resource    ../../../keywords/rpp_merchant/merchant_resource_keywords.robot

Test Setup      Generate Merchant Bs Header    ${RPP_AUTOMATE_SALE_USER}    ${RPP_AUTOMATE_SALE_PASSWORD}
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_23645
    [Documentation]   [Upstreaming Integration][RPP-Merchant-bs-api][Config] Get data Config success with https://am-rpp-alpha.eggdigital.com/merchant-bs-api/v1/config
    [Tags]    address-api    crm-ms-address-api    rpp-merchant-bs-api    Smoke
    Get Config
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    Response Should Contain All Property Values Are Number String    .district..PROVINCE_ID
    Response Should Contain All Property Values Are Number String    .district..DISTRICT_ID
    Response Should Contain All Property Values Are Number String    .province..PROVINCE_ID
    Response Should Contain All Property Values Are Number String    .province..PROVINCE_ID
    Response Should Contain All Property Values Are Number String    .subdistrict..DISTRICT_ID
    Response Should Contain All Property Values Are Number String    .subdistrict..SUBDISTRICT_ID
    Response Should Contain All Property Values Are Number String    .subdistrict..POST_CODE

    Get Config Private
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    Response Should Contain All Property Values Are Number String    .district..PROVINCE_ID
    Response Should Contain All Property Values Are Number String    .district..DISTRICT_ID
    Response Should Contain All Property Values Are Number String    .province..PROVINCE_ID
    Response Should Contain All Property Values Are Number String    .province..PROVINCE_ID
    Response Should Contain All Property Values Are Number String    .subdistrict..DISTRICT_ID
    Response Should Contain All Property Values Are Number String    .subdistrict..SUBDISTRICT_ID
    Response Should Contain All Property Values Are Number String    .subdistrict..POST_CODE

    Get User Profile
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success    

    Get Check User
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    
    Get Sale Code User
    Response Property Should Be Equal As String    status.text    Success