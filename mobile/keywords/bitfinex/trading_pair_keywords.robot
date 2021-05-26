*** Settings ***
Resource    ../../resources/locators/android/bitfinex/trading_pair_locators.robot
Resource    ../../../utility/common/locator_common.robot
Resource    ../../../utility/common/string_common.robot

Resource    ../common/mobile_common.robot
*** Keywords ***
Verify Chart Loading Success
    [Arguments]    ${expected_load_time}=5s
    Run Keyword And Continue On Failure    Wait Element Is Visible    ${btn_volume_on_chart}    ${expected_load_time}
    
Scroll Down To Order Form
    Swipe Down To Element    ${btn_exchange_buy_on_order_form_trading}
    
Select Order Type
    [Arguments]    ${order_type}
    Click Visible Element    ${drd_order_type_on_order_form_trading}
    ${rdo_order_type}    Generate Element From Dynamic Locator    ${rdo_order_type_by_label}    ${order_type}
    Click Visible Element    ${rdo_order_type}
    
Verify Max Sell Buy Buttons
    Click Visible Element    ${btn_max_buy_on_order_form_trading}    0.5
    ${amount_max_buy}    Get Element Text    ${txt_order_amount_on_order_form_trading}
    Should Not Be Empty    ${amount_max_buy}
    Clear Element Text    ${txt_order_amount_on_order_form_trading}
    Click Visible Element    ${btn_max_sell_on_order_form_trading}    0.5
    ${amount_max_sell}    Get Element Text    ${txt_order_amount_on_order_form_trading}
    Should Not Be Empty    ${amount_max_sell}
    Clear Element Text    ${txt_order_amount_on_order_form_trading}

Verify Limit Order Form Button
    Click Visible Element    ${btn_max_bid_on_order_form_trading}    0.5
    ${max_bid}    Get Element Text    ${txt_order_price_on_order_form_trading}
    Should Not Be Empty    ${max_bid}
    Clear Element Text    ${txt_order_price_on_order_form_trading}
    
    Click Visible Element    ${btn_min_ask_on_order_form_trading}    0.5
    ${min_ask}    Get Element Text    ${txt_order_price_on_order_form_trading}
    Should Not Be Empty    ${min_ask}
    Clear Element Text    ${txt_order_price_on_order_form_trading}
    
    Click Visible Element    ${btn_top_bid_on_order_form_trading}    0.5
    ${top_bid}    Get Element Text    ${txt_order_price_on_order_form_trading}
    Should Not Be Empty    ${top_bid}
    Clear Element Text    ${txt_order_price_on_order_form_trading}
    
    Click Visible Element    ${btn_top_ask_on_order_form_trading}    0.5
    ${top_ask}    Get Element Text    ${txt_order_price_on_order_form_trading}
    Should Not Be Empty    ${top_ask}
    
    Verify Max Sell Buy Buttons
    Clear Element Text    ${txt_order_price_on_order_form_trading}
    
Create Market Order
    [Arguments]    ${amount}    ${transaction_type}    ${reduce_only}=${False}
    Clear Element Text    ${txt_order_amount_on_order_form_trading}    
    Input Text Into Element    ${txt_order_amount_on_order_form_trading}    ${amount}    ${True}
    Run Keyword If    '${reduce_only}'=='${True}'    Click Visible Element    ${chk_reduce_only_on_order_form_trading}
    Confirm Order    ${transaction_type}    
    Run Keyword If    '${reduce_only}'=='${True}'    Click Visible Element    ${chk_reduce_only_on_order_form_trading}
    
Confirm Order
    [Arguments]    ${transaction_type}
    Run Keyword If    '${transaction_type}'=='buy'    Click Visible Element    ${btn_exchange_buy_on_order_form_trading}
    ...    ELSE    Click Visible Element    ${btn_exchange_sell_on_order_form_trading}
    Click Visible Element    ${btn_confirm_on_confirm_order_popup}
    Sleep    3s

Select Order Form Tab
    [Arguments]    ${tab_name}
    ${tab_order}    Generate Element From Dynamic Locator    ${tab_exchange_margin}    ${tab_name}
    Click Visible Element    ${tab_order}
    
Input Order Price
    [Arguments]    ${price}=max_bid
    Run Keyword If    '${price}'=='max_bid'    Click Visible Element    ${btn_max_bid_on_order_form_trading}
    ...    ELSE IF    '${price}'=='min_ask'    Click Visible Element    ${btn_min_ask_on_order_form_trading}
    ...    ELSE    Input Text Into Element    ${txt_order_price_on_order_form_trading}    ${price}
    
Input Order Amount
    [Arguments]    ${amount}=max_buy
    Run Keyword If    '${amount}'=='max_buy'    Click Visible Element    ${btn_max_buy_on_order_form_trading}
    ...    ELSE IF    '${amount}'=='max_sell'    Click Visible Element    ${btn_max_sell_on_order_form_trading}
    ...    ELSE    Input Text Into Element    ${txt_order_amount_on_order_form_trading}    ${amount}        

Create Exchange Order
    [Arguments]    ${price}    ${amount}    ${transaction_type}
    Input Order Price    ${price}
    Input Order Amount    ${amount}
    Confirm Order    ${transaction_type}