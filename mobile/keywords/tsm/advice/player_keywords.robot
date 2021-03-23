*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/advice/player_locators.robot

*** Keywords ***
Player Page Should Be Opened
    Wait Until Page Contains        &{player_text}[lbl_title]

Player Show Correctly
    [Arguments]    ${expected_title_name}
    ${title_acdemy_actual}=    Get Text     &{player}[lbl_title_acdemy]
    ${title_end_acdemy_actual}=    Get Text     &{player}[lbl_title_end_acdemy]
    Should Contain     ${title_acdemy_actual}      &{player_text}[lbl_title_acdemy]
    Should Contain     ${title_end_acdemy_actual}      &{player_text}[lbl_title_end_acdemy]
    Page Should Contain Element     &{player}[btn_pause]
    Page Should Contain Element     &{player}[lbl_title_name_audio]
    ${actual_title_name}=    Get Text    &{player}[lbl_title_name_audio]
    Should Be Equal    ${expected_title_name}    ${actual_title_name}
    Page Should Contain Element     &{player}[video_view]

Tap On Pause Button
    Click Element       &{player}[btn_pause]
