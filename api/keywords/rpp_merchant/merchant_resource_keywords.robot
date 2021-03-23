*** Settings ***
Resource    ../common/json_common.robot
Resource    ../common/dummy_data_common.robot
Resource    ../common/string_common.robot

*** Variables ***
${merchants_api}    /rpp-merchant/api/merchants

*** Keywords ***
Post Create Merchant
    [Arguments]    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${merchants_api}    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    @{merchant_sequence_id}    Get Value From Json    ${RESP.json()}    $.id
    Set Test Variable    ${MERCHANT_SEQUENCE_ID}    ${merchant_sequence_id}[0]
    @{merchant_brand_id}    Get Value From Json    ${RESP.json()}    $.merchantId
    Set Test Variable    ${MERCHANT_BRAND_ID}    ${merchant_brand_id}[0]
    Response Correct Code    ${CREATED_CODE}

Post Update True Money Status
    [Arguments]    ${merchant_id}    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /rpp-merchant/api/merchants/${merchant_id}/truemoney/status    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Update True You Status
    [Arguments]    ${merchant_id}    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /rpp-merchant/api/merchants/${merchant_id}/trueyou/status    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Get Merchant Information
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${merchants_api}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get True You Merchant ID
    ${ty_merchant_id} =    Get Value From Json    ${resp.json()}    $.content..'trueyouId'
    Set Test Variable    ${TY_MERCHANT_ID}    ${ty_merchant_id}

Get Merchant Sequence ID
    ${merchant_sequence_id} =    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${MERCHANT_SEQUENCE_ID}    ${merchant_sequence_id}

Get Merchant ID
    ${merchant_id} =    Get Property Value From Json By Index    $.content..merchantId    0
    Set Test Variable    ${MERCHANT_ID}    ${merchant_id}

Get Random Merchant IDs Follow Business Instruction
    ${rand_num}=    Get Random Strings    15    [NUMBERS]
    Set Test Variable    ${MERCHANT_TY_ID}    ${rand_num}
    ${merchant_id}=    Get Substring    ${MERCHANT_TY_ID}    3    9
    Set Test Variable    ${MERCHANT_BRAND_ID}    ${merchant_id}
    ${rand_num}=    Get Random Strings    10    [NUMBERS]
    Set Test Variable    ${MERCHANT_TMN_ID}    ${rand_num}00001

Get Search Merchant
    [Arguments]    ${merchant_id}
    ${response}=    Get Request    ${GATEWAY_SESSION}    ${merchants_api}/${merchant_id}    headers=&{GATEWAY_HEADER}
    [Return]    ${response}

