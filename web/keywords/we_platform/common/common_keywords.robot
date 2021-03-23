*** Settings ***
Resource    ../../../../web/keywords/common/locator_common.robot
Resource    ../../../../web/resources/locators/we_platform/common/common_locators.robot

*** Keywords ***
Navigate To Main Menu And Sub Main Menu
    [Arguments]    ${main_menu_name}    ${sub_menu_name}
    ${main_menu_locator}=    Generate Element From Dynamic Locator    ${lnk_main_menu_weplatform}    ${main_menu_name}
    ${sub_menu_locator}=    Generate Element From Dynamic Locator    ${lnk_sub_menu_weplatform}    ${sub_menu_name}
    Click Visible Element    ${main_menu_locator}
    Click Visible Element    ${sub_menu_locator}

Navigate To Left Menu
    [Arguments]    ${left_main_menu_name}   ${left_sub_menu_name}=${empty}   
    ${left_main_menu_locator}=    Generate Element From Dynamic Locator    ${lnk_left_main_menu}   ${left_main_menu_name}
    ${left_sub_menu_locator}=     Generate Element From Dynamic Locator    ${lnk_left_sub_menu}    ${left_sub_menu_name}
    Wait Until Element Is Enabled    ${left_main_menu_locator}    5
    Click Visible Element    ${left_main_menu_locator}
    Run Keyword If   '${left_sub_menu_name}' != '${empty}'   Wait Until Keyword Succeeds    5s    0.5s   Click Element  ${left_sub_menu_locator}

Get Id From URL
    [Arguments]    ${id_type_from_url}
    #This keyword will get id value from URL between '${id_type_from_url}/' and '/view' characters
    ${id_from_url}=    Get Value From URL By Regexp    (?<=${id_type_from_url}\/)(.*)(?=\/view)
    Set Test Variable    ${ID_FROM_URL}    ${id_from_url}[0]

Get Information From Property
    [Arguments]    ${content_property}
    #${content_property} should be case sensitive same with UI
    ${spn_information_locator} =    Generate Element From Dynamic Locator    ${spn_property_information}    ${content_property}
    Wait Until Element Is Enabled    ${spn_information_locator}    5
    ${value} =    Get Text    ${spn_information_locator}
    Set Test Variable    ${INFORMATION_GOT_FROM_PROPERTY}    ${value}

Verify Text Alert Message On Popup
    [Arguments]    ${alert_text}
    Set Ignore Implicit Angular Wait    ${True}
    ${lbl_popup_alert_locator}=   Generate Element From Dynamic Locator   ${lbl_popup_alert}    ${alert_text}
    Run Keyword And Ignore Error    Verify Element Is Visible   ${lbl_popup_alert_locator}
    Set Ignore Implicit Angular Wait    ${False}