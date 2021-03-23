*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/summary_reports/summary_report_locators.robot

*** Variables ***
${dashboard_title}                 เลือกรายการ
${settlement_title}                สรุปยอดรายวัน (Settlement)
${password}                        1234

*** Keywords ***
Prepare TruePoint Data
    [Arguments]    ${thai_id}         ${amount}
    Tap On Activate First Button
    Enter The Activation Code And Password     ${ACTIVATION_CODE_IOS}     ${ACTIVATION_CODE_ANDROID}      ${ACTIVATION_PASSWORD}
    Tap On Check TruePoint
    Submit TruePoint By ThaiId        ${thai_id}       ${amount}
    ${trace_no}=    Get Text    &{settlement_screen}[lbl_trace_no]
    Set Test Variable    ${trace_no}
    Tap On Print Receipt
    Wait Until Page Contains          ${dashboard_title}

Back To Dashboard
    Wait Until Element Is Visible       &{settlement_screen}[btn_print_summary]
    Click Element    &{settlement_screen}[btn_print_summary]
    Wait Until Page Contains          ${dashboard_title}
    Page Should Contain Property With Value   ${dashboard_title}

View Settlement Report
    Run Keyword If    '${OS}' == 'IOS'                Click On Go Button    &{keyboard}[btn_go]
    Wait Until Element Is Visible       &{dashboard}[lbl_reports]
    Click Element       &{dashboard}[lbl_reports]
    Wait Until Element Is Visible       &{report_menu}[btn_settlement_report]
    Click Element       &{report_menu}[btn_settlement_report]
    Input Text          &{report_menu}[txt_password]        ${password}
    Click Element       &{report_menu}[btn_password_submit]
    Wait Until Page Contains            ${settlement_title}
    ${all_points_value}=    Get Text    &{settlement_screen}[lbl_all_points_value]
    ${baht_value}=    Get Text          &{settlement_screen}[lbl_baht_value]
    Set Test Variable    ${all_points_value}
    Set Test Variable    ${baht_value}

View Print Summary Report
    Click Element    &{settlement_screen}[btn_settlement_report]
    Wait Until Element Is Visible       &{settlement_screen}[btn_dialog_submit]
    Click Element    &{settlement_screen}[btn_dialog_submit]
    Sleep            ${MEDIUM_WAIT_TIME}

Get Current Summary Report Value
    Run Keyword If    '${OS}' == 'IOS'                Click On Go Button    &{keyboard}[btn_go]
    Wait Until Element Is Visible       &{dashboard}[lbl_reports]
    Click Element    &{dashboard}[lbl_reports]
    Click Element    &{report_menu}[btn_summary_report]
    ${truepoint_number}=    Get Text    &{summary_screen}[lbl_total_point]
    ${total_bath}=    Get Text    &{summary_screen}[lbl_total_baht]
    Set Test Variable    ${truepoint_number}
    Set Test Variable    ${total_bath}
    Click Element   &{summary_screen}[btn_back]
    Click Element   &{summary_screen}[btn_back]

Submit New TruePoint
    [Arguments]    ${thai_id}         ${amount}
    Tap On Check TruePoint
    Submit TruePoint By ThaiId        ${thai_id}       ${amount}
    ${trace_no}=    Get Text    &{settlement_screen}[lbl_trace_no]
    Set Test Variable    ${trace_no}
    Set Test Variable    ${amount}
    Tap On Print Receipt
    Wait Until Page Contains          ${dashboard_title}

View Summary Report
    Wait Until Element Is Visible         &{dashboard}[lbl_reports]
    ${new_truepoint_number} =	Evaluate    ${truepoint_number}+1
    ${new_truepoint_number}=          Convert to string    ${new_truepoint_number}
    ${new_total_baht}=    Set Variable     ${total_bath}
    ${new_total_baht}=    Remove String    ${new_total_baht}   ,
    ${new_total_baht}=	  Evaluate         ${new_total_baht}+${amount_number}
    ${new_total_baht}=    Set Variable     ${new_total_baht}
    ${new_total_baht}=    Evaluate     "{:,}".format($new_total_baht)
    ${new_total_baht}=          Convert to string    ${new_total_baht}0
    Set Test Variable    ${new_truepoint_number}
    Set Test Variable    ${new_total_baht}
    Click Element    &{dashboard}[lbl_reports]
    Click Element    &{report_menu}[btn_summary_report]

Clean Up Summary Reports
    Click Element   &{summary_screen}[btn_back]
    Click Element   &{summary_screen}[btn_back]
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
