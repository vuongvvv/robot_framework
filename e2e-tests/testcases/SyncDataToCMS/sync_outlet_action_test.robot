*** Settings ***
Documentation    Tests to verify that publishOutletCreatedEvent api works correctly

Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/common/dummy_data_common.robot
Resource    ../../../api/keywords/common/api_common.robot
Resource    ../../../api/keywords/merchant_publisher/outlet_message_resource_keywords.robot
Resource    ../../../api/keywords/cms/content_resource_keywords.robot

Resource    ../../../web/resources/init.robot
Resource    ../../../web/keywords/admintools/common/common_keywords.robot
Resource    ../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../web/keywords/admintools/main_page/menu_keywords.robot
Resource    ../../../web/keywords/admintools/merchant_edit_mysql/merchant_edit_mysql_keyworks.robot

Resource    ../../../api/resources/testdata/${ENV}/merchant/merchant_data.robot
Resource    ../../../api/keywords/cms/content_resource_keywords.robot

Test Setup    Run Keywords    Generate Gateway Header With Scope and Permission    ${ROLE_USER_SYNC_DATA_TO_CMS}    ${ROLE_USER_SYNC_DATA_TO_CMS_PASSWORD}    merchantTx.create,merchant.address.read    permission_name=merchant.merchant.actAsAdmin,merchant.address.actAsAdmin    AND    Prepare For Creating Outlet
Test Teardown      Run Keywords    Delete Content    ${WESHOP_PROJECT_ID}    shop    ${content_id}    AND    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${create_outlet_json_v1}    ../../resources/testdata/merchant_publisher/publish_outlet_created_event_v1.json
${create_outlet_json_v2}    ../../resources/testdata/merchant_publisher/publish_outlet_created_event_v2.json
${update_outlet_json_v1}    ../../resources/testdata/merchant_publisher/pub_outlet_updated_event_v1.json
${update_outlet_json_v2}    ../../resources/testdata/merchant_publisher/pub_outlet_updated_event_v2.json
#merchant variable (Brand content on CMS)
${outlet_name_th_for_update_data}              ม่านตา
${outlet_name_en_for_update_data}              Iris
${outlet_contact_firstname_for_update_data}    Ascend
${outlet_contact_lastname_for_update_data}     Iris
${outlet_description_for_update_data}          Iris Memory
${outlet_contact_email_for_update_data}        ecom-squad-iris@ascendcorp.com
${outlet_contact_phone_no_for_update_data}     080123456
${outlet_contact_mobile_no_for_update_data}    08-012345651
#CMS variable
${project_name}                                WeShop

*** Test Cases ***
TC_O2O_10770
    [Documentation]    Verify that the new outlet information will be synchronized to CMS after creating outlet through API V1
    [Tags]    Regression    High
    Prepare JSON For Outlet
    Post Publish Outlets Created Event   ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    $[0].data.tsmMerchantId
    ...    ${json_dummy_data['merchantBrandId']}    20    ${WESHOP_PROJECT_ID}    shop
    ...    tsmMerchantId=${json_dummy_data['merchantBrandId']}&tsmOutletId=${json_dummy_data['outletId']}
    Response Correct Code    ${SUCCESS_CODE}
    Get ID Of A Content From List Of Contents    ${0}
    Get Content    ${WESHOP_PROJECT_ID}    shop    ${content_id}
    Response Correct Code    ${SUCCESS_CODE}
    Log To Console    ${json_dummy_data}
    Verify Synced V1 Data Of Shop Content On CMS    ${WESHOP_PROJECT_ID}    ${json_dummy_data}

TC_O2O_10772
    [Documentation]    Verify that the new outlet information will be synchronized to CMS after creating outlet through API V2
    [Tags]    Regression    High
    Prepare JSON For Outlet    ${create_outlet_json_v2}
    Post Publish Outlet V2 Created Event    CREATE    ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    $[0].data.tsmMerchantId
    ...    ${json_dummy_data['merchantBrandId']}    20    ${WESHOP_PROJECT_ID}    shop
    ...    tsmMerchantId=${json_dummy_data['merchantBrandId']}&tsmOutletId=${json_dummy_data['outletId']}
    Response Correct Code      ${SUCCESS_CODE}
    Get ID Of A Content From List Of Contents    ${0}
    Get Content    ${WESHOP_PROJECT_ID}    shop    ${content_id}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced V2 Data Of Shop Content On CMS    ${WESHOP_PROJECT_ID}    ${json_dummy_data}

