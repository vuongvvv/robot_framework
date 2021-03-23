*** Variables ***
${inventory_url}    /inventory/api/projects

*** Keywords ***
Post Create Delivery Transfer
    [Arguments]  ${project_id}  ${data}
    ${RESP}=    Post Request   ${GATEWAY_SESSION}   ${inventory_url}/${project_id}/delivery-transfers    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Delivery Transfer
    [Arguments]  ${project_id}  ${id}  ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${inventory_url}/${project_id}/delivery-transfers/${id}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Created Delivery Transfer ID From Response
    ${DELIVERY_TRANSFER_ID}=    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${DELIVERY_TRANSFER_ID}

Post Create Internal Transfer
    [Arguments]  ${project_id}  ${data}
    ${RESP}=    Post Request   ${GATEWAY_SESSION}   ${inventory_url}/${project_id}/internal-transfers    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Created Internal Transfer ID From Response
    ${INTERNAL_TRANSFER_ID}=    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${INTERNAL_TRANSFER_ID}

Put Internal Delivery Transfer
    [Arguments]  ${project_id}  ${id}  ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${inventory_url}/${project_id}/internal-transfers/${id}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Create Receipt Transfer
    [Arguments]  ${project_id}  ${data}
    ${RESP}=    Post Request   ${GATEWAY_SESSION}   ${inventory_url}/${project_id}/receipt-transfers    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
