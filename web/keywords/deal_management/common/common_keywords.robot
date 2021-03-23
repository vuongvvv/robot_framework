*** Settings ***
Resource    ../../../resources/locators/deal_management/common/common_locators.robot
Resource    ../../common/robot_browser_web_common.robot
*** Keywords ***
Login Deal Management
    [Arguments]    ${user_name}    ${password}
    Input Text Into Visible Element    ${txt_username}   ${username}
    Input Text Into Visible Element    ${txt_password}   ${password}
    Click Visible Element    ${btn_submit_login_true_you}

Navigate To Deal Management Menu
    [Arguments]    ${menu}    ${sub_menu}
    ${menu_locator}=    Generate Element From Dynamic Locator    ${mnu_menu_deal_management}    ${menu}
    Mouse Over    ${menu_locator}
    ${sub_menu_locator}=    Generate Element From Dynamic Locator    ${mnu_sub_menu_deal_management}    ${menu}    ${sub_menu}
    Click Visible Element    ${sub_menu_locator}

Click On Button
    [Arguments]    ${button_name}
    Click Button    ${button_name}

Wait Until Progress Bar Is Disappear
    Wait Until Element Is Disappear    ${bar_please_wait}

Wait Until Block Message Bar Is Disappear
    Wait Until Element Is Disappear    ${bar_block_page}
