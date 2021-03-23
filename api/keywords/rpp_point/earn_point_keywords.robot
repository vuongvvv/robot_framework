*** Settings ***
Library    OperatingSystem
Resource    ../common/api_common.robot

*** Variables ***
${endpoint_earn}               /crm-ms-point/v1/points/issue
${endpoint_void_earn}          /crm-ms-point/v1/points/void 

*** Keywords ***
Post Api Earn Point
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${endpoint_earn}    data=${request_data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Void Earn Point
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    ${endpoint_void_earn}    data=${request_data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Set Variable For Void
    [Arguments]     ${txRefID}    ${rppRefId}
    ${txRefIDVoid}=    Set Variable   ${txRefID}
    ${rppRefIdVoid}=    Set Variable   ${rppRefId}
    Set Test Variable    ${TXREFIDVOID}
    Set Test Variable    ${RPPREFIDVOID}

Generate ID
    Sleep    0.2
    ${Id} =    Get Time    format=epoch
    Set Test Variable    ${ID}
    
Generate AccountId
    Sleep    0.2
    ${AccountId} =    Get Time    format=epoch
    Set Test Variable    ${ACCOUNTID}