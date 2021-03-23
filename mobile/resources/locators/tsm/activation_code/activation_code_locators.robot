*** Variables ***
${activation_screen}              &{activation_screen_${OS}}

&{activation_screen_ios}     txt_activation_code=xpath=//XCUIElementTypeTextField
...     txt_activation_password=xpath=//XCUIElementTypeSecureTextField
...     txt_activation_confirm=xpath=//XCUIElementTypeOther[3]//XCUIElementTypeSecureTextField
...     btn_accept_permission=xpath=//XCUIElementTypeButton[@name="Allow"]
...     btn_confirm_submit=xpath=//XCUIElementTypeButton[@name="ยืนยัน"]
...     btn_start=xpath=//XCUIElementTypeButton[@name="เริ่มใช้งาน"]

&{activation_screen_android}     txt_activation_code=id=activateCodeEditText
...     txt_activation_password=id=activatePasswordEditText
...     txt_activation_confirm=id=activateConfirmPasswordEditText
...     btn_confirm_submit=id=activateCodeConfirmButton
...     btn_start=id=finishResultButton
...     btn_accept_permission=id=com.android.packageinstaller:id/permission_allow_button
