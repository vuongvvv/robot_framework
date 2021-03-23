*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/feature_truepoints/feature_truepoints_locators.robot
Resource    ../../../resources/locators/tsm/dashboard_screen/dashboard_option_locators.robot

*** Variables ***
${dashboard_screen_label}      เลือกรายการ
${print_screen_label_first}    ส่งการยืนยันเสร็จสมบูรณ์
${print_screen_label_second_android}   ระบบได้จัดส่งการยืนยันการใช้สิทธิ์
${print_screen_label_second_ios}       ระบบได้จัดส่งการยืนยันการรับสิทธิ์ไปยัง
${print_screen_label_third_android}    SMS : 0617822427
${print_screen_label_third_ios}        SMS: 0617822427

*** Keywords ***
Tap On Check TruePoint
    Wait Until Element Is Visible       &{dashboard}[lbl_true_points]
    Click Element    &{dashboard}[lbl_true_points]

Submit TruePoint By ThaiId
    [Arguments]    ${thai_id}   ${amount}
    Wait Until Element Is Visible      &{circleRed}[btn_circle_thai_id]
    Click Element    &{circleRed}[btn_circle_thai_id]
    Wait Until Element Is Visible      &{verify_trueid}[txt_thai_id]
    Input Text       &{verify_trueid}[txt_thai_id]    ${thai_id}
    Wait Until Element Is Visible      &{verify_trueid}[btn_submit_thai_id]
    Click Element    &{verify_trueid}[btn_submit_thai_id]
    Wait Until Element Is Visible      &{verify_trueid}[txt_amount]
    Input Text       &{verify_trueid}[txt_amount]       ${amount}
    Click Element    &{verify_trueid}[btn_confirm]
    Wait Until Element Is Visible         &{summary_result}[btn_back_dashboard]

Submit TruePoint By TrueCard
    [Arguments]    ${true_card_id}      ${amount}
    Wait Until Element Is Visible     &{circleRed}[btn_circle_true_card]
    Click Element    &{circleRed}[btn_circle_true_card]
    Wait Until Element Is Visible     &{verify_true_card}[txt_true_card_id]
    Input Text      &{verify_true_card}[txt_true_card_id]     ${true_card_id}
    Wait Until Element Is Visible     &{verify_true_card}[btn_submit_true_card]
    Click Element    &{verify_true_card}[btn_submit_true_card]
    Wait Until Element Is Visible     &{verify_true_card}[txt_amount]
    Input Text      &{verify_true_card}[txt_amount]       ${amount}
    Wait Until Element Is Visible      &{verify_true_card}[btn_confirm]
    Click Element    &{verify_true_card}[btn_confirm]
    Wait Until Element Is Visible         &{summary_result}[btn_back_dashboard]

Back To Dashboard Screen
    Wait Until Element Is Visible         &{summary_result}[btn_back_dashboard]
    Click Element    &{summary_result}[btn_back_dashboard]
    Wait Until Page Contains        ${dashboard_screen_label}
    Page Should Contain Property With Value   ${dashboard_screen_label}

Tap On Print Receipt
    Wait Until Element Is Visible         &{summary_result}[btn_print]
    Click Element    &{summary_result}[btn_print]
    Wait Until Element Is Visible         &{summary_result}[btn_finish_result]
    Page Should Contain Property With Value   ${print_screen_label_first}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value   ${print_screen_label_second_android}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value   ${print_screen_label_second_ios}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value   ${print_screen_label_third_android}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value   ${print_screen_label_third_ios}
    Click Element    &{summary_result}[btn_finish_result]
    Wait Until Page Contains        ${dashboard_screen_label}
    Page Should Contain Property With Value   ${dashboard_screen_label}
