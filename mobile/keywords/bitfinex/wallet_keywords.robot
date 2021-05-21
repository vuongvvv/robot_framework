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
    Tap On Dropdown Item    ${payment_type}
    Wait Element Is Visible    ${btn_next_on_deposit_panel}
    Click Visible Element    ${btn_next_on_deposit_panel}
    Input Text Into Element    ${txt_amount_on_payment_card_deposit_modal}    ${amount}
    Swipe Down To Element    ${chk_term_of_service_on_payment_card_deposit_modal}
    Click Visible Element    ${chk_term_of_service_on_payment_card_deposit_modal}
    Swipe Down To Element    ${btn_submit_on_payment_card_deposit_modal}
    Click Visible Element    ${btn_submit_on_payment_card_deposit_modal}
    Click Visible Element    ${btn_okay_please_confirm_popup_on_payment_card_deposit_modal}
    Tap On Back Button
    Tap On Back Button
    
Tap On I Button On Deposit Panel
    Click Visible Element    ${btn_i_on_deposit_panel}
    
Select Currency Conversion
    [Arguments]    ${amount}
    Input Text Into Element    ${txt_amount_on_currency_conversion_panel}    ${amount}
    Click Visible Element    ${drd_from_on_currency_conversion_panel}
    Tap On Dropdown Item    USD
    Click Visible Element    ${drd_from_wallet_on_currency_conversion_panel}
    Tap On Dropdown Item    Exchange
    Click Visible Element    ${btn_convert_on_currency_conversion_panel}
    
Swipe Back To Top
    Swipe Up To Element    ${pnl_balances}
    
Search For Currency On Balance
    [Arguments]    ${currency}
    Input Text Into Element    ${txt_search_on_balances_panel}    ${currency}

Tap On Clear Search Button
    Click Visible Element    ${btn_clear_search_on_balances_panel}

Tap On Cog Icon Button
    Click Visible Element    ${btn_cog_icon_on_balances_panel}
    
Verify Currency On Balances Table
    [Arguments]    ${currency}
    ${currency_element}    Generate Element From Dynamic Locator    ${cel_currency_on_balances_table}    ${currency}
    Wait Element Is Visible    ${currency_element}

Verify Currency Does Not Display On Table
    [Arguments]    ${currency}
    ${currency_element}    Generate Element From Dynamic Locator    ${cel_currency_on_balances_table}    ${currency}
    Wait Element Disappear    ${currency_element}    
    
Configure Hide Small Balances
    Wait Element Is Visible    ${chk_hide_small_balances_on_configure_small_balance_threshold_popup}    
    Click Visible Element    ${chk_hide_small_balances_on_configure_small_balance_threshold_popup}
    Click Visible Element    ${btn_save_on_configure_small_balance_threshold_popup}