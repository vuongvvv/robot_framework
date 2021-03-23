*** Variables ***
${check_merchant_status}              &{check_merchant_status_${OS}}

&{check_merchant_status_android}    merchant_search_navigation_bar=id=baseToolbar
...     merchant_search_title=id=tv_merchant_search_title
...     merchant_search_content=id=tv_merchant_search_content
...     txt_thai_id=id=edt_merchant_search_input_id
...     btn_ok=id=button_merchant_search
...     list_merchants=android=new UiSelector().text("${merchant_name}")
...     txt_input_otp=id=edt_input_otp
...     btn_submit_otp=id=btn_submit_otp

&{check_merchant_status_ios}    merchant_search_navigation_bar=xpath=//XCUIElementTypeNavigationBar[@name="ตรวจสอบสถานะการลงทะเบียนร้าน"]
...     merchant_search_title=xpath=//XCUIElementTypeStaticText[@name="ตรวจสอบสถานะการลงทะเบียนร้าน"]
...     merchant_search_content=xpath=//XCUIElementTypeStaticText[@name="เลขประจำตัวประชาชน"]
...     txt_thai_id=xpath=//XCUIElementTypeTextField
...     btn_ok=xpath=//XCUIElementTypeButton[@name="ตกลง"]
...     list_merchants=xpath=//XCUIElementTypeStaticText[@name="${merchant_name}"]
...     txt_input_otp=xpath=//XCUIElementTypeTextField[@value="กรอกหมายเลข OTP"]
...     btn_submit_otp=xpath=//XCUIElementTypeButton[@name="ตกลง"]

&{check_merchant_status_text}    merchant_search_title=ตรวจสอบสถานะการลงทะเบียนร้าน
...     merchant_search_content=เลขประจำตัวประชาชน
...     btn_ok=ตกลง