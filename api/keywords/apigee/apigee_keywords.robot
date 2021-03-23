*** Settings ***
Resource    ../common/gateway_common.robot
Resource    ../mapping/mapping_resource_keywords.robot

*** Keywords ***
Generate Apigee Header
    [Arguments]    ${client_id}=${APIGEE_CLIENT_ID_MAPPING_ACTIVE_FALSE}    ${client_secret}=${APIGEE_CLIENT_SECRET_MAPPING_ACTIVE_FALSE}
    Create Apigee Session 
    ${authorization_key}=    Generate Authorization Key    ${client_id}    ${client_secret}  
    &{data}=    Create Dictionary    grant_type=client_credentials
    &{headers}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded    Authorization=Basic ${authorization_key}
    ${resp}=    Post Request    ${APIGEE_SESSION}    /oauth/token    data=&{data}    headers=&{headers}
    &{resp_body}=    To Json    ${resp.text}   
    &{api_headers}=    Create Dictionary    authorization=${resp_body.token_type} ${resp_body.access_token}
    Set Suite Variable    &{api_headers}
    
Set Invalid Access Token
    &{api_headers}=    Create Dictionary    authorization=Bearer D6OuCfWrY9T6Q8DiHSepP6YcS4v7xx
    Set Suite Variable    &{api_headers}

#Data preparation
Prepare External Ids
    [Arguments]    ${external_terminal_id}    ${external_brand_id}    ${external_branch_id}    ${internal_terminal_id}    ${internal_brand_id}    ${internal_branch_id}    ${mark_as_delete}=false
    Generate Gateway Header With Scope and Permission    ${APIGEE_USERNAME}    ${APIGEE_USERNAME_PASSWORD}    permission_name=mapping.mapping.actAsAdmin
    Put Update Mapping    { "id": "5bac873a7746be0001952f6b", "app": "pos", "client": "egg", "markAsDelete": ${mark_as_delete}, "mapping": { "terminalId": { "${external_terminal_id}": "${internal_terminal_id}" }, "merchantId": { "${external_brand_id}": "${internal_brand_id}" }, "outletId": { "${external_branch_id}": "${internal_branch_id}" } } }
    Delete Created Client And User Group
