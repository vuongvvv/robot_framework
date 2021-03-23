*** Variables ***
${facilities}       &{facilities_${OS}}

&{facilities_ios}       btn_parking=xpath=//XCUIElementTypeStaticText[@value="ที่จอดรถ"]
...     btn_free_wifi=xpath=//XCUIElementTypeStaticText[@value="Free WiFi"]
...     btn_private_room=xpath=//XCUIElementTypeStaticText[@value="ห้องส่วนตัว"]
...     btn_delivery_service=xpath=//XCUIElementTypeStaticText[@value="บริการส่งสินค้า"]
...     btn_reservation=xpath=//XCUIElementTypeStaticText[@value="จองล่วงหน้า"]
...     btn_credit_card=xpath=//XCUIElementTypeStaticText[@value="รับบัตรเครดิต"]
...     btn_save=id=btnUpdateFacilities

&{facilities_android}       btn_parking=android=new UiSelector().className("android.widget.TextView").text("ที่จอดรถ")
...     btn_free_wifi=android=new UiSelector().className("android.widget.TextView").text("Free WiFi")
...     btn_private_room=android=new UiSelector().className("android.widget.TextView").text("ห้องส่วนตัว")
...     btn_delivery_service=android=new UiSelector().className("android.widget.TextView").text("บริการส่งสินค้า")
...     btn_reservation=android=new UiSelector().className("android.widget.TextView").text("จองล่วงหน้า")
...     btn_credit_card=android=new UiSelector().className("android.widget.TextView").text("รับบัตรเครดิต")
...     btn_save=id=btnUpdateFacilities

&{facilities_text}      lbl_title=สิ่งอำนวยความสะดวก
...     lbl_parking=ที่จอดรถ
...     lbl_free_wifi=Free WiFi
...     lbl_private_room=ห้องส่วนตัว
...     lbl_delivery_service=บริการส่งสินค้า
...     lbl_reservation=xpath=จองล่วงหน้า
...     lbl_credit_card=xpath=รับบัตรเครดิต
