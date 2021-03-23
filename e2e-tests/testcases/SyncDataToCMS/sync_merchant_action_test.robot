*** Settings ***
Documentation    Tests to verify that publishMerchantCreatedEvent api works correctly

Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/common/dummy_data_common.robot
Resource    ../../../api/keywords/common/api_common.robot
Resource    ../../../api/keywords/merchant_publisher/merchant_message_keywords.robot
Resource    ../../../api/keywords/cms/content_resource_keywords.robot

Resource    ../../../web/resources/init.robot
Resource    ../../../web/keywords/admintools/common/common_keywords.robot
Resource    ../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../web/keywords/admintools/main_page/menu_keywords.robot
Resource    ../../../web/keywords/admintools/merchant_edit_mysql/merchant_edit_mysql_keyworks.robot

Resource    ../../../api/resources/testdata/${ENV}/merchant/merchant_data.robot
Resource    ../../../api/keywords/cms/content_resource_keywords.robot

# scope: merchantTx.create
# User group: Merchant Edit & History User Group: merchant.entityAudit.actAsAdmin,merchant.merchant.actAsAdmin,merchant.outlet.actAsAdmin
Test Setup    Run Keywords    Generate Robot Automation Header    ${ROLE_USER_SYNC_DATA_TO_CMS}    ${ROLE_USER_SYNC_DATA_TO_CMS_PASSWORD}
...    AND    Prepare For Creating Merchant
Test Teardown    Run Keywords    Delete Content    ${WESHOP_PROJECT_ID}    brand    ${content_id}
...    AND    Delete All Sessions

*** Variables ***
${create_merchant_json}    ../../resources/testdata/merchant_publisher/publish_merchant_created_event.json
${update_merchant_json}    ../../resources/testdata/merchant_publisher/publish_merchant_updated_event.json
#merchant variable (Brand content on CMS)
${merchant_name_th_for_update_data}              ม่านตา
${merchant_name_en_for_update_data}              Iris
${firstname_for_update_data}                     Ascend
${lastname_for_update_data}                      Iris
${merchant_website_for_update_data}              www.iris.com
${merchant_facebook_for_update_data}             www.facebook.com/iris
${merchant_instagram_for_update_data}            https://www.instagram.com/iris
${merchant_twitter_for_update_data}              https://twitter.com/iris
${merchant_line_for_update_data}                 https://page.line.me/iris
${merchant_phone_no_for_update_data}             080123456
${merchant_mobile_no_for_update_data}            0821022951
#CMS variable
${project_name}                                  WeShop

*** Test Cases ***
TC_O2O_10766
    [Documentation]    Verify that the new merchant information will be synchronized to CMS after creating merchant through API
    [Tags]    Regression    High
    Read Json From File    ${create_merchant_json}
    Post Publish Merchant Created Event    ${NULL}    ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    [0].data.merchantId
    ...    ${json_dummy_data['id']}    180    ${WESHOP_PROJECT_ID}    brand
    ...    data.merchantId=${json_dummy_data['id']}
    Response Correct Code    ${SUCCESS_CODE}
    Get ID Of A Content From List Of Contents    ${0}
    Get Content    ${WESHOP_PROJECT_ID}    brand    ${content_id}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced Data Of Brand Content On CMS    ${json_dummy_data}

TC_O2O_11194
    [Documentation]    Verify that the updated merchant information will be synchronized to CMS after updating merchant through API
    [Tags]    Regression    High
    Prepare For Update Merchant
    Read Json From File    ${update_merchant_json}
    Put Publish Merchant Updated Event    ${NULL}    ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    [0].data.nameEn
    ...    ${json_dummy_data['storeNameEn']}    180    ${WESHOP_PROJECT_ID}    brand
    ...    data.merchantId=${json_dummy_data['id']}
    Response Correct Code    ${SUCCESS_CODE}
    Get ID Of A Content From List Of Contents    ${0}
    Get Content    ${WESHOP_PROJECT_ID}    brand    ${content_id}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced Data Of Brand Content On CMS    ${json_dummy_data}

