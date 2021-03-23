*** Settings ***
Resource    ../../../resources/locators/merchant_dashboard/common/common_locators.robot

*** Keywords ***
Wait Until Loading Pane Is Disappear
    Wait Until Element Is Disappear    ${icn_loading_pane}

Select Transaction Top Menu Bar
    Click Element    ${mnu_transaction_top_bar}