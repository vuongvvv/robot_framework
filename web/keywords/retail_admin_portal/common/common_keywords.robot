*** Settings ***
Resource    ../../../resources/locators/retail_admin_portal/common/common_locators.robot

*** Keywords ***
Login True Money Admin Portal
    [Arguments]    ${user_name}    ${password}
    Input Text Into Visible Element    username   ${username}
    Input Text Into Visible Element    password   ${password}
    Click Element    ${btn_sign_in_true_money_admin_portal}

Wait Until Loading Pane Is Disappear
    Wait Until Element Is Disappear    ${icn_loading_pane}

Navigate To True Money Admin Portal Menu
    [Arguments]    ${menu}    ${sub_menu}
    FOR    ${i}    IN RANGE    1    6
        ${name_header}=    run keyword and return status    Get Text    ${admin_portal_txt_header_locator}
        exit for loop if  ${name_header} == ${True}
        #add loading time with sleep
        sleep    1s
    END
    ${menu_locator}=    Generate Element From Dynamic Locator    ${mnu_menu_true_money_admin_portal}    ${menu}
    Wait Until Element Is Visible    ${menu_locator}    5s
    Click Element    ${menu_locator}
    Select Sub Menu in Admin Portal    ${sub_menu}

Select Sub Menu in Admin Portal
    [Arguments]    ${sub_menu}
    ${sub_menu_name}=    convert to lower case    ${sub_menu}
    ${expected_location}=    replace string    ${sub_menu_name}    ${SPACE}    _
    Click Visible Element    ${sub_menu_${expected_location}}

Expected Found Data After Search
    [Arguments]    ${xpath}    ${txt_expected}
    Wait Until Element Is Visible    ${xpath}    timeout=10s
    ${txt_actual}=    Get Text    ${xpath}
    should be equal as strings    ${txt_actual}    ${txt_expected}