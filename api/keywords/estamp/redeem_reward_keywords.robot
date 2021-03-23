*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${redeem_reward_api}          /estamp-v2/api/redeemed-rewards
${approve_redeem_reward_api}     /estamp-v2/api/unique-codes
${edc_approve_redeemed_stamp_api}     /estamp-v2/edc/api/unique-codes


*** Keywords ***
Generate RedeemCode To Redeem Reward
	[Arguments]       ${redeem_reward_id}    ${created_stamp_account_id}
	${generate_redeem_body}=    Set Variable    {"rewardId":"${redeem_reward_id}","stampAccountId":"${created_stamp_account_id}"}
	${RESP}=    Post Request    ${GATEWAY_SESSION}    ${redeem_reward_api}    data=${generate_redeem_body}    headers=&{GATEWAY_HEADER}
	Set Suite Variable        ${RESP}
	${resp_body}=        To Json     ${RESP.text}
	Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Generated RedeemCode
	${generate_redeem_code}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_redeem}
	Set Suite Variable        ${generate_redeem_code}

Get Generated RedeemCode
    ${get_redeem}=    Get Value From Json    ${RESP.json()}    $.uniqueCode.code
    ${get_redeem}=    Get From List    ${get_redeem}    0
    Set Suite Variable    ${get_redeem}

TSM Merchant Use Unique Code To Approve Redeem Reward
    [Arguments]     ${generate_redeem_code}
    ${RESP}=             Put Request       ${GATEWAY_SESSION}      ${approve_redeem_reward_api}/${generate_redeem_code}/redeemed-reward-approval    headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}

EDC Merchant Use Unique Code To Approve Redeem Reward
    [Arguments]     ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    ${ecd_redeemed_body}=    Set Variable    {"brand":"${brand_code}","outlet":"${outlet_id}","terminal":"${terminal_id}"}
    ${RESP}=             Put Request       ${GATEWAY_SESSION}      ${edc_approve_redeemed_stamp_api}/${generate_redeem_code}/redeemed-reward-approval   data=${ecd_redeemed_body}  headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}