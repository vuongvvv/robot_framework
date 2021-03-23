*** Settings ***
Resource    ../common/string_common.robot

*** Variables ***
${inventory_url}    /inventory/api/projects

*** Keywords ***
Get Random Company Name
    ${random_company_name} =    Random Unique String By Epoch Datetime
    Set Suite Variable    ${RANDOM_COMPANY_NAME}    ${random_company_name}

Post Create Company
    [Arguments]    ${project_id}   ${data}
    ${RESP}=   Post Request    ${GATEWAY_SESSION}    ${inventory_url}/${project_id}/companies    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Created Company ID
    ${COMPANY_ID}=    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${COMPANY_ID}

Delete Company
    [Arguments]    ${project_id}   ${id}
    ${RESP}=   Delete Request   ${GATEWAY_SESSION}    ${inventory_url}/${project_id}/companies/${id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}