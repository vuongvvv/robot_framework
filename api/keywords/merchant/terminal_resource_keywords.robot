*** Settings ***
Resource    ../common/json_common.robot
Resource    ../common/date_time_common.robot
Resource    ../common/string_common.robot
Resource    ../merchant/common_merchant_keywords.robot

*** Keywords ***
# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1184465233/O2O+Terminal
Post Create Terminal
    [Arguments]    ${shop_mongo_id}    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /merchant-v2/api/shops/${shop_mongo_id}/terminal    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    #Using sleep to have new timestamp change on terminal name and script is working fast which api is not allow to create if using duplicate terminal name
    Sleep    1s

Create Terminal With Timestamp For Shop
    [Arguments]    ${shop_mongo_id}    ${json_body}
    Get Current Timestamp
    ${json_body} =    Replace String    ${json_body}    _TIME_STAMP_    ${TIME_STAMP}
    Post Create Terminal    ${shop_mongo_id}    ${json_body}

Store First Terminal ID
    Set Test Variable    ${1ST_TERMINAL_ID}    ${TERMINAL_ID}

Extract Terminal Id From Response
    ${TERMINAL_ID} =    Get Property Value From Json By Index    .terminalId   0
    Set Test Variable    ${TERMINAL_ID}

Verify The Latest Terminal ID Should More Than The First Terminal ID
     Should Be True    ${${1ST_TERMINAL_ID}} < ${TERMINAL_ID}