*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/tutorial/tutorial_locators.robot

*** Keywords ***
Tutorial Page Should Be Opened
    Wait Until Element Is Visible       &{tutorial}[tutorail_page]

Validate Content Of Promotions Show Correctly
    Element Text Should Be      &{tutorial}[txt_tutorial_title]       &{tutorial_promotion_page}[lbl_promotion]
    Element Text Should Be      &{tutorial}[txt_tutorial_description]       &{tutorial_promotion_page}[lbl_description_promotion]

Merchant Registration Menu Show Correctly
    Element Text Should Be      &{tutorial}[btn_registration]       &{tutorial_menu}[lbl_merchant_registration]

Access Activation Code Menu Show Correctly
    Element Text Should Be      &{tutorial}[btn_activation_code]       &{tutorial_menu}[lbl_activation_code]

Check Status Merchant Menu Show Correctly
    Element Text Should Be      &{tutorial}[btn_check_merchant_status]       &{tutorial_menu}[lbl_check_merchant_status]

Validate Content Of Another Promotions Show Correctly
    Element Text Should Be      &{tutorial}[txt_tutorial_title]       &{tutorial_socail_promotion_page}[lbl_social_promotion]
    Element Text Should Be      &{tutorial}[txt_tutorial_description]       &{tutorial_socail_promotion_page}[lbl_description_social_promotion]

Tap On Check Merchant Status Menu
    Click Element       &{tutorial}[btn_check_merchant_status]