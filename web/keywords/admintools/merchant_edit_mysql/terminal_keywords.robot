*** Settings ***
Resource    ../../../resources/locators/admintools/merchant_edit_mysql/terminal_locators.robot

*** Keywords ***
Search Terminal
    [Arguments]    ${device}
    Select Dropwdown List By Value    ${drd_search_device}    ${device}
    Click Visible Element    ${btn_search}
    
Get Devices On Terminal Table
    ${device_list}=    Get Elements Text    ${tbl_device_column}
    [Return]    ${device_list}
    
Fetch Devices List On Page
    ${TEST_DEVICES_ON_TERMINAL_TABLE}=    Get Devices On Terminal Table
    Set Test Variable    ${TEST_DEVICES_ON_TERMINAL_TABLE}
    
Verify Search Feature Works Correctly
    ${devices_list_after_search}=    Get Devices On Terminal Table
    Should Not Be Equal    ${TEST_DEVICES_ON_TERMINAL_TABLE}    ${devices_list_after_search}    
    
Clear Search
    Click Visible Element    ${btn_clear}
    
Verify Clear Search Feature Works Correctly
    ${devices_list_after_clear}=    Get Devices On Terminal Table
    Should Be Equal    ${TEST_DEVICES_ON_TERMINAL_TABLE}    ${devices_list_after_clear}