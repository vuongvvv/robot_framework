*** Settings ***
Library    Collections
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot

*** Variables ***
${inventory_url}    /inventory/api/projects

*** Keywords ***
Post Create Product
    [Arguments]    ${project_id}  ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${inventory_url}/${project_id}/products    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Products
    [Arguments]    ${project_id}  ${product_internal_reference}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}     ${inventory_url}/${project_id}/products/${product_internal_reference}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Created Internal Reference ID From Response
    ${internal_reference_list}=    Get Value From Json    ${RESP.json()}    $.externalId
    ${INTERNAL_REFERENCE}=    Get From List    ${internal_reference_list}    0
    Set Suite Variable    ${INTERNAL_REFERENCE}

Get Created Product ID From Response
    ${product_id_list}=    Get Value From Json    ${RESP.json()}    $.id
    ${PRODUCT_ID}=    Get From List    ${product_id_list}    0
    Set Suite Variable    ${PRODUCT_ID}

Get Random Internal Reference ID
    ${random_internal_reference_id} =    Random Unique String By Epoch Datetime
    Set Suite Variable    ${RANDOM_INTERNAL_REFERENCE_ID}    ${random_internal_reference_id}