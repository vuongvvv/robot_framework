*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot
Resource    ../common/dummy_data_common.robot
Resource    ../rpp_merchant/merchant_resource_keywords.robot
Resource    ../rpp_merchant/address_resource_keywords.robot
Resource    ../merchant_publisher/outlet_message_resource_keywords.robot
Resource    ../merchant_publisher/merchant_message_keywords.robot

*** Variables ***
${create_merchant_json}    ../../resources/testdata/merchant_publisher/publish_merchant_created_event.json
${create_outlet_json_v1}    ../../resources/testdata/merchant_publisher/publish_outlet_created_event_v1.json
${create_outlet_json_v2}    ../../resources/testdata/merchant_publisher/publish_outlet_created_event_v2.json

*** Keywords ***
Post Create Content
    [Arguments]    ${project_id}      ${alias}      ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /cms/api/projects/${project_id}/c/${alias}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1060143218/API+Get+All+Contents+by+Alias
Get All Content
    [Arguments]    ${projectId}    ${alias}    ${param_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /cms/api/projects/${projectId}/c/${alias}
    ...    params=${param_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Content
    [Arguments]    ${projectId}    ${alias}    ${id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /cms/api/projects/${projectId}/c/${alias}/${id}
    ...    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Content
    [Arguments]    ${projectId}    ${alias}    ${id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    /cms/api/projects/${projectId}/c/${alias}/${id}
    ...    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Wait Data To Sync On Cms
    [Arguments]    ${project_id}    ${alias}    ${content_id}    ${waited_data}    ${waited_value}    ${maximum_wait_time}=30
    FOR    ${index}    IN RANGE    1    ${maximum_wait_time}
	    Get Content    ${project_id}    ${alias}    ${content_id}
	    ${status}    ${actual_value}    Run Keyword And Ignore Error     Get Property Value From Json By Index    ${waited_data}
	    ${is_contain}    Is String Contain    ${actual_value}    ${waited_value}
	    Exit For Loop If    '${is_contain}'=='${True}'
	    Sleep    1s
    END
    
Remove Existing Data Before Executing Test
    [Arguments]    ${projectId}    ${alias}    ${param_uri}=${EMPTY}
    Get All Content    ${projectId}    ${alias}    params=${param_uri}
    Response Correct Code    ${SUCCESS_CODE}
    Run Keyword If   ${resp.json()}    Delete Content    ${projectId}    ${alias}    ${resp.json()[0]['id']}

Prepare For Creating Merchant
    Read Json From File    ${create_merchant_json}
    Remove Existing Data Before Executing Test     ${WESHOP_PROJECT_ID}    brand
    ...    data.merchantId=${json_dummy_data['id']}

Prepare JSON For Outlet
    [Arguments]    ${json_file}=${create_outlet_json_v1}    ${outlet_order}=${0}
    Read Json From File    ${json_file}
    ${upper_env}=     Convert To Uppercase    ${ENV}
    Run Keyword If     '${upper_env}' == 'STAGING'    Update Json Data    $.merchantBrandId    0027694
    Run Keyword If     '${upper_env}' == 'STAGING'    Update Json Data    $.merchantId    18291
    Run Keyword If     '${upper_env}' == 'STAGING' and '${outlet_order}' == '${0}'    Update Json Data    $.id    4869
    Run Keyword If     '${upper_env}' == 'STAGING' and '${outlet_order}' == '${1}'    Update Json Data    $.id    4870
    Run Keyword If     '${upper_env}' == 'ALPHA' and '${outlet_order}' == '${1}'    Update Json Data    $.id    94467

Prepare For Creating Outlet
    Prepare JSON For Outlet
    Remove Existing Data Before Executing Test    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}

Prepare For Update Merchant
    Read Json From File    ${create_merchant_json}
    Post Publish Outlets Created Event   ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Get All Content    ${WESHOP_PROJECT_ID}    brand    data.merchantId=${json_dummy_data['id']}
    Response Correct Code      ${SUCCESS_CODE}

Prepare For Update OutletV1
    Prepare JSON For Outlet    ${create_outlet_json_v1}
    Post Publish Outlets Created Event   ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    $[0].data.tsmMerchantId
    ...    ${json_dummy_data['merchantBrandId']}    180    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}
    Response Correct Code    ${SUCCESS_CODE}

Prepare For Update OutletV2
    Prepare JSON For Outlet     ${create_outlet_json_v2}
    Post Publish Outlet V2 Created Event    CREATE    ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    $[0].data.tsmMerchantId
    ...    ${json_dummy_data['merchantBrandId']}    180    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}
    Get All Content    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}
    Response Correct Code      ${SUCCESS_CODE}
    Get Content    ${WESHOP_PROJECT_ID}    shop    ${resp.json()[0]['id']}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced V2 Data Of Shop Content On CMS    ${WESHOP_PROJECT_ID}    ${json_dummy_data}
    Prepare JSON For Outlet     ${create_outlet_json_v2}    ${1}
    Post Publish Outlet V2 Created Event    CREATE    ${json_dummy_data}
    Response Correct Code    ${ACCEPTED_CODE}
    Wait Until Api Keyword Response Property Change    Get All Content    $[1].data.tsmMerchantId
    ...    ${json_dummy_data['merchantBrandId']}    180    ${WESHOP_PROJECT_ID}    shop
    ...    data.tsmMerchantId=${json_dummy_data['merchantBrandId']}&data.tsmOutletId=${json_dummy_data['outletId']}
    ${outlet_id}=    Get Property Value From Json By Index    .id    0
    Get Content    ${WESHOP_PROJECT_ID}    shop    ${outlet_id}
    Response Correct Code    ${SUCCESS_CODE}
    Verify Synced V2 Data Of Shop Content On CMS    ${WESHOP_PROJECT_ID}    ${json_dummy_data}

