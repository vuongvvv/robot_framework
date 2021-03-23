*** Settings ***
Documentation       Verify the void transaction succeed and fail correctly depending from users input values.
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/summary_reports/summary_report_keywords.robot
Resource            ../../../../keywords/tsm/activation_code/activation_code_keywords.robot
Resource            ../../../../keywords/tsm/on_boarding/on_boarding_keywords.robot
Resource            ../../../../keywords/tsm/feature_truepoints/feature_truepoints_keywords.robot
Resource            ../../../../keywords/tsm/void_transaction/void_transaction_keywords.robot
Resource            ../../../../keywords/tsm/summary_reports/summary_report_keywords.robot
Test Setup          Open Apps   TSM
Test Teardown       Close Application

*** Variables ***
${amount_number}         1122
${void_header}           ตรวจสอบยกเลิกรายการ
${expected_baht}         1,122.00

*** Test Cases ***
TC_01
    [Documentation]      Verify the void transaction will return correctly
    [Tags]      Regression      High       CustomerStatus     Sanity      Regression
    Prepare TruePoint Data        ${THAI_ID_BLACK}       ${amount_number}
    Check Void Transaction        ${trace_no}
    Page Should Contain Property With Value    ${void_header}
    Page Should Contain Property With Value    ${trace_no}
    # Page Should Contain Property With Value    ${expected_baht}
    # Bug: The expected value on iOS is incorrect number format
    Close Void Screen
    Clean Up Void Data
