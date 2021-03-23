*** Settings ***
Resource    ../../../resources/locators/admintools/notification-producer/histories_locators.robot
Resource    ../../common/locator_common.robot

*** Keywords ***
Click View Button On Row
    [Arguments]    ${row_number}
    ${locator}=    Generate Element From Dynamic Locator    ${btn_view_histories_table}    ${row_number}
    Wait Until Element Is Visible    ${locator}
    Click Element    ${locator}
    
Search Histories
    [Arguments]    ${sender_name}=${None}
    Run Keyword If    '${sender_name}'!='${None}'    Input Text Into Search Field    Sender Name    ${sender_name}
    Click Visible Element    ${btn_search}
    # wait for search results to be displayed on Histories table
    Sleep    1s
    
Input Text Into Search Field
    [Arguments]    ${label}    ${input_text}
    ${search_element}    Generate Element From Dynamic Locator    ${txt_search_field_by_label}    ${label}
    Input Text Into Visible Element    ${search_element}    ${input_text}