TC_O2O_10774
    [Documentation]    Verify that the updated outlet information will be synchronized to CMS after updating outlet through API V1
    [Tags]    Regression    High
    Prepare For Update OutletV1
    Prepare JSON For Outlet    ${update_outlet_json_v1}
    Put Publish Outlets Updated Event    ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    $[0].data.shopNameEn
    ...    ${json_dummy_data['outletNameEn']}    180    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}
    Response Correct Code      ${SUCCESS_CODE}
    Get ID Of A Content From List Of Contents    ${0}
    Get Content    ${WESHOP_PROJECT_ID}    shop    ${content_id}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced V1 Data Of Shop Content On CMS    ${WESHOP_PROJECT_ID}    ${json_dummy_data}

TC_O2O_10776
    [Documentation]    Verify that the updated outlet information will be synchronized to CMS after updating outlet through API V2
    [Tags]    Regression    High
    [Teardown]      Run Keywords    Delete Content    ${WESHOP_PROJECT_ID}    shop    ${shop_1_id}
    ...    AND    Delete Content    ${WESHOP_PROJECT_ID}    shop    ${shop_2_id}
    ...    AND    Delete Created Client And User Group    AND    Delete All Sessions
    Prepare For Update OutletV2
    Prepare JSON For Outlet    ${update_outlet_json_v2}
    Put Publish Outlet V2 Updated Event    UPDATE   ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    [0].data.shopNameEn
    ...    ${json_dummy_data['outletNameEn']}    180    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}
    Response Correct Code      ${SUCCESS_CODE}
    Get ID Of A Content From List Of Contents    ${0}
    Get Content    ${WESHOP_PROJECT_ID}    shop    ${content_id}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced V2 Data Of Shop Content On CMS    ${WESHOP_PROJECT_ID}    ${json_dummy_data}
    Set Test Variable For Shop ID    shop_index=${1}
    Prepare JSON For Outlet    ${update_outlet_json_v2}    ${1}
    Put Publish Outlet V2 Updated Event    UPDATE   ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    data..shopNameEn
    ...    ${json_dummy_data['outletNameEn']}    180    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}
    Response Correct Code      ${SUCCESS_CODE}
    Get ID Of A Content From List Of Contents    ${1}
    Get Content    ${WESHOP_PROJECT_ID}    shop    ${content_id}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced V2 Data Of Shop Content On CMS    ${WESHOP_PROJECT_ID}    ${json_dummy_data}
    Set Test Variable For Shop ID    shop_index=${2}

TC_O2O_11967
    [Documentation]    Verify that the new outlet information will be synchronized to CMS after creating by API v2 in case merchant has already an outlet
    [Tags]    Regression    High
    [Teardown]      Run Keywords    Delete Content    ${WESHOP_PROJECT_ID}    shop    ${shop_1_id}
        ...    AND    Delete Content    ${WESHOP_PROJECT_ID}    shop    ${shop_2_id}
        ...    AND    Delete Created Client And User Group    AND    Delete All Sessions
    Prepare JSON For Outlet    ${create_outlet_json_v2}
    Post Publish Outlet V2 Created Event    CREATE    ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    $[0].data.tsmMerchantId
    ...    ${json_dummy_data['merchantBrandId']}    180    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}
    Response Correct Code      ${SUCCESS_CODE}
    Get ID Of A Content From List Of Contents    ${0}
    Get Content    ${WESHOP_PROJECT_ID}    shop    ${content_id}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced V2 Data Of Shop Content On CMS    ${WESHOP_PROJECT_ID}    ${json_dummy_data}
    Set Test Variable For Shop ID    shop_index=${1}
    Prepare JSON For Outlet    ${create_outlet_json_v2}    ${1}
    Post Publish Outlet V2 Created Event    CREATE    ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    $[1].data.tsmMerchantId
    ...    ${json_dummy_data['merchantBrandId']}    180    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}
    Response Correct Code      ${SUCCESS_CODE}
    Get ID Of A Content From List Of Contents    ${0}
    Get Content    ${WESHOP_PROJECT_ID}    shop    ${content_id}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced V2 Data Of Shop Content On CMS    ${WESHOP_PROJECT_ID}    ${json_dummy_data}
    Set Test Variable For Shop ID    shop_index=${2}

