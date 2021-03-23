*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Generate Key From Current Date Time
    ${key} =    Random Unique String By Epoch Datetime
    Set Test Variable    ${KEY}

Create List Of Key To Verify
    @{list_of_key} =	Create List	   automated-1-${KEY}    automated-2-${KEY}
    Set Test Variable    ${LIST_OF_KEY}

Post Create Policy
    [Arguments]    ${project_id}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/policies    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Policies
    [Arguments]    ${project_id}    ${params_uri}=${EMPTY}
    ${RESP}=      Get Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/policies    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Add Subjects
    [Arguments]    ${project_id}    ${policy_id}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/policies/${policy_id}/subjects    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Subjects
    [Arguments]    ${project_id}    ${policy_id}    ${request_data}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/policies/${policy_id}/subjects    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Collect Policy Id From Response
    ${POLICY_ID}=    Get Property Value From Json By Index    $.id    0
    Set Test Variable    ${POLICY_ID}

Post Add Resources
    [Arguments]    ${project_id}    ${policy_id}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/policies/${policy_id}/resources    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Resources
    [Arguments]    ${project_id}    ${policy_id}    ${request_data}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/policies/${policy_id}/resources    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Post Add Actions
    [Arguments]    ${project_id}    ${policy_id}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/policies/${policy_id}/actions    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Delete Actions
    [Arguments]    ${project_id}    ${policy_id}    ${request_data}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/policies/${policy_id}/actions    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}