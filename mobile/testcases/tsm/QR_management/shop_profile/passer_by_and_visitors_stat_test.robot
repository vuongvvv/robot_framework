*** Settings ***
Documentation       Verify user can access to shop profile and displayed passer by visitors saction.
Resource            ../../../../../api/resources/init.robot
Resource            ../../../../../api/keywords/cms/content_resource_keywords.robot
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/my_shop_keywords.robot
Test Setup          Open Apps   TSM
Test Teardown       Close Application

*** Variables ***
${thai_id}      1509901018351
${merchant_name}        ทดสอบ_ยอดขายรวม
${tsm_merchant_id}      0024934

*** Keywords ***
Precondition QR Merchant Go To Main EDC Screen
    Tutorial Page Should Be Opened
    Tap On Check Merchant Status Menu
    Check Merchant Status Page Should Be Opened
    Input Thai ID       ${thai_id}
    Submit Check Merchant Status
    Select On Any Merchants     ${merchant_name}
    Input OTP Number    ${OTP_NUMBER}
    Submit OTP Number
    Main EDC Screen Should Be Opened

Set Valiable Attribute
    ${attribute_value}    Set Variable If    '${OS}' == 'ios'    value    text
    Set Suite Variable    ${attribute}    ${attribute_value}

*** Test Cases ***
TC_O2O_12417
    [Documentation]    Verify default passer by visitors in main saction
    [Tags]    Regression    High    Smoke    Sanity
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Passer By Visitors Main Saction Correctly
    Capture Page Screenshot    filename=TC_O2O_12417.png

TC_O2O_12424
    [Documentation]    Verify default expand saction when user tab on expand (V) button
    [Tags]    Regression    High    Smoke    Sanity
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Tab To Expand Passer By Visitors
    Show Passer By Visitors Expand Saction Correctly
    Capture Page Screenshot    filename=TC_O2O_12424.png

TC_O2O_12426
    [Documentation]    Verify when user tab unexpand button
    [Tags]    Regression    Low
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Tab To Expand Passer By Visitors
    Tab To Unxpand Passer By Visitors
    Show Passer By Visitors Main Saction Correctly
    Capture Page Screenshot    filename=TC_O2O_12426.png
