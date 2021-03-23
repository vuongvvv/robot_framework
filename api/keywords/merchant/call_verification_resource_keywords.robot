*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1454539172/API+Create+Brand+Call-Verification
Post Save Brand Call Verification By Refid
    [Arguments]    ${brand_ref_id}    ${json_request_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /merchant-v2/api/brands/${brand_ref_id}/callverification    data=${json_request_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1454834918/API+Create+Shop+Call-Verification
Post Save Shop Call Verification By Refid
    [Arguments]    ${shop_ref_id}    ${json_request_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /merchant-v2/api/shops/${shop_ref_id}/callverification    data=${json_request_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
            
Get Search Brand Callverification
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /merchant-v2/api/brands/callverification    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Brand Call Verification By Refid
     [Arguments]    ${brand_ref_id}    ${json_request_body}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /merchant-v2/api/brands/${brand_ref_id}/callverification/status    data=${json_request_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Fetch Brand Id
    ${TEST_DATA_BRAND_ID}    Get Property Value From Json By Index    .brandId
    Set Test Variable    ${TEST_DATA_BRAND_ID}