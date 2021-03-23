*** Settings ***
Documentation    RPP Merchant Migration to the O2O platform
...    https://truemoney.atlassian.net/browse/O2O-2934

Resource    ../../../resources/init.robot
Resource    ../../../keywords/rpp_merchant/merchant_registration_resource_keywords.robot
Resource    ../../../keywords/rpp_merchant_bs/login_keywords.robot
Resource    ../../../keywords/rpp_merchant_bs/merchant_keywords.robot

Test Setup    Generate Robot Automation Header    ${RPP_MERCHANT_USERNAME}    ${RPP_MERCHANT_PASSWORD}
Test Teardown    Delete All Sessions

*** Test Cases ***
rpp_merchant_migration_to_o2o_platform
    [Documentation]     https://truemoney.atlassian.net/browse/ASCO2O-25009
    [Tags]    Regression    Smoke     High    rpp-master-merchant
    Get All Merchant Registrations Raw    qr_type=39
    Fetch Property From Response    .id    QR_TAG39_MERCHANT_MONGO_ID
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .qr_type    39

    # https://truemoney.atlassian.net/browse/ASCO2O-25539
    Get Merchant Registrations Raw    ${QR_TAG39_MERCHANT_MONGO_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${QR_TAG39_MERCHANT_MONGO_ID}
    
    # https://truemoney.atlassian.net/browse/ASCO2O-25765
    Get All Merchant Registrations    qrType=39
    Fetch Property From Response With Exclusion Value    .id    QR_TAG39_MERCHANT_MONGO_ID
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .qr_type    39
    
    # https://truemoney.atlassian.net/browse/ASCO2O-25540
    Get Merchant Registration    ${QR_TAG39_MERCHANT_MONGO_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${QR_TAG39_MERCHANT_MONGO_ID}
    
    Get All Merchant Registrations Raw    qr_type=29&sort=id,desc
    Fetch Property From Response    .id    QR_TAG29_MERCHANT_MONGO_ID
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property    .qr_type
    
    # https://truemoney.atlassian.net/browse/ASCO2O-25539
    Get Merchant Registrations Raw    ${QR_TAG29_MERCHANT_MONGO_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${QR_TAG29_MERCHANT_MONGO_ID}
    
    # https://truemoney.atlassian.net/browse/ASCO2O-25765
    Get All Merchant Registrations    qrType=29
    Fetch Property From Response With Exclusion Value    .id    QR_TAG29_MERCHANT_MONGO_ID    return_index=1
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property    .qr_type
    
    # https://truemoney.atlassian.net/browse/ASCO2O-25540
    Get Merchant Registration    ${QR_TAG29_MERCHANT_MONGO_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${QR_TAG29_MERCHANT_MONGO_ID}
    
    # https://truemoney.atlassian.net/browse/ASCO2O-25009
    Get All Merchant Registrations Raw    qr_type=29&qr_type=39
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String Or Null    .id
    
    # https://truemoney.atlassian.net/browse/ASCO2O-25540
    Get All Merchant Registrations    qrType=29&qrType=39
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String Or Null    .id

    # https://truemoney.atlassian.net/browse/ASCO2O-25428
    Generate Merchant Bs Header    ${RPP_AUTOMATE_SALE_USER}    ${RPP_AUTOMATE_SALE_PASSWORD}
    Get Merchant Status    id=${QR_TAG39_MERCHANT_MONGO_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    data..id    ${QR_TAG39_MERCHANT_MONGO_ID}
    Get Merchant Status    id=${QR_TAG29_MERCHANT_MONGO_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    data..id    ${QR_TAG29_MERCHANT_MONGO_ID}