*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
Post Create Push Client
    [Arguments]    ${project_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /notification/api/projects/${project_id}/push-notification/clients    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Push Notification
    [Arguments]    ${project_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /notification/api/projects/${project_id}/push-notification/messages    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Push Client
    [Arguments]    ${project_id}    ${push_notification_clients_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    /notification/api/projects/${project_id}/push-notification/clients/${push_notification_clients_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Current User Registrations 
    [Arguments]    ${we_platform_project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/projects/${we_platform_project_id}/push-notification/clients    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Fetch Push Notification Clients Id
    ${TEST_DATA_PUSH_NOTIFICATION_CLIENTS_ID}=    Get Property Value From Json By Index    id    0
    Set Test Variable    ${TEST_DATA_PUSH_NOTIFICATION_CLIENTS_ID}