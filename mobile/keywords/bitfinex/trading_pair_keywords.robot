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
    Click Visible Element    ${btn_max_sell_on_order_form_trading}    0.5
    ${amount_max_sell}    Get Element Text    ${txt_order_amount_on_order_form_trading}
    Should Not Be Empty    ${amount_max_sell}
    
Create Market Order
    [Arguments]    ${amount}    ${transaction_type}    ${reduce_only}=${False}
    Clear Element Text    ${txt_order_amount_on_order_form_trading}    
    Input Text Into Element    ${txt_order_amount_on_order_form_trading}    ${amount}    ${True}
    Tap On Create Order    ${transaction_type}
    Run Keyword If    '${reduce_only}'=='${True}'    Click Visible Element    ${chk_reduce_only_on_order_form_trading}
    Click Visible Element    ${btn_confirm_on_confirm_order_popup}
    Sleep    3s
    Run Keyword If    '${reduce_only}'=='${True}'    Click Visible Element    ${chk_reduce_only_on_order_form_trading}
    
Tap On Create Order
    [Arguments]    ${transaction_type}
    Run Keyword If    '${transaction_type}'=='buy'    Click Visible Element    ${btn_exchange_buy_on_order_form_trading}
    ...    ELSE    Click Visible Element    ${btn_exchange_sell_on_order_form_trading}

Select Order Form Tab
    [Arguments]    ${tab_name}
    ${tab_order}    Generate Element From Dynamic Locator    ${tab_exchange_margin}    ${tab_name}
    Click Visible Element    ${tab_order}