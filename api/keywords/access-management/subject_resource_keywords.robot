*** Settings ***
Resource    ../common/string_common.robot

*** Keywords ***
Generate Subject Key From Current Date Time
    ${key} =    Get Time    format=epoch
    ${key} =    Convert to String    ${key}
    Set Test Variable    ${KEY}

Post Create Subject
    [Arguments]    ${project_id}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/subjects    data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Subjects
    [Arguments]    ${project_id}
    ${RESP}=      Get Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/subjects    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Add Children
    [Arguments]    ${project_id}    ${parent_key}    ${request_data}
    ${RESP}=      Post Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/subjects/key/${parent_key}/children   data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Children
    [Arguments]    ${project_id}    ${parent_key}    ${request_data}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /accessmanagement/api/projects/${project_id}/subjects/key/${parent_key}/children   data=${request_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Create List Of Value To Verify
    [Arguments]    ${expected_value}
    @{list_of_expected_value}=    Create List	   ${expected_value}
    Set Test Variable    ${LIST_OF_EXPECTED_VALUE}
    
Generate Project Id
    ${PROJECT_ID}=    Random Unique String By Epoch Datetime
    Set Test Variable    ${PROJECT_ID}