*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/void_transaction/void_transaction_locators.robot
Resource    ../../../resources/locators/tsm/dashboard_screen/dashboard_option_locators.robot

*** Variables ***
${dashboard_title}                 เลือกรายการ
${password}                        1234

*** Keywords ***
Check Void Transaction
    [Arguments]       ${trace_no}
    Run Keyword If    '${OS}' == 'android'       Swipe Up
    Run Keyword If    '${OS}' == 'ios'                Click On Go Button    &{keyboard}[btn_go]
    Sleep             ${MEDIUM_WAIT_TIME}
    Click Element     &{dashboard}[lbl_void]
    Input Text        &{void_screen}[lbl_password]        ${password}
    Click Element     &{void_screen}[btn_submit_password]
    Input Text        &{void_screen}[lbl_trace_number]        ${trace_no}
    Click Element     &{void_screen}[btn_confirm]
    Sleep             ${MEDIUM_WAIT_TIME}

Close Void Screen
    Wait Until Element Is Visible       &{void_screen}[btn_submit]
    Click Element    &{void_screen}[btn_submit]
    Tap On Print Receipt

Clean Up Void Data
    Wait Until Element Is Visible       &{dashboard}[lbl_reports]
    Click Element       &{dashboard}[lbl_reports]
    Click Element       &{report_menu}[btn_settlement_report]
    Input Text          &{report_menu}[txt_password]        ${password}
    Click Element       &{report_menu}[btn_password_submit]
    Wait Until Page Contains            ${settlement_title}
    Click Element    &{settlement_screen}[btn_settlement_report]
    Wait Until Element Is Visible       &{settlement_screen}[btn_dialog_submit]
    Click Element    &{settlement_screen}[btn_dialog_submit]
    Wait Until Element Is Visible       &{settlement_screen}[btn_back_home]
    Click Element    &{settlement_screen}[btn_back_home]
    Wait Until Page Contains          ${dashboard_title}
