*** Variables ***
${QR_merchant_status}              &{QR_merchant_status_${OS}}

&{QR_merchant_status_android}    menu_total_sale_today_section=id=constraint_total_sale_today_section
...     lbl_total_sale_today_amount=id=tv_total_sale_today_amount
...     lbl_currency=id=textView2
...     menu_advice=ฟังเรื่องราวดีๆ

&{QR_merchant_status_ios}    menu_total_sale_today_section=xpath=//XCUIElementTypeStaticText[@name="ยอดขายรวมวันนี้"]
...     lbl_total_sale_title=id=tv_total_sale_title
...     lbl_total_sale_today_amount=id=tv_total_sale_today_amount
...     lbl_currency=id=textView2
...     menu_advice=ฟังเรื่องราวดีๆ

&{QR_merchant_status_text}    qr_code_title=QR Code ร้านคุณ
...     total_sale_title=ยอดขายรวมวันนี้