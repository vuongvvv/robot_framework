*** Settings ***
Resource    ../../../resources/locators/admintools/import_brand/import_brand_outlet_terminal_locators.robot

*** Keywords ***
Search Reports
    [Arguments]    ${status}
    Select Dropwdown List By Value    ${drd_search_status}    ${status}
    Click Visible Element    ${btn_search}
    
Get Status On Report Table
    ${status_list}=    Get Elements Text    ${tbl_status_column}
    [Return]    ${status_list}
    
Fetch Status On Page
    ${TEST_STATUS_ON_REPORT_TABLE}=    Get Status On Report Table
    Set Test Variable    ${TEST_STATUS_ON_REPORT_TABLE}
    
Verify Search Feature Works Correctly
    ${status_list_after_search}=    Get Status On Report Table
    Should Not Be Equal    ${TEST_STATUS_ON_REPORT_TABLE}    ${status_list_after_search}    
    
Clear Search
    Click Visible Element    ${btn_clear}
    
Verify Clear Search Feature Works Correctly
    ${status_list_after_clear}=    Get Status On Report Table
    Should Be Equal    ${TEST_STATUS_ON_REPORT_TABLE}    ${status_list_after_clear}