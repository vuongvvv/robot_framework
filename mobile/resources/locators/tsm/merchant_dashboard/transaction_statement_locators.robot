*** Variables ***
${transaction_statement}              &{transaction_statement_${OS}}

&{transaction_statement_android}       btn_date_picker=android=new UiSelector().className("android.widget.EditText").resourceId("btnDatePicker")
...     lbl_total_transaction=android=new UiSelector().className("android.view.View").resourceId("labelTotalTransaction")
...     lbl_total_unit=android=new UiSelector().className("android.view.View").resourceId("labelTotalUnit")
...     lbl_truemoney=android=new UiSelector().className("android.view.View").resourceId("labelTmnWallet")
...     lbl_total_truemoney=android=new UiSelector().className("android.view.View").resourceId("labelTransactionAmount")
...     lbl_total_truemoney_unit=android=new UiSelector().className("android.view.View").resourceId("labelTransactionAmountUnit")

&{transaction_statement_ios}       btn_date_picker=xpath=//XCUIElementTypeOther[@name="รายการ, tab panel"]/XCUIElementTypeOther[1]/XCUIElementTypeTextField
...     lbl_total_transaction=xpath=//XCUIElementTypeStaticText[@name="1"]
...     lbl_total_unit=xpath=//XCUIElementTypeStaticText[@name="รายการ"]
...     lbl_truemoney=xpath=//XCUIElementTypeStaticText[@name="ได้รับเงินโอนจากทรูมันนี่"]
...     lbl_total_truemoney=xpath=//XCUIElementTypeStaticText[@name="100.00"]
...     lbl_total_truemoney_unit=xpath=//XCUIElementTypeStaticText[@name="บาท"]

&{transaction_statement_text}    lbl_total_unit=รายการ
...     lbl_truemoney=ได้รับเงินโอนจากทรูมันนี่
...     lbl_total_truemoney_unit=บาท