Verify Synced Data Of Brand Content On CMS
    [Arguments]    ${json_dummy_data}
    Response Should Contain Property With Value    data.merchantId                 ${json_dummy_data['id']}
    Response Should Contain Property With Value    data.nameEn                     ${json_dummy_data['storeNameEn']}
    Response Should Contain Property With Value    data.nameTh                     ${json_dummy_data['storeNameTh']}
    Response Should Contain Property With Value    data.categoryId                 ${json_dummy_data['categoryId']}
    Response Should Contain Property With Value    data.categoryDescription        ${json_dummy_data['categoryName']}
    Response Should Contain Property With Value    data.subCategoryId              ${json_dummy_data['subCategoryId']}
    Response Should Contain Property With Value    data.subCategoryDescription     ${json_dummy_data['subCategoryName']}
    Response Should Contain Property With Value    data.socialFacebook             ${json_dummy_data['storeFacebook']}
    Response Should Contain Property With Value    data.socialLine                 ${json_dummy_data['storeLineAt']}
    Response Should Contain Property With Value    data.socialTwitter              ${json_dummy_data['storeTwitter']}
    Response Should Contain Property With Value    data.socialWebsite              ${json_dummy_data['storeWebsite']}
    Response Should Contain Property With Value    data.socialInstagram            ${json_dummy_data['storeInstagram']}
    Response Should Contain Property With Value    data.tsmMerchantId              ${json_dummy_data['merchantId']}
    Response Should Contain Property With Value    data.onlineStatus               true

Verify Synced V1 Data Of Shop Content On CMS
    [Arguments]    ${projectId}    ${json_dummy_data}
    ${shop_content_cms}=    Set Variable    ${RESP}
    Response Should Contain Property With Value    data.shopNameTh                 ${json_dummy_data['outletNameTh']}
    Response Should Contain Property With Value    data.shopNameEn                 ${json_dummy_data['outletNameEn']}
    Response Should Contain Property With Value    data.shopHighlight              ${json_dummy_data['outletDetail']}
    Response Should Contain Property With Value    data.shopTel                    ${json_dummy_data['contactTel']}
    Response Should Contain Property With Value    data.shopMobile                 ${json_dummy_data['contactMobile']}
    Response Should Contain Property With Value    data.tsmOutletId                ${json_dummy_data['outletId']}
    Response Should Contain Property With Value    data.tsmMerchantId              ${json_dummy_data['merchantBrandId']}
    ${response}=     Get Address    contentId=${json_dummy_data['id']}
    Response Should Contain Property With Value    data.address                    ${response.json()["content"][0]["address"]}
    Response Should Contain Property With Value    data.district                   ${response.json()["content"][0]["districtNameTh"]}
    Response Should Contain Property With Value    data.subDistrict                ${response.json()["content"][0]["subdistrictNameTh"]}
    Response Should Contain Property With Value    data.province                   ${response.json()["content"][0]["provinceNameTh"]}
    Response Should Contain Property With Value    data.postCode                   ${response.json()["content"][0]["postCode"]}
    ${rpp_merchant_address}=    Set Variable    ${response}
    ${response}=    Get Search Merchant    ${json_dummy_data['merchantId']}
    Run Keyword If    '${rpp_merchant_address.json()["content"][0]["address"]}' != '${None}'and '${rpp_merchant_address.json()["content"][0]["longtitude"]}' != '${None}' and '${rpp_merchant_address.json()["content"][0]["latitude"]}' != '${None}' and ${response.json()["storeTypeId"]} != ${1} and '${json_dummy_data["status"]}' == 'APPROVE'
    ...   Run Keywords    Response Should Contain Property With Value    data.onlineStatus    true    AND    Response Should Contain Property With Value    data.publishStatus    true
    ...   ELSE     Run Keywords    Response Should Contain Property With Value    data.onlineStatus    false    AND    Response Should Contain Property With Value    data.publishStatus    false
    Get All Content    ${projectId}    brand    data.merchantId=${json_dummy_data['merchantId']}
    Response Correct Code    ${SUCCESS_CODE}
    Get Content    ${projectId}    brand    ${resp.json()[0]['id']}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    data.categoryId                 ${shop_content_cms.json()['data']['categoryId']}
    Response Should Contain Property With Value    data.categoryDescription        ${shop_content_cms.json()['data']['categoryDescription']}
    Response Should Contain Property With Value    data.subCategoryId              ${shop_content_cms.json()['data']['subCategoryId']}
    Response Should Contain Property With Value    data.subCategoryDescription     ${shop_content_cms.json()['data']['subCategoryDescription']}
    Set Test Variable    ${shop_content_cms}

