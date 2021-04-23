*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/common_locators.robot
Resource    ../../../../utility/common/locator_common.robot

Resource    ../../common/mobile_common.robot

*** Keywords ***
Tap On Navigation Tab By Name
    [Arguments]    ${tab_name}
    ${tab_locator}    Generate Element From Dynamic Locator    ${tab_navigation_by_name}    ${tab_name}
    Click Visible Element    ${tab_locator}