TC_O2O_11208
    [Documentation]    [E2E] - Verify that the updated outlet information will be synchronized to CMS after updating outlet through Admin tool
    [Tags]    Regression    High    E2E    admintools    cms    rpp-merchant
    [Setup]    Run Keywords    Generate Robot Automation Header    ${ROLE_USER_SYNC_DATA_TO_CMS}    ${ROLE_USER_SYNC_DATA_TO_CMS_PASSWORD}    gateway=we-platform
    ...    AND    Open Browser With Option    ${ADMIN_TOOLS_URL}
    ...    AND    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
    ...    AND    Navigate On Left Menu Bar    Merchant Edit (MySQL)     Outlet
    Search Outlet By Thai Outlet Name    แพนเค้ก เอ้าท์เล็ท
    Get BrandId Of Outlet
    Open Edit Outlet Popup From 1st Outlet
    Get Outlet Information On Edit Outlet Popup
    Update Outlet Information On Edit Outlet Popup     outlet_name_th_for_update=${outlet_name_th_for_update_data}
    ...    outlet_name_en_for_update=${outlet_name_en_for_update_data}
    ...    outlet_contact_firstname_for_update=${outlet_contact_firstname_for_update_data}
    ...    outlet_contact_lastname_for_update=${outlet_contact_lastname_for_update_data}
    ...    outlet_description_for_update=${outlet_description_for_update_data}
    ...    outlet_contact_email_for_update=${outlet_contact_email_for_update_data}
    ...    outlet_contact_phone_no_for_update=${outlet_contact_phone_no_for_update_data}
    ...    outlet_contact_mobile_no_for_update=${outlet_contact_mobile_no_for_update_data}
    
    # verify data on cms
    Get All Content    ${TEST_DATA_CMS_WE_SHOP_PROJECT_ID}    shop    data.shopNameEn=${outlet_name_en_for_update_data}&sort=lastModifiedDate,desc
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .id    TEST_DATA_FROM_CMS
    Wait Data To Sync On Cms    ${TEST_DATA_CMS_WE_SHOP_PROJECT_ID}    shop    ${TEST_DATA_FROM_CMS}    .data.shopNameEn    ${outlet_name_en_for_update_data}
    Get Content    ${TEST_DATA_CMS_WE_SHOP_PROJECT_ID}    shop    ${TEST_DATA_FROM_CMS}
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    .data.shopNameEn    ${outlet_name_en_for_update_data}
    Response Property Should Be Equal As String    .data.shopNameTh    ${outlet_name_th_for_update_data}
    Response Property Should Be Equal As String    .data.shopHighlight    ${outlet_description_for_update_data}
    Response Property Should Be Equal As String    .data.shopTel    ${outlet_contact_phone_no_for_update_data}
    Response Property Should Be Equal As String    .data.shopMobile    ${outlet_contact_mobile_no_for_update_data}
    
    # change merchant information back
    Search Outlet By Thai Outlet Name    ${outlet_name_th_for_update_data}
    Get BrandId Of Outlet
    Open Edit Outlet Popup From 1st Outlet
    Update Outlet Information On Edit Outlet Popup     outlet_name_th_for_update=${TEST_DATA_OUTLET_NAME_TH_BEFORE_UPDATE}
    ...    outlet_name_en_for_update=${TEST_DATA_OUTLET_NAME_EN_BEFORE_UPDATE}
    ...    outlet_contact_firstname_for_update=${TEST_DATA_OUTLET_CONTACT_FIRSTNAME_BEFORE_UPDATE}
    ...    outlet_contact_lastname_for_update=${TEST_DATA_OUTLET_CONTACT_LASTNAME_BEFORE_UPDATE}
    ...    outlet_description_for_update=${TEST_DATA_OUTLET_DESCRIPTION_BEFORE_UPDATE}
    ...    outlet_contact_email_for_update=${TEST_DATA_OUTLET_CONTACT_EMAIL_BEFORE_UPDATE}
    ...    outlet_contact_phone_no_for_update=${TEST_DATA_OUTLET_CONTACT_PHONE_NO_BEFORE_UPDATE}
    ...    outlet_contact_mobile_no_for_update=${TEST_DATA_OUTLET_CONTACT_MOBILE_NO_BEFORE_UPDATE}
    
    [Teardown]    Run Keywords    Delete All Sessions    
    ...    AND    Clean Environment