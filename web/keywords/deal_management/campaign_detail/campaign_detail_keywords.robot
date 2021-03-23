*** Settings ***
Resource    ../../../resources/locators/deal_management/campaign_detail/campaign_detail_page.robot
Resource    ../common/common_keywords.robot

*** Keywords ***
Input Test Data Campaign Details Popup
    [Arguments]    ${campaign_name}    ${food_type}    ${campaign_status}    ${lot}    ${coverage_area}
    Wait Until Progress Bar Is Disappear
    Select Campaign Name On Campaign Detail Popup    ${campaign_name}
    Select Food Type On Campaign Detail Popup    ${food_type}
    Select Campaign Status On Campaign Detail Popup    ${campaign_status}
    Wait Until Block Message Bar Is Disappear
    Select Coverage Area On Campaign Detail Popup    ${coverage_area}
    Select Lot On Campaign Detail Popup    ${lot}
    Click Button    Save
    Wait Until Progress Bar Is Disappear

Select Campaign Name On Campaign Detail Popup
    [Arguments]    ${campaign_name}
    Click Element    ${btn_campaign_name}
    ${lbl_campaign_name} =    Generate Element From Dynamic Locator    ${lbl_dropdown_item}    ${campaign_name}
    Click Element    ${lbl_campaign_name}

Select Food Type On Campaign Detail Popup
    [Arguments]    ${food_type}
    Click Element    ${btn_food_type}
    ${lbl_dropdown_item} =    Generate Element From Dynamic Locator    ${lbl_dropdown_item}    ${food_type}
    Click Element    ${lbl_dropdown_item}

Select Campaign Status On Campaign Detail Popup
    [Arguments]    ${campaign_status}
    Click Element    ${btn_campaign_status}
    ${lbl_dropdown_item} =    Generate Element From Dynamic Locator    ${lbl_dropdown_item}    ${campaign_status}
    Click Element    ${lbl_dropdown_item}

Select Lot On Campaign Detail Popup
    [Arguments]    ${lot}
    Click Element    ${btn_lot}
    ${lbl_dropdown_item} =    Generate Element From Dynamic Locator    ${lbl_dropdown_item}    ${lot}
    Wait Until Element Is Visible    ${lbl_dropdown_item}
    Click Element    ${lbl_dropdown_item}

Select Coverage Area On Campaign Detail Popup
    [Arguments]    ${coverage_area}
    Click Element    ${btn_coverage_area}
    ${lbl_dropdown_item} =    Generate Element From Dynamic Locator    ${lbl_dropdown_item}    ${coverage_area}
    Click Element    ${lbl_dropdown_item}