*** Keywords ***
# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1557890048/API+Search+Brand+Fraud
Get Search Brand Fraud
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /merchant-v2/api/frauds    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1637810446/API+GET+Brand+Fraud+Detail
Get Brand Fraud Detail
    [Arguments]    ${brand_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /merchant-v2/api/frauds/brand/${brand_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1775239455/API+Fraud+Update+Status
Patch Brand Fraud Status
    [Arguments]    ${brand_ref_id}    ${json_body}
    ${RESP}=    Patch Request    ${GATEWAY_SESSION}    /merchant-v2/api/frauds/brand/${brand_ref_id}/status    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}