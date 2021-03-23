*** Variables ***
${report_menu}              &{report_menu_${OS}}
${settlement_screen}        &{settlement_screen${OS}}
${summary_screen}           &{summary_screen${OS}}

&{report_menu_ios}              btn_settlement_report=xpath=//XCUIElementTypeStaticText[@name="สรุปยอดรายวัน (Settlement Report)"]
...                             txt_password=xpath=//XCUIElementTypeSecureTextField
...                             btn_password_submit=xpath=//XCUIElementTypeButton[@name="ยืนยัน"]
...                             btn_summary_report=xpath=//XCUIElementTypeStaticText[@name="สรุปยอดรายการทั้งหมด (Summary Report)"]
...                             btn_details_report=xpath=//XCUIElementTypeStaticText[@name="รายละเอียดรายการ"]

&{report_menu_android}          btn_settlement_report=xpath=//android.widget.FrameLayout[1]/android.widget.TextView
...                             txt_password=id=authenticationEditText
...                             btn_password_submit=id=authenticationConfirmButton
...                             btn_summary_report=xpath=//android.widget.FrameLayout[2]/android.widget.TextView
...                             btn_details_report=xpath=//android.widget.FrameLayout[3]/android.widget.TextView
...                             btn_details=id=reportDetailButton

&{settlement_screen_ios}        lbl_all_points=xpath=//XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[5]/XCUIElementTypeStaticText[2]
...                             lbl_bath=xpath=//XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[4]/XCUIElementTypeStaticText[2]
...                             lbl_trace_no=xpath=//XCUIElementTypeScrollView//XCUIElementTypeOther[3]/XCUIElementTypeStaticText[2]
...                             btn_print_summary=xpath=//XCUIElementTypeButton[@name="กลับหน้าหลัก"]
...                             lbl_all_points_value=xpath=//XCUIElementTypeTable/XCUIElementTypeCell[4]/XCUIElementTypeStaticText
...                             lbl_baht_value=xpath=//XCUIElementTypeTable/XCUIElementTypeCell[4]/XCUIElementTypeStaticText[3]
...                             btn_settlement_report=xpath=//XCUIElementTypeButton[@name="ยืนยันสรุปยอดรายวัน"]
...                             btn_dialog_submit=xpath=//XCUIElementTypeButton[@name="ยืนยัน"]
...                             lbl_print_summary_header=xpath=//XCUIElementTypeStaticText[@name="สรุปยอดเรียบร้อยแล้ว"]
...                             lbl_print_summary_tid=xpath=//XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]/XCUIElementTypeStaticText
...                             lbl_print_summary_mid=xpath=//XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]/XCUIElementTypeStaticText[3]
...                             lbl_print_summary_points=xpath=//XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[3]/XCUIElementTypeStaticText[2]
...                             btn_back_home=xpath=//XCUIElementTypeButton[@name="กลับหน้าหลัก"]

&{settlement_screen_android}    lbl_all_points=xpath=//android.support.v7.widget.au[3]/android.view.ViewGroup/android.widget.TextView[2]
...                             lbl_bath=xpath=//android.support.v7.widget.au[4]/android.view.ViewGroup/android.widget.TextView[2]
...                             lbl_trace_no=xpath=//android.support.v7.widget.au[3]/android.view.ViewGroup/android.widget.TextView[2]
...                             btn_print_summary=id=printSummaryCancelReceiptButton
...                             lbl_all_points_value=xpath=//android.support.v7.widget.au[3]/android.view.ViewGroup/android.widget.TextView[2]
...                             lbl_baht_value=xpath=//android.support.v7.widget.au[4]/android.view.ViewGroup/android.widget.TextView[2]
...                             btn_settlement_report=id=reportSettlementButton
...                             btn_dialog_submit=id=dialogInfoPositiveButton
...                             lbl_print_summary_header=id=printSummaryHeaderTitleTextView
...                             lbl_print_summary_tid=id=leftSideTextView
...                             lbl_print_summary_mid=id=rightSideTextView
...                             lbl_print_summary_points=xpath=//android.support.v7.widget.au[3]/android.view.ViewGroup/android.widget.TextView[2]
...                             btn_back_home=id=printSummaryCancelReceiptButton

&{summary_screen_android}       btn_back=xpath=//android.widget.ImageButton
...                             lbl_total_point=xpath=//android.support.v7.widget.au[3]/android.view.ViewGroup/android.widget.TextView[2]
...                             lbl_total_baht=xpath=//android.support.v7.widget.au[5]/android.view.ViewGroup/android.widget.TextView[2]

&{summary_screen_ios}           btn_back=xpath=//XCUIElementTypeNavigationBar/XCUIElementTypeButton
...                             lbl_total_point=xpath=//XCUIElementTypeStaticText
...                             lbl_total_baht=xpath=//XCUIElementTypeStaticText[5]
