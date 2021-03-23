*** Settings ***
Resource      ../common/api_common.robot
Resource    ../common/json_common.robot
Resource    ../common/gateway_common.robot

*** Keywords ***
Generate Truemoney Id
    ${TMN_ID}=    Random Unique String By Epoch Datetime
    Set Test Variable    ${TMN_ID}

Post Sign In With Sdk
    [Arguments]    ${provider_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/social/signin/${provider_id}    data=${data}    headers=&{BASIC_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Sign In With Line Id Token
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/social/signin/line    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Sign In With Truemoney Token
    [Arguments]    ${truemoney_access_token}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /uaa/api/social/signin/truemoney    data={ "accessToken":"${truemoney_access_token}" }    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Set True Id Access Token To O2O Gateway Header
    ${test_data_true_id_access_token}=    Get Property Value From Json By Index    access_token    0
    Generate Gateway Header From Access Token    ${test_data_true_id_access_token}