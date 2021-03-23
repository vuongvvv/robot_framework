*** Settings ***
Resource    ../common/json_common.robot

*** Variables ***
${bifrost_service}    bifrost

*** Keywords ***
Get Routing Proxy
    [Arguments]    ${group_name}    ${project_id}    ${source_path}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/${group_name}/projects/${project_id}${source_path}    params=${params_uri}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Get Product Search
    [Arguments]    ${project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/search/projects/${project_id}/products    params=${params_uri}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Put Create Update Product
    [Arguments]    ${project_id}    ${collection}    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}     /${bifrost_service}/api/search/projects/${project_id}/${collection}/products    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Delete Product
    [Arguments]    ${project_id}    ${collection}    ${data}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}     /${bifrost_service}/api/search/projects/${project_id}/${collection}/products    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Get Auto Complete
    [Arguments]    ${project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/search/projects/${project_id}/products/autocomplete    params=${params_uri}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Get Product Personalize
    [Arguments]    ${project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/search/projects/${project_id}/personalization/products    params=${params_uri}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1813352693/Merchant+Transaction+Proxy+API+get+merchant
Get Merchant
    [Arguments]    ${project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/merchant-transaction/projects/${project_id}/merchant    params=${params_uri}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Fetch Merchant Id
    [Arguments]    ${property}    ${return_name}
    ${merchant_id_list}    Get Property Value From Json By Index    ${property}
    ${merchant_id}    Fetch From Left    ${merchant_id_list}    ,
    Set Test Variable    ${${return_name}}    ${merchant_id}
    
# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1798176874/Merchant+Transaction+Proxy+API+get+merchant+detail
Get Merchant Details
    [Arguments]    ${project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/merchant-transaction/projects/${project_id}/merchant/detail    params=${params_uri}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1813973963/Merchant+Transaction+Proxy+API+get+merchant+description
Get Merchant Description
    [Arguments]    ${project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/merchant-transaction/projects/${project_id}/merchant/description    params=${params_uri}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1813352754/Merchant+Transaction+Proxy+API+get+count+merchant
Get Count Merchant
    [Arguments]    ${project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /${bifrost_service}/api/merchant-transaction/projects/${project_id}/count/merchant    params=${params_uri}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}