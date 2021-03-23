*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/advice/playlist_locators.robot

*** Keywords ***
Playlist Page Should Be Opened
    Wait Until Page Contains        &{playlist_text}[lbl_title]

Playlist Show Correctly
    Page Should Contain Text        &{playlist_text}[lbl_content]
    Page Should Contain Element     &{playlist}[lbl_play_list_title]
    Page Should Contain Element     &{playlist}[lbl_play_list_date]
    Page Should Contain Element     &{playlist}[btn_play]

Tap On Play Button
   Wait Until Page Contains Element    &{playlist}[btn_play]
   Click Element    &{playlist}[btn_play]

Get Title Name On Playlist Page
    Wait Until Page Contains Element     &{playlist}[lbl_play_list_title]
    ${title_name}=    Get Text    &{playlist}[lbl_play_list_title]
    [Return]    ${title_name}