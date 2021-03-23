*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${weshop_url}   /weshop/api/shops

*** Keywords ***
Post Create Review
    [Arguments]    ${shop_id}     ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${weshop_url}/${shop_id}/reviews    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Created ReviewID From Response
    ${review_id_list}=    Get Value From Json    ${RESP.json()}    id
    ${review_id}=    Get From List    ${review_id_list}    0
    Set Test Variable    ${review_id}