TC_O2O_11196
    [Documentation]    [E2E] - Verify that the updated merchant information will be synchronized to CMS after updating merchant through Admin tool
    [Tags]    Regression    High    E2E    admintools    cms    rpp-merchant
    [Setup]    Run Keywords    Generate Robot Automation Header    ${ROLE_USER_SYNC_DATA_TO_CMS}    ${ROLE_USER_SYNC_DATA_TO_CMS_PASSWORD}    gateway=we-platform
    ...    AND    Open Browser With Option    ${ADMIN_TOOLS_URL}
    ...    AND    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
    ...    AND    Navigate On Left Menu Bar    Merchant Edit (MySQL)     Merchant
    Search Merchant By Thai Merchant Name    ร้านแพนเค้กของออโตเมทพูล
    Open Edit Merchant Popup From 1st Merchant
    Get Merchant Information On Edit Merchant Popup
    
    # update merchant information
    Update Merchant Information On Edit Merchant Popup    merchant_name_th=${merchant_name_th_for_update_data}
    ...    merchant_name_en=${merchant_name_en_for_update_data}
    ...    firstname=${firstname_for_update_data}
    ...    lastname=${lastname_for_update_data}
    ...    merchant_website=${merchant_website_for_update_data}
    ...    merchant_facebook=${merchant_facebook_for_update_data}
    ...    merchant_instagram=${merchant_instagram_for_update_data}
    ...    merchant_twitter=${merchant_twitter_for_update_data}
    ...    merchant_line=${merchant_line_for_update_data}
    ...    merchant_phone_no=${merchant_phone_no_for_update_data}
    ...    merchant_mobile_no=${merchant_mobile_no_for_update_data}
    # verify data on cms
    Get All Content    ${TEST_DATA_CMS_WE_SHOP_PROJECT_ID}    brand    data.tsmMerchantId=${TEST_DATA_MERCHANT_ID_BEFORE_UPDATE}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .id    TEST_DATA_FROM_CMS
    Wait Data To Sync On Cms    ${TEST_DATA_CMS_WE_SHOP_PROJECT_ID}    brand    ${TEST_DATA_FROM_CMS}    .data.nameTh    ${merchant_name_th_for_update_data}
    Get Content    ${TEST_DATA_CMS_WE_SHOP_PROJECT_ID}    brand    ${TEST_DATA_FROM_CMS}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    .data.nameTh    ${merchant_name_th_for_update_data}
    Response Property Should Be Equal As String    .data.nameEn    ${merchant_name_en_for_update_data}
    Response Property Should Be Equal As String    .data.socialWebsite    ${merchant_website_for_update_data}
    Response Property Should Be Equal As String    .data.socialFacebook    ${merchant_facebook_for_update_data}
    Response Property Should Be Equal As String    .data.socialInstagram    ${merchant_instagram_for_update_data}
    Response Property Should Be Equal As String    .data.socialTwitter    ${merchant_twitter_for_update_data}
    Response Property Should Be Equal As String    .data.socialLine    ${merchant_line_for_update_data}
    
    # change merchant information back
    Search Merchant By Thai Merchant Name    ${merchant_name_th_for_update_data}
    Open Edit Merchant Popup From 1st Merchant
    Update Merchant Information On Edit Merchant Popup    merchant_name_th=${TEST_DATA_MERCHANT_NAME_TH_BEFORE_UPDATE}
    ...    merchant_name_en=${TEST_DATA_MERCHANT_NAME_EN_BEFORE_UPDATE}
    ...    firstname=${TEST_DATA_FIRSTNAME_BEFORE_UPDATE}
    ...    lastname=${TEST_DATA_LASTNAME_BEFORE_UPDATE}
    ...    merchant_website=${TEST_DATA_MERCHANT_WEBSITE_BEFORE_UPDATE}
    ...    merchant_facebook=${TEST_DATA_MERCHANT_FACEBOOK_BEFORE_UPDATE}
    ...    merchant_instagram=${TEST_DATA_MERCHANT_INSTAGRAM_BEFORE_UPDATE}
    ...    merchant_twitter=${TEST_DATA_MERCHANT_TWITTER_BEFORE_UPDATE}
    ...    merchant_line=${TEST_DATA_MERCHANT_LINE_BEFORE_UPDATE_DATA}
    ...    merchant_phone_no=${merchant_phone_no_for_update_data}
    ...    merchant_mobile_no=${merchant_mobile_no_for_update_data}

    [Teardown]    Run Keywords    Delete All Sessions    
    ...    AND    Clean Environment
