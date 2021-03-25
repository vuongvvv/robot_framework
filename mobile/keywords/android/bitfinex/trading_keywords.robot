*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/trading_locators.robot
Resource    ../../../../utility/common/locator_common.robot
Resource    ../../../../utility/common/list_common.robot
Resource    ../../common/mobile_common.robot

*** Keywords ***
Verify Tickers
    Wait Element Is Visible    ${btn_collapse_tickers}
    Wait Element Is Visible    ${txt_search_tickers}
    Wait Element Is Visible    ${ddl_filter_tickers}
    Wait Element Is Visible    ${tab_starred_tickers}
    Wait Element Is Visible    ${tab_all_tickers}

Click Collapse Ticker
    [Arguments]    ${times_to_click}=1
    Click Visible Element    ${btn_collapse_tickers}    2s    ${times_to_click}
    
Verify Tickers Disappear
    Wait Element Disappear    ${txt_search_tickers}
    Wait Element Disappear    ${ddl_filter_tickers}
    Wait Element Disappear    ${tab_starred_tickers}
    Wait Element Disappear    ${tab_all_tickers}
    
Select Starred Tab
    Click Visible Element    ${tab_starred_tickers}
    
Verify Tickers Table Has No Data
    Wait Element Is Visible    ${lbl_no_tickers_found}
    
Select All Tab
    Click Visible Element    ${tab_all_tickers}
    
Click Tickers Table Column Header
    [Arguments]    ${header_name}
    ${locator_column_header}    Generate Element From Dynamic Locator    ${lbl_tickers_table_column_by_name}    ${header_name}
    Wait Element Is Visible    ${locator_column_header}    
    Click Visible Element    ${locator_column_header}
    
Verify Column Data Sorting By Screenshot
    [Arguments]    ${header_name}    ${sort_order}
    Sleep    1s
    Capture Screen    VERIFY_${header_name}_COLUMN_IS_SORTED_${sort_order}
    Log    VERIFY_${header_name}_COLUMN_IS_SORTED_${sort_order}    WARN
    
Search Ticker
    [Arguments]    ${ticker}
    Input Text Into Element    ${txt_search_tickers}    ${ticker}
    
Clear Ticker Search
    Click Visible Element    ${btn_clear_search_tickers}
    
Verify Filter Ticker By Screenshot
    [Arguments]    ${message}
    Verify By Screenshot    ${message}