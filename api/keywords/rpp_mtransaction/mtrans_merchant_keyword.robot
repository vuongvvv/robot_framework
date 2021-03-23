*** Settings ***
Library     OperatingSystem
Resource    ../common/api_common.robot
Resource    ../common/rpp_gateway_common.robot

*** Variables ***
${RPP_MTRANS_SERVICE_ENDPOINT}            /crm-ms-mtransaction-api/v1
${RPP_MTRANS_CREATE_MERCHANT_ENDPOINT}    ${RPP_MTRANS_SERVICE_ENDPOINT}/merchant
${RPP_MTRANS_MERCHANT_DESC_ENDPOINT}      ${RPP_MTRANS_SERVICE_ENDPOINT}/merchant/description
${create_merchant_json_data}              ../../resources/testdata/rpp_mtransaction/create_merchant.json

*** Keywords ***
Post Create Merchant By TxRefId
    [Arguments]    ${txRefId}
    ${dummy_data_file_path}=    Catenate    SEPARATOR=/    ${CURDIR}    ${create_merchant_json_data}
    ${body} =    Load JSON From File    ${dummy_data_file_path}
    ${requestBody} =    Update Value To Json    ${body}    $.ref_id    ${txRefId}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}    ${RPP_MTRANS_CREATE_MERCHANT_ENDPOINT}    json=${requestBody}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Get Merchant Mongo ID From Created Merchant
    Generate Unique TxRefId
    ${dummy_data_file_path}=    Catenate    SEPARATOR=/    ${CURDIR}    ${create_merchant_json_data}
    ${body} =    Load JSON From File    ${dummy_data_file_path}
    ${requestBody} =    Update Value To Json    ${body}    $.ref_id    ${txRefId}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}    ${RPP_MTRANS_CREATE_MERCHANT_ENDPOINT}    json=${requestBody}    headers=&{RPP_GATEWAY_HEADERS}
    ${MERCHANT_MONGO_ID}=    Get Value From Json    ${RESP.json()}    $.data.id
    ${MERCHANT_MONGO_ID}=    Get From List    ${MERCHANT_MONGO_ID}    0
    Set Test Variable    ${MERCHANT_MONGO_ID}

Get Merchant By Merchant Mongo ID
    [Arguments]    ${merchantMongoId}
    ${param}=     Create Dictionary
    ...    id=${merchantMongoId}
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    ${RPP_MTRANS_MERCHANT_DESC_ENDPOINT}    params=&{param}     headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Generate Unique TxRefId
    ${txRefId} =    Get Time    format=epoch
    ${txRefId} =    Convert to String    ${txRefId}
    Set Test Variable    ${TX_REF_ID}
