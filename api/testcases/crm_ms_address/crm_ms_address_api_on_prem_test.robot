*** Settings ***
Documentation    Tests to verify that getAccount api works correctly

Resource    ../../resources/init.robot
Resource    ../../keywords/common/rpp_common.robot
Resource    ../../keywords/crm_ms_address/crm_ms_address_api_keywords.robot

Test Setup    Create RPP Header
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_22966
    [Documentation]     [crm-ms-address-api] Request with "crm-ms-address-api" APIs through "https://am-rpp-alpha.eggdigital.com" return 200
    [Tags]      Regression     High    Smoke
    Get Province
    Fetch Province Id
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    Response Should Contain All Property Values Are String    data..PROVINCE_ID
    
    Get District
    Fetch District Id
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    Response Should Contain All Property Values Are String    data..DISTRICT_ID
    
    Get Sub District    district_id=${TEST_DATA_DISTRICT_ID}
    Fetch Sub District Id
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .DISTRICT_ID    ${TEST_DATA_DISTRICT_ID}
    
    Get Address
    Fetch Address Id
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    
    Get Address By Id    address_id=${TEST_DATA_ADDRESS_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    Response Property Should Be Equal As String    data..ID    ${TEST_DATA_ADDRESS_ID}
    
    Get Address Detail    address_id=${TEST_DATA_ADDRESS_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    Response Property Should Be Equal As String    data..ID    ${TEST_DATA_ADDRESS_ID}
    
    Post Create Address    { "province_id": ${TEST_DATA_PROVINCE_ID}, "district_id": ${TEST_DATA_DISTRICT_ID}, "subdistrict_id": ${TEST_DATA_SUB_DISTRICT_ID}, "content_type": "robot automation", "content_id": "123456789", "type": "robotautomationtest" }
    Fetch Created Address Id
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    Response Property Should Be Equal As String    data    ${TEST_DATA_CREATED_ADDRESS_ID}
    
    Post Update Address    { "address_id": ${TEST_DATA_CREATED_ADDRESS_ID}, "province_id": ${TEST_DATA_PROVINCE_ID}, "district_id": ${TEST_DATA_DISTRICT_ID}, "subdistrict_id": ${TEST_DATA_SUB_DISTRICT_ID}, "content_type": "robot automation edit", "type": "robotautomationtestedit", "content_id": "123456789 edit" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    Response Property Should Be Equal As String    data    ${TEST_DATA_CREATED_ADDRESS_ID}
    
    Delete Address    address_id=${TEST_DATA_CREATED_ADDRESS_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status.text    Success
    Response Property Should Be Equal As String    data    ${TEST_DATA_CREATED_ADDRESS_ID}