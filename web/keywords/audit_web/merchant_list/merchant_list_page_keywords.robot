*** Settings ***
Resource    ../../../../web/resources/locators/audit_web/merchant_list/merchant_list_page_locators.robot
Resource    ../../../../web/keywords/common/locator_common.robot

*** Keywords ***
Search Need To Operate Stores
    [Arguments]    ${search_property}=${None}    ${search_data}=${None}    ${search_status}=${None}
    Wait Element Is Visible    ${ddl_search_property}
    Run Keyword If    '${search_property}'!='${None}'    Select Dropwdown List By Label    ${ddl_search_property}    ${search_property}
    Run Keyword If    '${search_data}'!='${None}'    Input Text Into Visible Element    ${txt_search_value}    ${search_data}
    Run Keyword If    '${search_status}'!='${None}'    Select Dropwdown List By Label    ${ddl_search_status}    ${search_status}
    Click Visible Element    ${btn_searching}

Search QR Code Merchants
    [Arguments]    ${search_property}=${None}    ${search_data}=${None}    ${search_status}=${None}    ${search_start_date}=${None}    ${search_end_date}=${None}
    Run Keyword If    '${search_property}'!='${None}'    Select Dropwdown List By Label    ${ddl_search_property}    ${search_property}
    Run Keyword If    '${search_data}'!='${None}'    Input Text Into Visible Element    ${txt_search_value}    ${search_data}
    Run Keyword If    '${search_status}'!='${None}'    Select Dropwdown List By Label    ${ddl_search_status}    ${search_status}
    Run Keyword If    '${search_start_date}'!='${None}'    Input Text Into Visible Element    ${txt_search_start_date}    ${search_start_date}
    Run Keyword If    '${search_end_date}'!='${None}'    Input Text Into Visible Element    ${txt_search_end_date}    ${search_end_date}
    Click Visible Element    ${btn_searching}
    
Add Delivery Status Information
    [Arguments]    ${status}    ${action_by}    ${expected_delivery_status}
    Select Dropwdown List By Label    ${ddl_status}    ${status}
    Select Dropwdown List By Label    ${ddl_action_by}    ${action_by}
    Click Visible Element    ${btn_save}
    Handle Alert Popup    timeout=10s    validation=verify
    Click Visible Element    ${icn_exit_modal}

Click Magnifier Icon On Top Of Search Result
    Wait Element Is Visible    ${icn_magnifier_of_top_search_result}
    Click Visible Element    ${icn_magnifier_of_top_search_result}

Click Pencil Icon On Top Of Search Result
    [Arguments]    ${merchant_name_in_thai}
    ${ico_element}    Generate Element From Dynamic Locator    ${ico_pencial_by_merchant_mongo_id}    ${merchant_name_in_thai}
    Wait Element Is Visible    ${ico_element}    20s
    Scroll Element Into View    ${ico_element}
    Click Visible Element    ${ico_element}