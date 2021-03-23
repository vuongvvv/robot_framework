*** Variables ***
${weshop_webview}       &{weshop_webview_${OS}}

&{weshop_webview_ios}       lbl_merchant_name=xpath=//XCUIElementTypeStaticText[@name="${merchant_name}"]
...     lbl_category=xpath=//XCUIElementTypeStaticText[@name="${category_description}"]
...     lbl_address=xpath=//XCUIElementTypeStaticText[@name="${shop_location}"]
...     lbl_shop_mobile=//XCUIElementTypeStaticText[@name="${shop_mobile}"]

&{weshop_webview_android}       lbl_merchant_name=xpath=//android.view.View[@text="${merchant_name}"]
...     lbl_category=xpath=//android.view.View[@text="${category_description}"]
...     lbl_address=xpath=//android.view.View[@text="${shop_location}"]
...     lbl_shop_mobile=//android.view.View[@text="${shop_mobile}"]

&{weshop_webview_text}     lbl_title=ร้านของคุณบน WeShop