*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${get_all_points_api}    /point/api/points

*** Keywords ***
Get All Points
    [Arguments]    ${params_uri}=${EMPTY}    
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${get_all_points_api}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Prepare test data
Prepare Point Test Data
    Get All Points    
    ${point_id_list}=    Get Value From Json    ${RESP.json()}    $..id
    ${thai_id_list}=    Get Value From Json    ${RESP.json()}    $..thaiId
    Set Test Variable    ${POINT_ID}    ${point_id_list}[0]
    Set Test Variable    ${THAI_ID}    ${thai_id_list}[0]
