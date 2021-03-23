*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
Get Province
    ${RESP}=    Get Request    ${RPP_GATEWAY_SESSION}    /crm-ms-address-api/v1/province    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
        
Get District
    ${RESP}=    Get Request    ${RPP_GATEWAY_SESSION}    /crm-ms-address-api/v1/district    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
    
Get Sub District
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${RPP_GATEWAY_SESSION}    /crm-ms-address-api/v1/subdistrict    params=${params_uri}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
    
Get Address
    ${RESP}=    Get Request    ${RPP_GATEWAY_SESSION}    /crm-ms-address-api/v1/address    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Get Address By Id
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${RPP_GATEWAY_SESSION}    /crm-ms-address-api/v1/addressbyid    params=${params_uri}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
    
Get Address Detail
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${RPP_GATEWAY_SESSION}    /crm-ms-address-api/v1/address/detail    params=${params_uri}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
    
Post Create Address
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}    /crm-ms-address-api/v1/createaddress    data=${data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Update Address
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}    /crm-ms-address-api/v1/updateaddress    data=${data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Delete Address
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Delete Request    ${RPP_GATEWAY_SESSION}    /crm-ms-address-api/v1/address    params=${params_uri}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}
                
Fetch Province Id
    ${TEST_DATA_PROVINCE_ID}    Get Property Value From Json By Index    .PROVINCE_ID
    Set Test Variable    ${TEST_DATA_PROVINCE_ID}
    
Fetch District Id
    ${TEST_DATA_DISTRICT_ID}    Get Property Value From Json By Index    .DISTRICT_ID
    Set Test Variable    ${TEST_DATA_DISTRICT_ID}

Fetch Sub District Id
    ${TEST_DATA_SUB_DISTRICT_ID}    Get Property Value From Json By Index    .SUBDISTRICT_ID
    Set Test Variable    ${TEST_DATA_SUB_DISTRICT_ID}
    
Fetch Address Id
    ${address_id_list}    Get Property Value From Json By Index    data
    ${TEST_DATA_ADDRESS_ID}    Fetch From Left    ${address_id_list}    ,
    Set Test Variable    ${TEST_DATA_ADDRESS_ID}
    
Fetch Created Address Id
    ${TEST_DATA_CREATED_ADDRESS_ID}    Get Property Value From Json By Index    data
    Set Test Variable    ${TEST_DATA_CREATED_ADDRESS_ID}