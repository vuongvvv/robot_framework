*** Variables ***
${btn_volume_on_chart}    xpath=//android.view.View[@text='Volume']
${btn_exchange_buy_on_order_form_trading}    accessibility_id=order_buy_button
${btn_exchange_sell_on_order_form_trading}    accessibility_id=order_sell_button
${drd_order_type_on_order_form_trading}    accessibility_id=order_form_type_picker
${btn_max_buy_on_order_form_trading}    accessibility_id=max_buy_btn
${btn_max_sell_on_order_form_trading}    accessibility_id=max_sell_btn
${txt_order_amount_on_order_form_trading}    accessibility_id=order_form_amount_input
${btn_confirm_on_confirm_order_popup}    xpath=//android.widget.TextView[@text='Confirm']
${chk_reduce_only_on_order_form_trading}    accessibility_id=reduceonly_checkbox

#DYNAMIC
${rdo_order_type_by_label}    xpath=//android.widget.TextView[@text='_DYNAMIC_0']
${tab_exchange_margin}    xpath=//android.widget.TextView[@text='_DYNAMIC_0']