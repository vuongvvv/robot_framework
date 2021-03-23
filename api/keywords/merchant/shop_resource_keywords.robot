*** Settings ***
Resource    ../common/date_time_common.robot
Resource    ../common/string_common.robot
Resource    ../merchant/common_merchant_keywords.robot

*** Variables ***
${get_shop_api}    /merchant-v2/api/shops

*** Keywords ***
# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1623524822/API+Create+Shop
Post Create Shop
    [Arguments]    ${brand_mongo_id}    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /merchant-v2/api/brands/${brand_mongo_id}/shop    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Create Shop With Timestamp For Brand
    [Arguments]    ${brand_mongo_id}    ${json_body}
    Get Current Timestamp
    ${json_body} =    Replace String    ${json_body}    _TIME_STAMP_    ${TIME_STAMP}
    Post Create Shop    ${brand_mongo_id}    ${json_body}

Extract And Store Shop Mongo Id From Response
    ${SHOP_MONGO_ID} =    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${SHOP_MONGO_ID}

Store First Shop ID
    Set Test Variable    ${1ST_SHOP_ID}    ${SHOP_ID}

Extract Shop Id From Response
    ${SHOP_ID} =    Get Property Value From Json By Index    .shopId    0
    Set Test Variable    ${SHOP_ID}

Verify The Latest Shop ID Should More Than The First Shop ID
     Should Be True    ${${1ST_SHOP_ID}} < ${SHOP_ID}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1378746496/API+Get+Shop+by+id
Get Shop By ID
    [Arguments]    ${shop_mongo_id}
    ${RESP}    Get Request    ${GATEWAY_SESSION}    /merchant-v2/api/shops/${shop_mongo_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1304429248/Api+Apply+Shop+By+provider
Post Shop Kyb With Provider
    [Arguments]    ${shop_ref_id}    ${provider}    ${json_body}    ${is_callver}=true    ${activeService}=true
    Set To Dictionary    ${GATEWAY_HEADER}    isCallver=${is_callver}    activeService=${activeService}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /merchant-v2/api/shops/${shop_ref_id}/${provider}/kyb    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    Remove From Dictionary    ${GATEWAY_HEADER}    isCallver    activeService
    
Post Request Create Shop Contract TrueMoney
    [Arguments]    ${shop_ref_id}    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /merchant-v2/api/shops/${shop_ref_id}/contracts    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}