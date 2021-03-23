# Document : https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1749876828/Omise+Holding+Capture+Charge+Reverse+Charge

*** Keywords ***
Get Merchant Payment Query By ClientRefId
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/credit-card/query-activity    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
