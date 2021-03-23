*** Variables ***
${void_screen}        &{void_screen${OS}}

&{void_screen_ios}              btn_submit=//XCUIElementTypeButton[@name="ยืนยัน"]
...                             lbl_password=//XCUIElementTypeSecureTextField
...                             btn_submit_password=//XCUIElementTypeButton[@name="ยืนยัน"]
...                             lbl_trace_number=//XCUIElementTypeTextField
...                             btn_confirm=//XCUIElementTypeButton[@name="ยืนยัน"]

&{void_screen_android}          btn_submit=id=positiveButton
...                             lbl_password=id=authenticationEditText
...                             btn_submit_password=id=authenticationConfirmButton
...                             lbl_trace_number=id=keyInInfoEditText
...                             btn_confirm=id=keyInInfoConfirmButton
