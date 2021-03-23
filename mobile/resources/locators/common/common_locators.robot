*** Variables ***
${keyboard}               &{keyboard_${OS}}
${tbl_list}               &{tbl_list_${OS}}
${alert}                  &{alert_${OS}}

&{alert_ios}    page_alert=//UIAAlert
...     btn_ok=OK
...     btn_allow=Allow
&{alert_android}    page_alert=android=new UiSelector().resourceId("com.android.packageinstaller:id/dialog_container")
...     btn_ok=id=tv_dialog_positive
...     btn_allow=android=new UiSelector().resourceId("com.android.packageinstaller:id/permission_allow_button")

&{keyboard_ios}           keyboard_done=id=Toolbar Done Button
...                       btn_go=xpath=//XCUIElementTypeButton[@name="Go"]
&{keyboard_android}       btn_accept_permission=id=com.android.packageinstaller:id/permission_allow_button

&{tbl_list_ios}
&{tbl_list_android}
