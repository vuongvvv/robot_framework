*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/on_boarding_screen/on_boarding_locators.robot

*** Keywords ***
Tap On Activate First Button
    Wait Until Element Is Visible        &{onboarding_screen}[btn_activation]
    Click Element     &{onboarding_screen}[btn_activation]
