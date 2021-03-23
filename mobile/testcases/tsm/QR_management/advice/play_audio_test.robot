*** Settings ***
Documentation       Verify user can playing audio with advice feature correctly.
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/advice/playlist_keywords.robot
Resource            ../../../../keywords/tsm/advice/player_keywords.robot
Test Setup          Open Apps   TSM
Test Teardown       Close Application

*** Variables ***
${thai_id}                  1509901018351
${merchant_name}              ทดสอบ_ยอดขายรวม

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

*** Test Cases ***
TC_O2O_09082
    [Documentation]      Verify user can see audio episodes on playlist screen correctly
    [Tags]      Regression    High    Smoke    Sanity    E2E
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Advice Menu
    Playlist Page Should Be Opened
    Playlist Show Correctly
    Capture Page Screenshot         filename=TC_O2O_09082.png

TC_O2O_09098
    [Documentation]      Verify user can access to the player screen correctly by tapping on 'play button' on the content card in the playlist screen
    [Tags]      Regression    High    Smoke    Sanity    E2E
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Advice Menu
    Playlist Page Should Be Opened
    ${expected_title_name}=    Get Title Name On Playlist Page
    Tap On Play Button
    Player Page Should Be Opened
    Player Show Correctly    ${expected_title_name}
    Capture Page Screenshot         filename=TC_O2O_09098.png