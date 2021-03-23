*** Settings ***
Resource    ../../../resources/locators/retail_admin_portal/merchant_management/merchant_list_page.robot
Resource    ../common/common_keywords.robot

*** Keywords ***
Search Merchant By Propety And Value
    [Arguments]    ${search_by}    ${search_value}
    Wait Until Loading Pane Is Disappear
    ${locator_name}=    Convert To Lower Case  ${search_by}
    ${locator_name}=    Replace String    ${locator_name}    ${SPACE}    _
#    Click Visible Element    ${popup_status}
    run keyword and continue on failure    Wait Until Page Does Not Contain    No Data Available    timeout=20s
    Wait Until Element Is Visible    ${search_value_id}    10s
    Click Visible Element    ${search_value_id}
    Input Text Into Visible Element    ${search_value_id}    ${search_value}
    Input Text Into Visible Element    ${ddl_search_by}    ${search_by}
    Click Visible Element    ${ddl_search_by_${locator_name}}
    Click Visible Element    ${btn_search}
    #Wait search result
    ${th_search}=    run keyword and return status    Wait Until Keyword Succeeds    7    2    Expected Found Data After Search    ${txt_admin_portal_merchant_name_th}    ${search_value}
    run keyword if  ${th_search} == ${False}    Wait Until Keyword Succeeds    7    2    Expected Found Data After Search    ${txt_admin_portal_merchant_name_en}    ${search_value}

Click Approve Link
    Wait Until Loading Pane Is Disappear
    Click Visible Element    ${lnk_approve}