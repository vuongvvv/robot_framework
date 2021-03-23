*** Settings ***
Documentation       Verify user can access to shop review and displayed review detail from WeShop correctly.
Resource            ../../../../../api/resources/init.robot
Resource            ../../../../../api/keywords/cms/content_resource_keywords.robot
Resource            ../../../../../api/keywords/weshop/weshop_resource_keywords.robot
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/my_shop_keywords.robot
Resource            ../../../../keywords/tsm/shop_profile/shop_review_keywords.robot
Test Setup          Run Keywords    Prepare Shop Content Data     AND    Set Variable Attribute    AND    Open Apps   TSM
Test Teardown       Run Keywords    Delete Content      ${WESHOP_PROJECT_ID}      ${shop_alias}     ${content_id}    AND    Delete Content     ${WESHOP_PROJECT_ID}      ${shop_rating_alias}     ${review_id}       AND     Delete All Sessions     AND     Close Application

*** Variables ***
${thai_id}      1509901018351
${merchant_name}        ทดสอบ_ยอดขายรวม
${tsm_merchant_id}      0024934
${shop_alias}        shop
${shop_rating_alias}        shop-rating
${lbl_no_review}        ร้านของคุณยังไม่มีรีวิว ชักชวนลูกค้าประจำของคุณมารีวิวสิ

*** Keywords ***
Prepare Shop Content Data
    Generate Gateway Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
    Post Create Content     ${WESHOP_PROJECT_ID}      ${shop_alias}     {"data":{"shopNameEn":"Test Total Sale","geo_location":{"longitude":"100.2320531","latitude":"16.7940214","type":"POINT_LOCATION"},"address":"ชั้นGกาดหลวงเซ็นทรัลเชียงราย","tsmMerchantId":"${tsm_merchant_id}","onlineStatus":"true","subCategoryId":"","subCategoryDescription":"","shopMobile":"66-802371084","categoryDescription":"อาหารและเครื่องดื่ม","shopTel":"66-802371084","province":"กรุงเทพมหานคร","logoImage":null,"brandId":"5d6f35193c1239000170b502","district":"สวนหลวง","shopHighlight":"","postCode":"10260","tsmOutletId":"00001","subDistrict":"ในเมือง","shopNameTh":"${merchant_name}","categoryId":"5948d60ee1382323583e31c7","publishStatus":"true"}}
    Get ID Of A Content From List Of Contents

Set Review Date
    ${today}=      Get Current Date
    ${review_date}=      Convert Date       ${today}       result_format=%Y-%m-%dT%H:%M:%S.%fZ
    Set Test Variable     ${review_date}

Prepare Shop Review Content Data
    [Arguments]     ${data}
    Generate Gateway Header    ${ROLE_USER}    ${ROLE_USER_PASSWORD}
    Set Review Date
    Post Create Review      ${content_id}     ${data}
    Get Created ReviewID From Response

Precondition QR Merchant Go To Main EDC Screen
    Tutorial Page Should Be Opened
    Tap On Check Merchant Status Menu
    Check Merchant Status Page Should Be Opened
    Input Thai ID       ${thai_id}
    Submit Check Merchant Status
    Select On Any Merchants     ${merchant_name}
    Input OTP Number    ${OTP_NUMBER}
    Submit OTP Number
    Main EDC Screen Should Be Opened

Set Valiable Attribute
    ${attribute_value}    Set Variable If    '${OS}' == 'ios'    value    text
    Set Suite Variable    ${attribute}    ${attribute_value}

*** Test Cases ***
TC_O2O_12069
    [Documentation]    Verify merchant can see "ดูว่าคนพูดถึงคุณอย่างไร" button dispaly on Shop profile screen correctly
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Capture Page Screenshot    filename=TC_O2O_12069.png

TC_O2O_12070
    [Documentation]    Verify when merchant go to review list page but merchant have no review
    [Tags]    Regression    Medium
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show No Review Message Correctly        ${lbl_no_review}
    Capture Page Screenshot    filename=TC_O2O_12070.png

