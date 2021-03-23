*** Variables ***
${circleRed}              &{circleRed_${OS}}
${verify_trueid}          &{verify_trueid_${OS}}
${verify_true_card}       &{verify_true_card_${OS}}
${summary_result}         &{summary_result_${OS}}

&{circleRed_ios}          btn_circle_thai_id=xpath=(//XCUIElementTypeButton[@name="circleRed"])[1]
...                      btn_circle_true_card=xpath=(//XCUIElementTypeButton[@name="circleRed"])[2]

&{circleRed_android}      btn_circle_thai_id=xpath=//android.support.v7.widget.au[1]/android.widget.LinearLayout/android.widget.ImageView
...                      btn_circle_true_card=xpath=//android.support.v7.widget.au[2]/android.widget.LinearLayout/android.widget.ImageView

&{verify_trueid_ios}      txt_thai_id=xpath=//XCUIElementTypeTextField
...                       btn_submit_thai_id=xpath=//XCUIElementTypeButton[@name="ยืนยัน"]

&{verify_trueid_android}  txt_thai_id=id=keyInInfoEditText
...                       btn_submit_thai_id=id=keyInInfoConfirmButton

&{verify_true_card_ios}     txt_true_card_id=xpath=//XCUIElementTypeTextField
...                         btn_submit_true_card=xpath=//XCUIElementTypeButton[@name="ยืนยัน"]

&{verify_true_card_android}    txt_true_card_id=id=keyInInfoEditText
...                            btn_submit_true_card=id=keyInInfoConfirmButton

&{summary_result_ios}          btn_back_dashboard=xpath=//XCUIElementTypeButton[@name="กลับหน้าหลัก"]
&{summary_result_android}      btn_back_dashboard=id=checkStatusBackToHomeButton
