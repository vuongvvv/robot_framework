*** Settings ***
Resource    ../common/string_common.robot
Resource    ../common/json_common.robot

*** Variables ***
${create_merchant_testData_path}    ../../resources/testdata/rpp_merchant_bs/createMerchantData.json
${update_merchant_testData_path}    ../../resources/testdata/rpp_merchant_bs/updateMerchantData.json
${merchant_detail_endpoint}    /merchant-bs-api/v1/merchant/detail/
${update_merchant_endpoint}     /merchant-bs-api/v1/merchant/update

*** Keywords ***
Get Api Merchant Detail
    [Arguments]     ${merchant_id}
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    ${merchant_detail_endpoint}${merchant_id}    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}

Get Merchant Status
    [Arguments]     ${params_uri}=${EMPTY}
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    /merchant-bs-api/v1/merchant/status    params=${params_uri}    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}
    
Prepare Body For Create Merchant
    [Arguments]    ${merchant_name_en}    ${merchant_name_th}    ${device_type}=${1}    ${service_type}=${1}
    ${txRefId} =    Get Time    format=epoch
    ${dummy_data_file_path}=    Catenate    SEPARATOR=/    ${CURDIR}    ${create_merchant_testData_path}
    ${body} =    Load JSON From File    ${dummy_data_file_path}
    ${body_edit_ref_id} =    Update Value To Json    ${body}    $.ref_id    ${txRefId}
    ${rand_num}=    Get Random Strings    5    [NUMBERS]
    ${body_edit_merchant_name_en}=   Update Value To Json    ${body_edit_ref_id}    $.merchant_name.en    ${merchant_name_en}${rand_num}
    ${body_edit_merchant_name_th}=   Update Value To Json    ${body_edit_merchant_name_en}    $.merchant_name.th    ${merchant_name_th}${rand_num}
    ${body_edit_sale_code}=   Update Value To Json    ${body_edit_merchant_name_th}    $.sale_code    ${SALE_CODE}
    ${body_edit_device_type}=   Update Value To Json    ${body_edit_sale_code}    $.device_type    ${device_type}
    ${body_edit_service_type}=   Update Value To Json    ${body_edit_device_type}    $.service_type    ${service_type}
    Set Test Variable    ${FINAL_BODY}    ${body_edit_service_type}
    Set Test Variable    ${MERCHANT_NAME_TH_RAND}    ${merchant_name_th}${rand_num}
    Set Test Variable    ${MERCHANT_NAME_EN_RAND}    ${merchant_name_en}${rand_num}

Post Api Create Merchant
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    /merchant-bs-api/v1/merchant    json=${request_data}    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}

Prepare Body For Update Merchant
    ${endpoint} =  Catenate  SEPARATOR=    ${update_merchant_endpoint}    /5abb5981e9da8f042d15cbf3
    ${dummy_data_file_path}=    Catenate    SEPARATOR=/    ${CURDIR}    ${update_merchant_testData_path}
    ${body} =    Load JSON From File    ${dummy_data_file_path}
    Set Test Variable    ${ENDPOINT}
    Set Test Variable    ${BODY}

Put Api Update Merchant
    [Arguments]     ${request_data}    ${endpoint_and_param}
    ${RESP}=      Put Request     ${RPP_GATEWAY_SESSION}    ${endpoint_and_param}    json=${request_data}    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}
    
Fetch Java Merchant Id
    ${TEST_DATA_JAVA_MERCHANT_ID}    Get Property Value From Json By Index    .data.merchant_id
    Set Test Variable    ${TEST_DATA_JAVA_MERCHANT_ID}