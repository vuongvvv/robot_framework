*** Settings ***
Library    Collections
Resource    ../common/api_common.robot
Resource    ../common/gateway_common.robot
Resource    promotions_keywords.robot

*** Keywords ***
Post Generate Coupon Code
    [Arguments]    ${campaign_id}    ${coupon_data}=${json_dummy_data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${add_campaign_promotion_api}/${campaign_id}/coupons    data=${coupon_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Extract Id From Response
    ${coupon_id_list}=    Get Value From Json    ${RESP.json()}    $.id
    ${coupon_id}=    Get From List    ${coupon_id_list}    0
    Set Test Variable    ${coupon_id}

Extract Code From Response
    ${coupon_code_list}=    Get Value From Json    ${RESP.json()}    $.code
    ${coupon_code}=    Get From List    ${coupon_code_list}    0
    Set Test Variable    ${coupon_code}

Update Coupon Status
    [Arguments]    ${coupon_id}    ${json_data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /campaign/api/promotions/coupons/${coupon_id}/status    data=${json_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Redeem Coupon Code
    [Arguments]    ${coupon_code}    ${coupon_redeem_data}=${json_dummy_data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    campaign/api/promotions/coupons/${coupon_code}    data=${coupon_redeem_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Specific Coupon By Code
    [Arguments]    ${coupon_code}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /campaign/api/promotions/coupons/${coupon_code}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Prepare Coupons For Test
    [Arguments]    ${data_file}=${dummy_data_file}
    Prepare Campaign For Test    ${data_file}
    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.coupon.create
    Read Dummy Json From File    ${coupon_dummy_data_file}
    Post Generate Coupon Code    ${campaign_id}
    Response Correct Code    ${CREATED_CODE}
    Extract Code From Response
    Extract Id From Response
    Delete Created Client And User Group

Get List Campaign Promotion Coupons
    [Arguments]    ${param_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${add_campaign_promotion_api}/coupons    params=${param_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}