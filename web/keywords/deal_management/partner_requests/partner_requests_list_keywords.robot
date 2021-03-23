*** Settings ***
Resource    ../../../resources/locators/deal_management/partner_requests/partner_requests_list_page.robot
Resource    ../common/common_keywords.robot

*** Keywords ***
Search Merchant From Textboxs
    [Arguments]    &{search_textboxs_and_values}
    FOR  ${search_textbox_name}    IN   @{search_textboxs_and_values.keys()}
        ${value} =    Set Variable     ${search_textboxs_and_values}[${search_textbox_name}]
        ${txt_search_locator} =    Generate Element From Dynamic Locator    ${txt_search}    ${search_textbox_name}
        Input Text    ${txt_search_locator}   ${value}
    END
    Click Button    ${btn_partner_requests_list_search}
    Wait Until Progress Bar Is Disappear

Click On Magnifier Icon
    Wait Until Progress Bar Is Disappear
    Click Element    ${btn_magnifier_icon}