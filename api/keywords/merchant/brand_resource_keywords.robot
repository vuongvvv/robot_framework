*** Settings ***
Resource    ../common/json_common.robot
Resource    ../common/date_time_common.robot
Resource    ../common/string_common.robot
Resource    ../merchant/common_merchant_keywords.robot

*** Variables ***
${brand_api}    /merchant-v2/api/brands
${get_brand_api}    /merchant-v2/api/brands

*** Keywords ***
# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1317273821/Api+Apply+Brand+By+provider
Post Brand Kyb With Provider
    [Arguments]    ${brand_ref_id}    ${provider}    ${json_body}    ${is_callver}=true    ${activeService}=true
    Set To Dictionary    ${GATEWAY_HEADER}    isCallver=${is_callver}    activeService=${activeService}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /merchant-v2/api/brands/${brand_ref_id}/${provider}/kyb    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    Remove From Dictionary    ${GATEWAY_HEADER}    isCallver    activeService

Get Brands By Criteria
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /merchant-v2/api/brands    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1373569401/API+Create+Brand
Post Create Brand
    [Arguments]    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${brand_api}    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Store First Brand ID
    Set Test Variable    ${1ST_BRAND_ID}    ${BRAND_ID}

Extract Brand Id From Response
    ${BRAND_ID} =    Get Property Value From Json By Index    .brandId    0
    Set Suite Variable    ${BRAND_ID}

Extract And Store Brand Mongo Id From Response
    ${BRAND_MONGO_ID} =    Get Property Value From Json By Index    .id    0
    Set Suite Variable    ${BRAND_MONGO_ID}

Create Brand With Timestamp
    [Arguments]    ${json_body}
    Get Current Timestamp
    ${json_body} =    Replace String    ${json_body}    _TIME_STAMP_    ${TIME_STAMP}
    Post Create Brand    ${json_body}

Verify The Latest Brand ID Should More Than The First Brand ID
    Should Be True    ${${1ST_BRAND_ID}} < ${BRAND_ID}

Get Brand By ID
    [Arguments]    ${brand_mongo_id}
    ${RESP}=     Get Request             ${GATEWAY_SESSION}        ${get_brand_api}/${BRAND_MONGO_ID}      headers=&{GATEWAY_HEADER}
    Set Test Variable               ${RESP}

Fetch Brand Id Test Data
    ${TEST_DATA_BRAND_ID} =    Get Property Value From Json By Index    .brandId    0
    Set Test Variable    ${TEST_DATA_BRAND_ID}
    
Fetch Brand Mongo Id
    ${TEST_DATA_BRAND_MONGO_ID} =    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${TEST_DATA_BRAND_MONGO_ID}
    
Fetch Content Id
    [Arguments]    ${content}
    ${variable_name}    Set Variable    TEST_DATA_${content}_CONTENT_ID
    ${content_id}    Get Property Value From Json By Index    contentId
    Set Test Variable    ${${variable_name}}    ${content_id}