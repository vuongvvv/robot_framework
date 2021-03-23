*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot


*** Variables ***
${search_campaign_url}   /promotion/api/projects


*** Keywords ***
Post Redeem
    [Arguments]    ${data}  ${project_id}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${search_campaign_url}/${project_id}/redeem/campaign-code    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Data Preparation
Update Json Data With Array
    [Arguments]   ${input_json}   ${property}    ${array_string}
    ${return_json}=   Update Json With Value  ${input_json}    ${property}       ${array_string}
    Set Test Variable     ${UPDATED_JSON}    ${return_json}