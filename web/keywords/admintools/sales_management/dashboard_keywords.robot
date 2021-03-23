*** Settings ***
Resource    ../../../resources/locators/admintools/sales_management/dashboard_locators.robot

*** Keywords ***
Search Sales History
    [Arguments]    ${status}
    Select Dropwdown List By Value    ${drd_search_status}    ${status}
    Click Visible Element    ${btn_search}
    
Get Total Items
    ${total_items}=    Get Element Text    ${lbl_items_on_page}
    [Return]    ${total_items}
    
Fetch Total Items On Page
    ${TEST_TOTAL_ITEMS}=    Get Total Items
    Set Test Variable    ${TEST_TOTAL_ITEMS}
    
Verify Search Feature Works Correctly
    ${total_items_after_search}=    Get Total Items
    Should Not Be Equal    ${TEST_TOTAL_ITEMS}    ${total_items_after_search}
    
Clear Search
    Click Visible Element    ${btn_clear}
    
Verify Clear Search Feature Works Correctly
    ${total_items_after_clear}=    Get Total Items
    Should Be Equal    ${TEST_TOTAL_ITEMS}    ${total_items_after_clear}