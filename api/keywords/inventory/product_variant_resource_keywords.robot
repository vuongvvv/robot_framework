*** Settings ***
Library    Collections
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot

*** Variables ***
${inventory_url}    /inventory/api/projects

*** Keywords ***
Post Create Product Variants
    [Arguments]    ${project_id}   ${product_id}   ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${inventory_url}/${project_id}/products/${product_id}/variants    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}