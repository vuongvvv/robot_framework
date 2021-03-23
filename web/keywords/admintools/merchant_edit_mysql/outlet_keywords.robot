*** Settings ***
Resource    ../../../resources/locators/admintools/merchant_edit_mysql/outlet_locators.robot

Resource    ../../common/web_common.robot
*** Keywords ***
Search Outlet
    [Arguments]    ${status}
    Select Dropwdown List By Value    ${drd_search_merchant_status}    ${status}
    Click Visible Element    ${btn_search}
    
Get Status On Terminal Table
    ${status_list}=    Get Elements Text    ${tbl_status_column}
    [Return]    ${status_list}
    
Fetch Status List On Page
    ${TEST_STATUS_ON_OUTLET_TABLE}=    Get Status On Terminal Table
    Set Test Variable    ${TEST_STATUS_ON_OUTLET_TABLE}
    
Verify Search Feature Works Correctly
    ${status_list_after_search}=    Get Status On Terminal Table
    Should Not Be Equal    ${TEST_STATUS_ON_OUTLET_TABLE}    ${status_list_after_search}    
    
Clear Search
    Click Visible Element    ${btn_clear}
    
Verify Clear Search Feature Works Correctly
    ${devices_list_after_clear}=    Get Status On Terminal Table
    Should Be Equal    ${TEST_STATUS_ON_OUTLET_TABLE}    ${devices_list_after_clear}