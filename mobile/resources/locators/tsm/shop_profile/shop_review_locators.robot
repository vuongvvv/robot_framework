*** Variables ***
${shop_review}       &{shop_review_${OS}}

&{shop_review_ios}      lbl_review_snapshot=xpath=//XCUIElementTypeStaticText[@name="คะแนนร้านของคุณจาก Weshop"]
...     lbl_average_review=id=txtAverageRating
...     lbl_number_of_review=id=txtCountReview
...     icon_review_star_1=id=ImageOneStar
...     icon_review_star_2=id=ImageTwoStar
...     icon_review_star_3=id=ImageThreeStar
...     icon_review_star_4=id=ImageFourStar
...     icon_review_star_5=id=ImageFiveStar
...     lbl_no_review=xpath=//XCUIElementTypeTable[@name="ร้านของคุณยังไม่มีรีวิว ชักชวนลูกค้าประจำของคุณมารีวิวสิ"]
...     lbl_reviewlist_title=xpath=(//XCUIElementTypeStaticText[@name="txtTitleReviewList"])[1]
...     lbl_reviewlist_comment=xpath=(//XCUIElementTypeStaticText[@name="txtContentReviewList"])[1]
...     lbl_reviewlist_rating=xpath=(//XCUIElementTypeStaticText[@name="txtPointReview"])[1]
...     btn_preview_review=xpath=//XCUIElementTypeButton[@name="ดูว่าคนพูดถึงคุณอย่างไร"]

&{shop_review_android}     lbl_review_snapshot=xpath=//android.widget.TextView[@text="คะแนนร้านของคุณจาก Weshop"]
...     lbl_average_review=id=txtAverageRating
...     lbl_score_text=id=txtScoreView
...     lbl_number_of_review=id=txtCountReview
...     icon_review_star_1=id=ImageOneStar
...     icon_review_star_2=id=ImageTwoStar
...     icon_review_star_3=id=ImageThreeStar
...     icon_review_star_4=id=ImageFourStar
...     icon_review_star_5=id=ImageFiveStar
...     lbl_no_review=id=txtMerchantNoReview
...     lbl_reviewlist_title=xpath=//android.view.ViewGroup[0]//android.widget.TextView[@id="txtTitleReviewList"]
...     lbl_reviewlist_comment=xpath=//android.view.ViewGroup[0]//android.widget.TextView[@id="txtContentReviewList"]
...     lbl_reviewlist_rating=xpath=//android.view.ViewGroup[0]//android.widget.TextView[@id="txtRatingReview"]
...     btn_preview_review=id=btnUserReview

&{shop_review_text}     btn_preview_review=ดูว่าคนพูดถึงคุณอย่างไร
...     title=คะแนนร้านของคุณจาก WeShop