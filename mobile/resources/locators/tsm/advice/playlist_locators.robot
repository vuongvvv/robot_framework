*** Variables ***
${playlist}              &{playlist_${OS}}

&{playlist_text}       lbl_title=ฟังเรื่องราวดีๆสำหรับร้านค้า
...     lbl_content=ตอนใหม่ทุกๆ พุธ และ อาทิตย์ 20:00น.

&{playlist_android}     lbl_play_list_title=id=tv_play_list_title
...     lbl_play_list_date=id=tv_play_list_date
...     btn_play=id=btn_play_list

&{playlist_ios}     lbl_play_list_title=xpath=(//XCUIElementTypeStaticText[@name="tv_play_list_title"])[1]
...     lbl_play_list_date=xpath=(//XCUIElementTypeStaticText[@name="tv_play_list_date"])[1]
...     btn_play=xpath=(//XCUIElementTypeButton[@name="btn_play_list"])[1]