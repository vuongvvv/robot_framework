*** Settings ***
Resource    ../../../resources/locators/android/bitfinex/wallet_locators.robot
Resource    ../../../../utility/common/locator_common.robot
Resource    common_keywords.robot

Resource    ../../common/mobile_common.robot

*** Keywords ***
Tap On I Button
    Click Visible Element    ${btn_i_open_help_modal}
    
Tap On Okay Got It Button
    Wait Element Is Visible    ${btn_okay_got_it_on_how_to_modal}
    Click Visible Element    ${btn_okay_got_it_on_how_to_modal}
    
Tap On Eyes Icon
    Click Visible Element    ${btn_eyes}    
    
Verify Balances Information Is Hidden
    Wait Element Disappear    ${lnk_currency_on_balances_panel}
    Wait Element Disappear    ${lbl_equivalent_on_balances_panel}
    Wait Element Disappear    ${chk_market_on_balances_panel}
    Wait Element Disappear    ${lbl_market_on_balances_panel}
    Verify Element Text Should Be    ${cel_balances_table_on_balances_panel}    *
    
Verify Balances Information Is Shown
    Wait Element Is Visible    ${lnk_currency_on_balances_panel}
    Wait Element Is Visible    ${lbl_equivalent_on_balances_panel}
    Wait Element Is Visible    ${chk_market_on_balances_panel}
    Wait Element Is Visible    ${lbl_market_on_balances_panel}
    Verify Element Text Shoud Not Be    ${cel_balances_table_on_balances_panel}    *
    
Tap On Balances Panel
    Click Visible Element    ${pnl_balances}
    
Tap On Balances Button
    [Arguments]    ${button_text}
    ${btn_balance}    Generate Element From Dynamic Locator    ${btn_balances_function_by_text}    ${button_text}
    Click Visible Element    ${btn_balance}
    
Select Payment Type
    [Arguments]    ${payment_type}    ${amount}
    Click Visible Element    ${drd_payment_type_on_deposit_panel}
    ${rdo_payment_type}    Generate Element From Dynamic Locator    ${rdo_payment_type_on_choose_payment_type_modal}    ${payment_type}
    Click Visible Element    ${rdo_payment_type}
    Wait Element Is Visible    ${btn_next_on_deposit_panel}
    Click Visible Element    ${btn_next_on_deposit_panel}
    Input Text Into Element    ${txt_amount_on_payment_card_deposit_modal}    ${amount}
    Swipe Down To Element    ${chk_term_of_service_on_payment_card_deposit_modal}
    Click Visible Element    ${chk_term_of_service_on_payment_card_deposit_modal}
    Swipe Down To Element    ${btn_submit_on_payment_card_deposit_modal}
    Click Visible Element    ${btn_submit_on_payment_card_deposit_modal}
    Click Visible Element    ${btn_okay_please_confirm_popup_on_payment_card_deposit_modal}
    Tap On Back Button