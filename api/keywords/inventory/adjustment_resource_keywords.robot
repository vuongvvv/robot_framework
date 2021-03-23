*** Settings ***
Resource    ../common/string_common.robot

*** Variables ***
${inventory_url}    /inventory/api/projects

*** Keywords ***
Post Create Adjustment
    [Arguments]  ${project_id}  ${data}
    ${RESP}=    Post Request  ${GATEWAY_SESSION}    ${inventory_url}/${project_id}/adjustments    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Generate Random Stock Transaction
    ${random_stock_transaction}=  Get Random Strings   8   [NUMBERS]
    Set Test Variable    ${RANDOM_STOCK_TRANSACTION}    ${random_stock_transaction}