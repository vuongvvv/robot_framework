*** Settings ***
Documentation       Verify the True Point succeed and fail correctly depending from users input values.
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/feature_truepoints/feature_truepoints_keywords.robot
Resource            ../../../../keywords/tsm/activation_code/activation_code_keywords.robot
Resource            ../../../../keywords/tsm/on_boarding/on_boarding_keywords.robot
Test Setup         Open Apps   TSM
Test Teardown      Close Application

*** Variables ***
${amount_number}             1000
${dashboard_screen_label}    เลือกรายการ
${summary_screen_label}      ทำรายการสำเร็จ
${summary_tid_android}       TID: 89086789
${summary_tid_ios}           TID: 69000747
${summary_mid_android}       MID: 111002442800001
${summary_mid_ios}           MID: 111002313600001
${summary_outlet_id}         Outlet ID: 00001
${summary_batch_id}          000002
${summary_thai_id_black}         *********0104
${summary_thai_id_red}           *********0103
${summary_true_card_id_black}    *********9082
${summary_true_card_id_red}      *********7130
${summary_amount}                1,000.00 บาท
${summary_footer_message}        ทรูพอยท์สะสมจากยอดซื้อในวันนี้ จะใช้ได้ในวันถัดไป

*** Test Cases ***
TC_01
    [Documentation]      Verify the True Point succeed with ThaiID (Black card)
    [Tags]      Regression      High       CustomerStatus     E2E
    Tap On Activate First Button
    Enter The Activation Code And Password     ${ACTIVATION_CODE_IOS}     ${ACTIVATION_CODE_ANDROID}      ${ACTIVATION_PASSWORD}
    Tap On Check TruePoint
    Submit TruePoint By ThaiId        ${THAI_ID_BLACK}       ${amount_number}
    Page Should Contain Property With Value    ${summary_screen_label}
    Page Should Contain Property With Value    ${summary_outlet_id}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${summary_tid_ios}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${summary_mid_ios}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${summary_tid_android}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${summary_mid_android}
    Tap On Print Receipt

TC_02
    [Documentation]     Verify the True Point succeed with ThaiID (Red card)
    [Tags]      Regression      High       CustomerStatus     Sanity
    Tap On Activate First Button
    Enter The Activation Code And Password     ${ACTIVATION_CODE_IOS}     ${ACTIVATION_CODE_ANDROID}      ${ACTIVATION_PASSWORD}
    Tap On Check TruePoint
    Submit TruePoint By ThaiId        ${THAI_ID_RED}     ${amount_number}
    Page Should Contain Property With Value    ${summary_screen_label}
    Page Should Contain Property With Value    ${summary_outlet_id}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${summary_tid_ios}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${summary_mid_ios}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${summary_tid_android}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${summary_mid_android}
    Back To Dashboard Screen

TC_03
    [Documentation]     Verify the True Point succeed with TrueCard (Black card)
    [Tags]      Regression      High       CustomerStatus     Sanity
    Tap On Activate First Button
    Enter The Activation Code And Password     ${ACTIVATION_CODE_IOS}     ${ACTIVATION_CODE_ANDROID}      ${ACTIVATION_PASSWORD}
    Tap On Check TruePoint
    Submit TruePoint By TrueCard         ${TRUE_CARD_ID_BLACK}       ${amount_number}
    Page Should Contain Property With Value    ${summary_screen_label}
    Page Should Contain Property With Value    ${summary_outlet_id}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${summary_tid_ios}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${summary_mid_ios}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${summary_tid_android}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${summary_mid_android}
    Tap On Print Receipt

TC_04
    [Documentation]     Verify the True Point succeed with TrueCard (Red card)
    [Tags]      Regression      High       CustomerStatus     E2E
    Tap On Activate First Button
    Enter The Activation Code And Password     ${ACTIVATION_CODE_IOS}     ${ACTIVATION_CODE_ANDROID}      ${ACTIVATION_PASSWORD}
    Tap On Check TruePoint
    Submit TruePoint By TrueCard         ${TRUE_CARD_ID_RED}       ${amount_number}
    Page Should Contain Property With Value    ${summary_screen_label}
    Page Should Contain Property With Value    ${summary_outlet_id}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${summary_tid_ios}
    Run Keyword If      '${OS}' == 'ios'        Page Should Contain Property With Value    ${summary_mid_ios}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${summary_tid_android}
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Property With Value    ${summary_mid_android}
    Back To Dashboard Screen
