*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/common_locators.robot
Resource    ../../../../utility/common/locator_common.robot

*** Keywords ***
Tap On Navigation Tab By Name
    [Arguments]    ${tab_name}
    ${tab_locator}    Generate Element From Dynamic Locator    ${tab_navigation_by_name}    ${tab_name}
    Wait Element Is Visible    ${tab_locator}
    Click Visible Element    ${tab_locator}