*** Variables ***
${main_edc}              &{main_edc_${OS}}

&{main_edc_android}    survey_popup=id=image_view
...     bth_close_popup=id=collapse_button
...     shop_profile_section=id=lnl_merchant_info
...     lbl_merchant_name=tvMerchantName
...     menu_total_sale_today_section=id=constraint_total_sale_today_section
...     lbl_total_sale_title=id=tv_total_sale_title
...     lbl_total_sale_today_amount=id=tv_today_amount
...     lbl_currency=id=tv_currency_symbol
...     lbl_update_time=id=tv_update_time
...     btn_advice=xpath=//android.widget.TextView[contains(@text,"ฟังเรื่องราวดีๆ")]
...     btn_shop_profile=xpath=//android.widget.TextView[contains(@text,"เปิดร้านค้า")]
...     popup_recieve_notification=id=iv_push_notification_background
...     btn_close_notification=id=iv_close_status_noti_sub

&{main_edc_ios}    survey_popup=id=image_view
...     shop_profile_section=id=new_merchant_bg
...     lbl_merchant_name=xpath=//XCUIElementTypeStaticText[@name="${merchant_name}"]
...     menu_total_sale_today_section=xpath=//XCUIElementTypeStaticText[@name="ภาพรวมรายได้วันนี้"]
...     lbl_total_sale_title=id=tv_total_sale_title
...     lbl_total_sale_today_amount=id=tv_today_amount
...     lbl_currency=xpath=//XCUIElementTypeStaticText[@name="(฿)"]
...     lbl_update_time=id=tv_update_time
...     btn_advice=xpath=//XCUIElementTypeStaticText[@name="ฟังเรื่องราวดีๆ สำหรับร้านค้า"]
...     btn_shop_profile=xpath=//XCUIElementTypeStaticText[contains(@name,"เปิดร้านค้า")]
...     popup_recieve_notification=id=receiveNotification
...     btn_close_notification=id=artboard

&{main_edc_text}     total_sale_title=ภาพรวมรายได้วันนี้
...     menu_advice_1=ฟังเรื่องราวดีๆ
...     menu_advice_2=สำหรับร้านค้า
...     menu_advice=ฟังเรื่องราวดีๆ\nสำหรับร้านค้า
...     menu_sell_online_1=เปิดร้านค้า
...     menu_sell_online_2=ออนไลน์
...     menu_sell_online=เปิดร้านค้า\nออนไลน์