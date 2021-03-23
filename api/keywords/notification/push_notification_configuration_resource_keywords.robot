*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
Post Create Push Notification Configuration
    [Arguments]    ${project_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /notification/api/projects/${project_id}/push-notification/configurations    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Push Notification Configurations
    [Arguments]    ${we_platform_project_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/projects/${we_platform_project_id}/push-notification/configurations    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Fetch Push Notification Configurations Id
    ${TEST_DATA_PUSH_NOTIFICATION_CONFIGURATIONS_ID}=    Get Property Value From Json By Index    id    0
    Set Test Variable    ${TEST_DATA_PUSH_NOTIFICATION_CONFIGURATIONS_ID}

Delete Push Notification Configuration
    [Arguments]    ${project_id}    ${push_notification_configurations_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    /notification/api/projects/${project_id}/push-notification/configurations/${push_notification_configurations_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}