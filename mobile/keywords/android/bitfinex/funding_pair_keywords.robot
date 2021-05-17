*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/funding_pair_locators.robot

*** Keywords ***
Verify Chart Loading Success On Funding
    [Arguments]    ${expected_load_time}=5s
    Run Keyword And Continue On Failure    Wait Element Is Visible    ${btn_volume_on_chart_on_funding}    ${expected_load_time}