Verify Synced V2 Data Of Shop Content On CMS
    [Arguments]    ${projectId}    ${json_dummy_data}
    ${shop_content_cms}=    Set Variable    ${RESP}
    Response Should Contain Property With Value    data.shopNameTh                 ${json_dummy_data['outletNameTh']}
    Response Should Contain Property With Value    data.shopNameEn                 ${json_dummy_data['outletNameEn']}
    Response Should Contain Property With Value    data.geo_location.latitude      ${json_dummy_data['addresses'][0]['latitude']}
    Response Should Contain Property With Value    data.geo_location.longitude     ${json_dummy_data['addresses'][0]['longtitude']}
    Response Should Contain Property With Value    data.address                    ${json_dummy_data['addresses'][0]['address']}
    Response Should Contain Property With Value    data.district                   ${json_dummy_data['addresses'][0]['district']}
    Response Should Contain Property With Value    data.subDistrict                ${json_dummy_data['addresses'][0]['subdistrict']}
    Response Should Contain Property With Value    data.province                   ${json_dummy_data['addresses'][0]['province']}
    Response Should Contain Property With Value    data.postCode                   ${json_dummy_data['addresses'][0]['postCode']}
    Response Should Contain Property With Value    data.shopHighlight              ${json_dummy_data['outletDetail']}
    Response Should Contain Property With Value    data.tsmOutletId                ${json_dummy_data['outletId']}
    Response Should Contain Property With Value    data.tsmMerchantId              ${json_dummy_data['merchantBrandId']}
    ${response}=    Get Search Merchant    ${json_dummy_data['merchantId']}
    Run Keyword If    '${resp.json()["data"]["address"]}' != '${None}' and '${resp.json()["data"]["geo_location"]["longitude"]}' != '${None}' and '${resp.json()["data"]["geo_location"]["latitude"]}' != '${None}' and ${response.json()["storeTypeId"]} != ${1} and '${json_dummy_data["status"]}' == 'APPROVE'
    ...   Run Keywords    Response Should Contain Property With Value    data.onlineStatus    true    AND    Response Should Contain Property With Value    data.publishStatus    true
    ...   ELSE    Run Keywords    Response Should Contain Property With Value    data.onlineStatus    false    AND    Response Should Contain Property With Value    data.publishStatus    false
    Get All Content    ${projectId}    brand    data.merchantId=${json_dummy_data['merchantId']}
    Response Correct Code    ${SUCCESS_CODE}
    Get Content    ${projectId}    brand    ${resp.json()[0]['id']}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    data.categoryId                 ${shop_content_cms.json()['data']['categoryId']}
    Response Should Contain Property With Value    data.categoryDescription        ${shop_content_cms.json()['data']['categoryDescription']}
    Response Should Contain Property With Value    data.subCategoryId              ${shop_content_cms.json()['data']['subCategoryId']}
    Response Should Contain Property With Value    data.subCategoryDescription     ${shop_content_cms.json()['data']['subCategoryDescription']}
    Set Test Variable    ${shop_content_cms}

Get ID Of A Content From List Of Contents
    [Arguments]    ${index}=${0}
    Set Test Variable    ${content_id}    ${RESP.json()[${index}]['id']}

Set Test Variable For Shop ID
    [Arguments]    ${shop_index}
    Run Keyword If    ${shop_index} == ${1}    Set Test Variable    ${shop_1_id}    ${shop_content_cms.json()['id']}
    ...    ELSE    Set Test Variable    ${shop_2_id}    ${shop_content_cms.json()['id']}