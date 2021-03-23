*** Variables ***
${dashboard}              &{dashboard_${OS}}

&{dashboard_ios}         lbl_check_customer_status=xpath=//XCUIElementTypeStaticText[@name="เช็คสถานะลูกค้า"]
...                      lbl_true_points=xpath=//XCUIElementTypeStaticText[@name="สะสมทรูพอยท์"]
...                      lbl_reports=xpath=//XCUIElementTypeStaticText[@name="สรุปยอด/รายงาน"]
...                      lbl_void=xpath=//XCUIElementTypeStaticText[@name="ยกเลิกรายการ (Void)"]

&{dashboard_android}     lbl_check_customer_status=xpath=//android.widget.FrameLayout[6]/android.support.v7.widget.au
...                      lbl_true_points=xpath=//android.widget.FrameLayout[7]/android.support.v7.widget.au
...                      lbl_reports=xpath=//android.widget.FrameLayout[8]/android.support.v7.widget.au
...                      lbl_void=xpath=//*[contains(@text,'(Void)')]
