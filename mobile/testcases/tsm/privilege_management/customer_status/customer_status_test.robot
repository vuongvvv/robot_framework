*** Settings ***
Documentation       Verify the customer status show the correct information and fail correctly depending from users input values.
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/customer_status/customer_status_keywords.robot
Resource            ../../../../keywords/tsm/activation_code/activation_code_keywords.robot
Resource            ../../../../keywords/tsm/on_boarding/on_boarding_keywords.robot
Test Setup         Open Apps   TSM
Test Teardown      Close Application

*** Variables ***
${customer_name}               AAA
${customer_red_card_type}      สมาชิกทรู Red Card
${customer_black_card_type}    สมาชิกทรู Black Card
${dashboard_screen_label}      เลือกรายการ

*** Test Cases ***
TC_01
    [Documentation]     Verify the customer status succeed with ThaiID (Black card)
    [Tags]      Regression      High       CustomerStatus     Sanity
    Tap On Activate First Button
    Enter The Activation Code And Password     ${ACTIVATION_CODE_IOS}     ${ACTIVATION_CODE_ANDROID}      ${ACTIVATION_PASSWORD}
    Tap On Check Customer Status
    Submit Customer Status By ThaiId           ${THAI_ID_BLACK}
    Page Should Contain Property With Value    ${customer_name}
    Page Should Contain Property With Value    ${TRUE_CARD_ID_BLACK}
    Page Should Contain Property With Value    ${customer_black_card_type}
    Back To Dashboard Screen

TC_02
    [Documentation]     Verify the customer status succeed with ThaiID (Red card)
    [Tags]      Regression      High       CustomerStatus     E2E
    Tap On Activate First Button
    Enter The Activation Code And Password     ${ACTIVATION_CODE_IOS}     ${ACTIVATION_CODE_ANDROID}      ${ACTIVATION_PASSWORD}
    Tap On Check Customer Status
    Submit Customer Status By ThaiId           ${THAI_ID_RED}
    Page Should Contain Property With Value    ${customer_name}
    Page Should Contain Property With Value    ${TRUE_CARD_ID_RED}
    Page Should Contain Property With Value    ${customer_red_card_type}
    Back To Dashboard Screen

TC_03
    [Documentation]    Verify the customer status succeed with TrueCard (Black card)
    [Tags]      Regression      High       CustomerStatus     E2E
    Tap On Activate First Button
    Enter The Activation Code And Password     ${ACTIVATION_CODE_IOS}     ${ACTIVATION_CODE_ANDROID}      ${ACTIVATION_PASSWORD}
    Tap On Check Customer Status
    Submit Customer Status By TrueCard         ${TRUE_CARD_ID_BLACK}
    Page Should Contain Property With Value    ${customer_name}
    Page Should Contain Property With Value    ${TRUE_CARD_ID_BLACK}
    Page Should Contain Property With Value    ${customer_black_card_type}
    Back To Dashboard Screen

TC_04
    [Documentation]     Verify the customer status succeed with TrueCard (Red card)
    [Tags]      Regression      High       CustomerStatus     Sanity
    Tap On Activate First Button
    Enter The Activation Code And Password     ${ACTIVATION_CODE_IOS}     ${ACTIVATION_CODE_ANDROID}      ${ACTIVATION_PASSWORD}
    Tap On Check Customer Status
    Submit Customer Status By TrueCard         ${TRUE_CARD_ID_RED}
    Page Should Contain Property With Value    ${customer_name}
    Page Should Contain Property With Value    ${TRUE_CARD_ID_RED}
    Page Should Contain Property With Value    ${customer_red_card_type}
    Back To Dashboard Screen
