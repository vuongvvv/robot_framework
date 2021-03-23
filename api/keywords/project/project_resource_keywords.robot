*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot


*** Variables ***
${create_project_url}    /project/api/projects

*** Keywords ***
Post Create Project
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${create_project_url}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Created ProjectID From Response
    ${project_id_list}=    Get Value From Json    ${RESP.json()}    $.id
    ${project_id}=    Get From List    ${project_id_list}    0
    Set Suite Variable    ${project_id}

Delete Project
    [Arguments]    ${project_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${create_project_url}/${project_id}     headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Projects
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${create_project_url}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Test Data Project Id
    [Arguments]    ${filter}=${EMPTY}
    Get All Projects    ${filter}
    ${TEST_DATA_PROJECT_ID}=    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${TEST_DATA_PROJECT_ID}

Generate RefCode
    [Arguments]  ${refCode_length}
    ${refCode} =	Generate Random String	${refcode_length}
    Set Test Variable   ${refcode}