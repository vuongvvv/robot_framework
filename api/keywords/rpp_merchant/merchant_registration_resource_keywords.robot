*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/842401268/RPP+Merchant+Registration+APIs
Get All Merchant Registrations Raw
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP} =    Get Request    ${GATEWAY_SESSION}    /rpp-merchant/api/merchant-registrations/raw    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/842401268/RPP+Merchant+Registration+APIs    
Get Merchant Registrations Raw
    [Arguments]    ${merchant_id}
    ${RESP} =    Get Request    ${GATEWAY_SESSION}    /rpp-merchant/api/merchant-registrations/raw/${merchant_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/842401268/RPP+Merchant+Registration+APIs
Get All Merchant Registrations
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP} =    Get Request    ${GATEWAY_SESSION}    /rpp-merchant/api/merchant-registrations    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/842401268/RPP+Merchant+Registration+APIs        
Get Merchant Registration
    [Arguments]    ${merchant_registration_id}
    ${RESP} =    Get Request    ${GATEWAY_SESSION}    /rpp-merchant/api/merchant-registrations/${merchant_registration_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Test Data Preparation
Get Test Data Merchant Id On Mongo Database
    [Arguments]    ${filter_by}=${EMPTY}
    Get All Merchant Registrations Raw    ${filter_by}
    ${merchant_mongo_id} =    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${MERCHANT_MONGO_ID}    ${merchant_mongo_id}
    
Fetch Merchant Id
    ${TEST_DATA_MERCHANT_ID}    Get Property Value From Json By Index    .merchant_id    
    Set Test Variable    ${TEST_DATA_MERCHANT_ID}