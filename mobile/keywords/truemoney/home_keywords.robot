*** Settings ***
Resource    ../../resources/locators/truemoney/android/home_locators.robot

*** Keywords ***
Navigate To True Town
    Swipe Left From Element To Element    ${ico_mini_app}    ${ico_true_town}
    Click Visible Element    ${ico_true_town}