TC_O2O_12071
    [Documentation]    Verify merchant can see full text review with rating 1 star correctly from reviewers
    [Tags]    Regression    High
    Prepare Shop Review Content Data    {"star":"1","title":"อร่อยมากกก","comment":"สุดยอดดด","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Full Text Review With Rating Star Correctly As     อร่อยมากกก      สุดยอดดด    1.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12071.png

TC_O2O_12072
    [Documentation]    Verify merchant can see full text review with rating 2 star correctly from reviewers
    [Tags]    Regression    High
    Prepare Shop Review Content Data    {"star":"2","title":"อร่อยมากกก","comment":"สุดยอดดด","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Full Text Review With Rating Star Correctly As     อร่อยมากกก      สุดยอดดด    2.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12072.png

TC_O2O_12073
    [Documentation]    Verify merchant can see full text review with rating 3 star correctly from reviewers
    [Tags]    Regression    High
    Prepare Shop Review Content Data    {"star":"3","title":"อร่อยมากกก","comment":"สุดยอดดด","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Full Text Review With Rating Star Correctly As     อร่อยมากกก      สุดยอดดด    3.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12073.png

TC_O2O_12074
    [Documentation]    Verify merchant can see full text review with rating 4 star correctly from reviewers
    [Tags]    Regression    High
    Prepare Shop Review Content Data    {"star":"4","title":"อร่อยมากกก","comment":"สุดยอดดด","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Full Text Review With Rating Star Correctly As     อร่อยมากกก      สุดยอดดด    4.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12074.png

TC_O2O_12075
    [Documentation]    Verify merchant can see full text review with rating 5 star correctly from reviewers
    [Tags]    Regression    High     Smoke      Sanity      E2E
    Prepare Shop Review Content Data    {"star":"5","title":"อร่อยมากกก","comment":"สุดยอดดด","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Full Text Review With Rating Star Correctly As     อร่อยมากกก      สุดยอดดด    5.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12075.png

TC_O2O_12076
    [Documentation]    Verify merchant can see only star rating with 1 star correctly from reviewers
    [Tags]    Regression    High
    Prepare Shop Review Content Data    {"star":"1","title":"","comment":"","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Only Rating Star Correctly As     1.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12076.png

TC_O2O_12077
    [Documentation]    Verify merchant can see only star rating with 2 star correctly from reviewers
    [Tags]    Regression    High
    Prepare Shop Review Content Data    {"star":"2","title":"","comment":"","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Only Rating Star Correctly As     2.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12077.png

TC_O2O_12078
    [Documentation]    Verify merchant can see only star rating with 3 star correctly from reviewers
    [Tags]    Regression    High
    Prepare Shop Review Content Data    {"star":"3","title":"","comment":"","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Only Rating Star Correctly As     3.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12078.png

TC_O2O_12079
    [Documentation]    Verify merchant can see only star rating with 4 star correctly from reviewers
    [Tags]    Regression    High
    Prepare Shop Review Content Data    {"star":"4","title":"","comment":"","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Only Rating Star Correctly As     4.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12079.png

TC_O2O_12080
    [Documentation]    Verify merchant can see only star rating with 5 star correctly from reviewers
    [Tags]    Regression    High     Smoke      Sanity      E2E
    Prepare Shop Review Content Data    {"star":"5","title":"","comment":"","priceRange":"LEVEL1","userAlias":"TRUEID"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Only Rating Star Correctly As     5.0 คะแนน
    Capture Page Screenshot    filename=TC_O2O_12080.png

TC_O2O_13113
    [Documentation]    Verify merchant can see "อ่านเพิ่มเติม" when user have full text review with rating star from reviewers - In case user have comment more than 5 lines
    [Tags]    Regression    Medium
    Prepare Shop Review Content Data    {"star":"5","title":"OK เลย","comment":"ความจริงร้านนี้ก็เคยมาทานตั้งแต่สมัยยังไม่เล่นแอพวงในแล้วแหละ แต่ก็หาโอกาสมาซ้ำในร้านแถวนี้ไม่ได้สักที จนมาวันนี้ได้มาพักไม่ใกล้ ไม่ไกล ย่านนี้มากนัก เลยขอกลับมาซ้ำอีกสักรอบ มาถึงก็ต้องตะลึงกับขนาดร้านที่กว้างใหญ่มาก ทั้งตัวที่นั่งร้าน และบริเวณที่จอดรถ ความจริงร้านนี้ก็เคยมาทานตั้งแต่สมัยยังไม่เล่นแอพวงในแล้วแหละ แต่ก็หาโอกาสมาซ้ำในร้านแถวนี้","priceRange":"LEVEL1","userAlias":"นามสมมุติ"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Show Full Text Review With Rating Star Correctly As     OK เลย      ความจริงร้านนี้ก็เคยมาทานตั้งแต่สมัยยังไม่เล่นแอพวงในแล้วแหละ แต่ก็หาโอกาสมาซ้ำในร้านแถวนี้ไม่ได้สักที จนมาวันนี้ได้มาพักไม่ใกล้ ไม่ไกล ย่านนี้มากนัก เลยขอกลับมาซ้ำอีกสักรอบ มาถึงก็ต้องตะลึงกับขนาดร้านที่กว้างใหญ่มาก ทั้งตัวที่นั่งร้าน และบริเวณที่จอดรถ ความจริงร้านนี้ก็เคยมาทานตั้งแต่สมัยยังไม่เล่นแอพวงในแล้วแหละ แต่ก็หาโอกาสมาซ้ำในร้านแถวนี้    5.0 คะแนน
    Show Read More Button Correctly
    Capture Page Screenshot    filename=TC_O2O_13113.png

TC_O2O_13117
    [Documentation]    Verify merchant can see full review page when user tab on review box In case user have comment less than 5 lines
    [Tags]    Regression    Medium
    Prepare Shop Review Content Data    {"star":"5","title":"OK เลย","comment":"ความจริงร้านนี้ก็เคยมาทานตั้งแต่สมัยยังไม่เล่นแอพวงในแล้วแหละ แต่ก็หาโอกาสมาซ้ำในร้านแถวนี้ไม่ได้สักที จนมาวันนี้ได้มาพักไม่ใกล้ ไม่ไกล ย่านนี้มากนัก เลยขอกลับมาซ้ำอีกสักรอบ มาถึงก็ต้องตะลึงกับขนาดร้านที่กว้างใหญ่มาก ทั้งตัวที่นั่งร้าน และบริเวณที่จอดรถ ความจริงร้านนี้ก็เคยมาทานตั้งแต่สมัยยังไม่เล่นแอพวงในแล้วแหละ แต่ก็หาโอกาสมาซ้ำในร้านแถวนี้","priceRange":"LEVEL1","userAlias":"นามสมมุติ"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Tab On Review Box
    Show Full Review Page Correctly
    Capture Page Screenshot    filename=TC_O2O_13117

TC_O2O_13118
    [Documentation]    Verify merchant can see full review page when user tab on "อ่านเพิ่มเติม" In case user have comment more than 5 lines
    [Tags]    Regression    High     Smoke      Sanity      E2E
    Prepare Shop Review Content Data    {"star":"5","title":"OK เลย","comment":"ความจริงร้านนี้ก็เคยมาทานตั้งแต่สมัยยังไม่เล่นแอพวงในแล้วแหละ แต่ก็หาโอกาสมาซ้ำในร้านแถวนี้ไม่ได้สักที จนมาวันนี้ได้มาพักไม่ใกล้ ไม่ไกล ย่านนี้มากนัก เลยขอกลับมาซ้ำอีกสักรอบ มาถึงก็ต้องตะลึงกับขนาดร้านที่กว้างใหญ่มาก ทั้งตัวที่นั่งร้าน และบริเวณที่จอดรถ ความจริงร้านนี้ก็เคยมาทานตั้งแต่สมัยยังไม่เล่นแอพวงในแล้วแหละ แต่ก็หาโอกาสมาซ้ำในร้านแถวนี้","priceRange":"LEVEL1","userAlias":"นามสมมุติ"}
    Precondition QR Merchant Go To Main EDC Screen
    Tap On Sell Online Menu
    Shop Profile Page Should Be Opened
    Show Preview Review Button Component Correctly
    Tap On Preview Review Button
    Review List Page Should Be Opened
    Tab On Read More
    Show Full Review Page Correctly
    Capture Page Screenshot    filename=TC_O2O_13118
