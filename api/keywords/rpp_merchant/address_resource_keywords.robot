*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/dummy_data_common.robot

*** Variables ***
${address_api}    /rpp-merchant/api/addresses

*** Keywords ***
Get Address
    [Arguments]    ${contentId}     ${contentType}=outlet    ${addressType}=store
    &{param_uri}=    Create Dictionary    contentType=${contentType}    addressType=${addressType}     contentId=${contentId}
    ${response}=    Get Request    ${GATEWAY_SESSION}    ${address_api}    params=${param_uri}    headers=&{GATEWAY_HEADER}
    [Return]    ${response}