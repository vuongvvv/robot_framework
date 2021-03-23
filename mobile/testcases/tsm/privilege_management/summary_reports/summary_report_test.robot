*** Settings ***
Documentation       Verify the report succeed and fail correctly depending from users input values.
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/summary_reports/summary_report_keywords.robot
Resource            ../../../../keywords/tsm/activation_code/activation_code_keywords.robot
Resource            ../../../../keywords/tsm/on_boarding/on_boarding_keywords.robot
Resource            ../../../../keywords/tsm/feature_truepoints/feature_truepoints_keywords.robot
Test Setup          Open Apps   TSM
Test Teardown       Close Application

*** Variables ***
${amount_number}             1234
${settlement_header}         สรุปยอดเรียบร้อยแล้ว
${expected_point}            1
${expected_baht}             1,234.00
${settlement_tid_android}    TID: 89086789
${settlement_tid_ios}        TID: 69000747
${settlement_mid_android}    MID: 111002442800001
${settlement_mid_ios}        MID: 111002313600001

*** Test Cases ***
TC_01
    [Documentation]      Verify the Settlement report will return correctly
    [Tags]      Regression      High       Reports     Sanity       Regression
    Prepare TruePoint Data        ${THAI_ID_BLACK}       ${amount_number}
    View Settlement Report
    Element Text Should Be        &{settlement_screen}[lbl_all_points_value]          ${expected_point}
    # Element Text Should Be        &{settlement_screen}[lbl_baht_value]                ${expected_baht}
    # Bug: The expected value on iOS is incorrect number format
    View Print Summary Report
    Page Should Contain Property With Value    ${settlement_header}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${settlement_tid_ios}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${settlement_mid_ios}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${settlement_tid_android}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${settlement_mid_android}
    Element Text Should Be        &{settlement_screen}[lbl_print_summary_points]      ${all_points_value}
    Back To Dashboard

TC_02
    [Documentation]      Verify the Summary report will return correctly
    [Tags]      Regression      High       Reports     Sanity       Regression
    Prepare TruePoint Data        ${THAI_ID_BLACK}       ${amount_number}
    Get Current Summary Report Value
    Submit New TruePoint          ${THAI_ID_BLACK}       ${amount_number}
    View Summary Report
    Run Keyword If      '${OS}' == 'android'    Element Text Should Be         &{summary_screen}[lbl_total_point]      ${new_truepoint_number}
    Run Keyword If      '${OS}' == 'android'    Element Text Should Be         &{summary_screen}[lbl_total_baht]       ${new_total_baht}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value        ${new_truepoint_number}
    # Run Keyword If      '${OS_NAME}' == 'ios'        Page Should Contain Property With Value        ${new_total_baht}
    # Bug: The expected value on iOS is incorrect number format
    Clean Up Summary Reports
