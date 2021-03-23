*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Generate Resource Key From Current Date Time
    ${key} =    Get Time    format=epoch
    ${key}=    Convert To String    ${key}
    Set Test Variable    ${KEY}

Post Create Resource
    [Arguments]    ${project_id}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/resources    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Resources
    [Arguments]    ${project_id}
    ${RESP}=      Get Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/resources    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Add Action
    [Arguments]    ${project_id}    ${resource_key}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/resources/key/${resource_key}/actions    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Resource Action
    [Arguments]    ${project_id}    ${resource_key}    ${action_delete}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/resources/key/${resource_key}/actions/${action_delete}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Add Children
    [Arguments]    ${project_id}    ${parent_key}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/resources/key/${parent_key}/children   data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Create List Of Value To Verify
    [Arguments]    ${expected_value}
    @{list_of_expected_value}=    Create List	   ${expected_value}
    Set Test Variable    ${LIST_OF_EXPECTED_VALUE}

Delete Children
    [Arguments]    ${project_id}    ${parent_key}    ${request_data}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/resources/key/${parent_key}/children   data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}