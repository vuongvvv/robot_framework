*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/shop_profile/shop_review_locators.robot

*** Keywords ***
Show Review Snapshot Correctly
    Page Should Contain Element     &{shop_review}[lbl_review_snapshot]
    Page Should Contain Element     &{shop_review}[lbl_number_of_review]
    Page Should Contain Element     &{shop_review}[lbl_average_review]
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Element     &{shop_review}[lbl_score_text]
    Page Should Contain Element     &{shop_review}[icon_review_star_1]
    Page Should Contain Elementt    &{shop_review}[icon_review_star_2]
    Page Should Contain Element     &{shop_review}[icon_review_star_3]
    Page Should Contain Element     &{shop_review}[icon_review_star_4]
    Page Should Contain Element     &{shop_review}[icon_review_star_5]

Show Number Of Review Correctly
    [Arguments]     ${expected}
    ${expected}    Set Valiable    (${expected} รีวิว)
    ${actual}    Get Element Attribute    &{shop_review}[lbl_number_of_review]    ${attribute}
    Should Be Equal As Strings    ${expected}    ${actual}

Show Average Review Correctly
    [Arguments]     ${expected}
    ${actual}    Get Element Attribute    &{shop_review}[lbl_average_review]    ${attribute}
    ${pre_actual}    ${post_actual}    Split String    ${actual}
    Should Be Equal As Strings    ${pre_actual}    ${expected}

Show Preview Review Button Component Correctly
    Element Text Should Be      &{shop_review}[btn_preview_review]       &{shop_review_text}[btn_preview_review]

Tap On Preview Review Button
    Click Element     &{shop_review}[btn_preview_review]

Review List Page Should Be Opened
    Wait Until Page Contains     &{shop_review_text}[title]
    Page Should Contain Element    &{shop_review}[lbl_review_snapshot]
    Page Should Contain Element    &{shop_review}[lbl_average_review]
    Run Keyword If      '${OS}' == 'android'    Page Should Contain Element    &{shop_review}[lbl_score_text]
    Page Should Contain Element    &{shop_review}[lbl_number_of_review]

Show No Review Message Correctly
    [Arguments]     ${expected_message}
    ${actual_message}    Get Element Attribute    &{shop_review}[lbl_no_review]       ${attribute}
    ${actual_message}=    Strip String    ${SPACE}${actual_message}${SPACE}     mode=both
    Should Be Equal    ${expected_message}    ${actual_message}

Show Full Text Review With Rating Star Correctly As
    [Arguments]     ${ecpected_title}    ${ecpected_comment}    ${expected_rating_number}
    ${actual_title}    Get Text    &{shop_review}[lbl_reviewlist_title]
    ${actual_comment}    Get Text    &{shop_review}[lbl_reviewlist_comment]
    ${actual_rating_number}    Get Element Attribute    &{shop_review}[lbl_reviewlist_rating]    ${attribute}
    ${actual_rating_number}    Run Keyword If    '${OS}' == 'ios'    Fetch From Left    ${actual_rating_number}    ${SPACE}
    Should Be Equal As Strings    ${actual_title}    ${ecpected_title}
    Should Be Equal As Strings    ${actual_comment}    ${ecpected_comment}
    Should Be Equal As Strings    ${expected_rating_number}    ${actual_rating_number}

Show Only Rating Star Correctly As
    [Arguments]     ${expected_rating_number}
    ${actual_rating_number}    Get Text    &{shop_review}[lbl_reviewlist_rating]
    Should Be Equal As Strings    ${expected_rating_number}    ${actual_rating_number}

Tab On Review Box
    Click Element     &{shop_review}[]

Tab On Read More
    Click Element     &{shop_review}[]

Show Full Review Page Correctly