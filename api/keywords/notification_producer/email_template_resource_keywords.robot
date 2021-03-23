*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/dummy_data_common.robot

*** Keywords ***
GET All Email Templates
    [Arguments]    ${params_uri}=${EMPTY}
    ${resp}=    Get Request    ${GATEWAY_SESSION}    /notificationproducer/api/email-templates    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${resp}

POST Create Email Templates
    [Arguments]    ${json_body}
    ${resp}=    Post Request    ${GATEWAY_SESSION}    /notificationproducer/api/email-templates    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${resp}

POST Create Email Templates With Dummy Data
    [Arguments]    ${json_data}
    Read Json From File    ${json_data}
    ${random_string}=    Generate Random String    7    [NUMBERS]
    Update Json Data    $.action    ${random_string}
    POST Create Email Templates    ${json_dummy_data}
    Log     ${resp.content}