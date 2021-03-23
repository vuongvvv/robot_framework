*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/customer_status/customer_status_locators.robot
Resource    ../../../resources/locators/tsm/dashboard_screen/dashboard_option_locators.robot

*** Variables ***
${dashboard_screen_label}      เลือกรายการ

*** Keywords ***
Tap On Check Customer Status
    Wait Until Element Is Visible         &{dashboard}[lbl_check_customer_status]
    Click Element    &{dashboard}[lbl_check_customer_status]

Submit Customer Status By ThaiId
    [Arguments]    ${thai_id}
    Wait Until Element Is Visible         &{circleRed}[btn_circle_thai_id]
    Click Element    &{circleRed}[btn_circle_thai_id]
    Wait Until Element Is Visible        &{verify_trueid}[txt_thai_id]
    Input Text      &{verify_trueid}[txt_thai_id]    ${thai_id}
    Click Element   &{verify_trueid}[btn_submit_thai_id]
    Wait Until Element Is Visible         &{summary_result}[btn_back_dashboard]

Submit Customer Status By TrueCard
    [Arguments]    ${truecard_id}
    Wait Until Element Is Visible         &{circleRed}[btn_circle_true_card]
    Click Element    &{circleRed}[btn_circle_true_card]
    Wait Until Element Is Visible        &{verify_true_card}[txt_true_card_id]
    Input Text      &{verify_true_card}[txt_true_card_id]     ${truecard_id}
    Click Element    &{verify_true_card}[btn_submit_true_card]
    Wait Until Element Is Visible         &{summary_result}[btn_back_dashboard]

Back To Dashboard Screen
    Wait Until Element Is Visible         &{summary_result}[btn_back_dashboard]
    Click Element    &{summary_result}[btn_back_dashboard]
    Wait Until Page Contains        ${dashboard_screen_label}
    Page Should Contain Property With Value    ${dashboard_screen_label}
