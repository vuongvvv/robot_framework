# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1004503075/Merchant+BS+Service+-+RPP+Service+Catalog
*** Keywords ***
Get Config
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    /merchant-bs-api/v1/config    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}

Get Config Private
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    /merchant-bs-api/v1/configprivate    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}
    
Get User Profile
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    /merchant-bs-api/v1/user/profile    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}
    
Get Check User
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    /merchant-bs-api/v1/user/check    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}
    
Get Sale Code User
    ${RESP}=      Get Request     ${RPP_GATEWAY_SESSION}    /merchant-bs-api/v1/user/salecode    headers=&{RPP_GATEWAY_MERCHANT_BS_HEADER}
    Set Test Variable    ${RESP}