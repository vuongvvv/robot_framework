*** Variables ***
${tutorial}              &{tutorial_${OS}}

&{tutorial_ios}     tutorail_page=xpath=//XCUIElementTypeButton[@name="เปิดร้านใหม่กับ ทรู พอยท์แอนด์เพย์"]
...     txt_tutorial_title=id=tutorialPageTitleTextView
...     txt_tutorial_description=id=tutorialPageDescriptionTextView
...     btn_registration=xpath=//XCUIElementTypeButton[@name="เปิดร้านใหม่กับ ทรู พอยท์แอนด์เพย์"]
...     btn_activation_code=xpath=//XCUIElementTypeButton[contains(@name,"กรอกรหัสเพื่อเข้าใช้งาน")]
...     btn_check_merchant_status=xpath=//XCUIElementTypeButton[contains(@name,"หมายเลขบัตรประชาชน")]

&{tutorial_android}     tutorail_page=id=tutorialViewPager
...     txt_tutorial_title=id=tutorialPageTitleTextView
...     txt_tutorial_description=id=tutorialPageDescriptionTextView
...     btn_registration=id=tutorialRegisterButton
...     btn_activation_code=tutorialNegativeButtonTitle
...     btn_check_merchant_status=id=tutorialPositiveButtonTitle

&{tutorial_menu}     lbl_merchant_registration=เปิดร้านใหม่กับ ทรู พอยท์แอนด์เพย์
...     lbl_activation_code=มีร้านอยู่แล้ว\nกรอกรหัสเพื่อเข้าใช้งาน
...     lbl_check_merchant_status=มีร้านอยู่แล้วค้นหาร้านจาก\nหมายเลขบัตรประชาชน

&{tutorial_promotion_page}     lbl_promotion=ช่วยทำโปรโมชั่น
...     lbl_description_promotion=เรียกลูกคาเพิ่มยอดขาย ดวยฟงกชั่น สงเสริมการขายครบวงจร