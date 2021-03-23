*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${stamp_account_api}         /estamp-v2/api/stamp-accounts

*** Keywords ***
Create Stamp Account
    [Arguments]     ${created_campaign_id}      ${brand_code}
    ${create_stamp_account_body}=    Set Variable    {"campaignId":"${created_campaign_id}","brandCode":"${brand_code}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${stamp_account_api}    data=${create_stamp_account_body}    headers=&{GATEWAY_HEADER}
    Set Suite Variable        ${RESP}
    ${resp_body}=        To Json     ${RESP.text}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created ID
    ${created_stamp_account_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_id}
    Set Suite Variable        ${created_stamp_account_id}

Get Stamp Account Detail By ID
    [Arguments]     ${created_stamp_account_id}
    ${RESP}=             Get Request       ${GATEWAY_SESSION}      ${stamp_account_api}/${created_stamp_account_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Total Stamp Collected For Extra Reward Should Returns Correctly
    [Arguments]     ${stamp_amount1}    ${stamp_amount2}
    ${issued_extra_reward}=             Evaluate        ${stamp_amount1}+${stamp_amount2}
    Set Suite Variable        ${issued_extra_reward}

Total Stamp Collected For Main Reward Should Returns Correctly
    [Arguments]     ${issued_extra_reward}    ${stamp_amount}
    ${issued_main_reward}=             Evaluate        ${issued_extra_reward}+${stamp_amount}
    Set Suite Variable        ${issued_main_reward}