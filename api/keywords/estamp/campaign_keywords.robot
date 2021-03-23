*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${create_campaign_api}         /campaign/api/promotions

*** Keywords ***
Set Campaign Started
    ${today}=      Get Current Date        increment=-3 days
    ${start_date}=      Convert Date       ${today}       result_format=%Y-%m-%dT%H:%M:%S.%fZ
    Set Suite Variable     ${start_date}

Set Campaign End Date Next 3 Days
    ${today}=      Get Current Date      increment=3 days
    ${end_date}=      Convert Date       ${today}       result_format=%Y-%m-%dT%H:%M:%S.%fZ
    Set Suite Variable     ${end_date}

Set Campaign Start Next 3 Days
    ${today}=      Get Current Date        increment=3 days
    ${start_date}=      Convert Date       ${today}       result_format=%Y-%m-%dT%H:%M:%S.%fZ
    Set Suite Variable     ${start_date}

Set Campaign End Date Expired
    ${today}=      Get Current Date        increment=-1 days
    ${end_date}=      Convert Date       ${today}       result_format=%Y-%m-%dT%H:%M:%S.%fZ
    Set Suite Variable     ${end_date}

Create E-stamp Campaign
    [Arguments]     ${name}     ${max_stamp}      ${extra_reward_stamp}     ${main_reward_stamp}     ${start_date}      ${end_date}     ${status}      ${brand_id}    ${outlet_id}    ${terminal_id}
    ${create_campaign_body}=    Set Variable    {"type":"ESTAMP","name":"${name}","campaignData":{"maxStampQuantity":${max_stamp}},"rules":[{"trigger":{"criteria":[{"type":"PURCHASE","level":"SKU","spending":{"spendingConditions":[{"option":"EVERY","amount":100,"currency":"THB"}]}}]},"benefit":{"data":[{"type":"STAMP_EARNING","amount":1}]}},{"trigger":{"criteria":[{"type":"STAMP_REDEMPTION","totalAmount":${extra_reward_stamp}}]},"benefit":{"data":[{"type":"FREE_ITEM","level":"SKU","itemData":{"items":[{"id":"sku002","quantity":1}]}}]}},{"trigger":{"criteria":[{"type":"STAMP_REDEMPTION","totalAmount":${main_reward_stamp}}]},"benefit":{"data":[{"type":"FREE_ITEM","level":"SKU","itemData":{"items":[{"id":"sku003","quantity":1}]}}]}}],"startDate":"${start_date}","endDate":"${end_date}","status":"${status}","platform":"O2O","participants":[{"merchantId":"${brand_id}","outletId":"${outlet_id}","terminalId":"${terminal_id}"}],"financing":[{"type":"MERCHANT","name":"${brand_id}"}]}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${create_campaign_api}    data=${create_campaign_body}    headers=&{GATEWAY_HEADER}
    Set Suite Variable        ${RESP}
    ${resp_body}=        To Json     ${RESP.text}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created ID
    ${created_campaign_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_id}
    Set Suite Variable        ${created_campaign_id}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created Extra Reward ID
    ${created_extra_reward_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_extra_rewards_id}
    Set Suite Variable        ${created_extra_reward_id}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created Main Reward ID
    ${created_main_reward_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_main_rewards_id}
    Set Suite Variable        ${created_main_reward_id}

Get Created Extra Reward ID
    ${get_extra_rewards_id}=    Get Value From Json    ${RESP.json()}    rules[1].benefit.data..itemData.items..id
    ${get_extra_rewards_id}=    Get From List    ${get_extra_rewards_id}    0
    Set Suite Variable    ${get_extra_rewards_id}

Get Created Main Reward ID
    ${get_main_rewards_id}=    Get Value From Json    ${RESP.json()}    rules[2].benefit.data..itemData.items..id
    ${get_main_rewards_id}=    Get From List    ${get_main_rewards_id}    0
    Set Suite Variable    ${get_main_rewards_id}

Create E-Stamp Campaign With No Reward Total Amount
    [Arguments]     ${name}     ${max_stamp}      ${start_date}      ${end_date}     ${status}      ${brand_id}    ${outlet_id}    ${terminal_id}
    ${create_campaign_body}=    Set Variable    {"type":"ESTAMP","name":"${name}","campaignData":{"maxStampQuantity":${max_stamp}},"rules":[{"trigger":{"criteria":[{"type":"PURCHASE","level":"SKU","spending":{"spendingConditions":[{"option":"EVERY","amount":100,"currency":"THB"}]}}]},"benefit":{"data":[{"type":"STAMP_EARNING","amount":1}]}},{"trigger":{"criteria":[{"type":"STAMP_REDEMPTION"}]},"benefit":{"data":[{"type":"FREE_ITEM","level":"SKU","itemData":{"items":[{"id":"sku002","quantity":1}]}}]}},{"trigger":{"criteria":[{"type":"STAMP_REDEMPTION"}]},"benefit":{"data":[{"type":"FREE_ITEM","level":"SKU","itemData":{"items":[{"id":"sku003","quantity":1}]}}]}}],"startDate":" ${start_date}","endDate":"${end_date}","status":"${status}","platform":"O2O","participants":[{"merchantId":"${brand_id}","outletId":"${outlet_id}","terminalId":"${terminal_id}"}],"financing":[{"type":"MERCHANT","name":"${brand_id}"}]}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${create_campaign_api}    data=${create_campaign_body}    headers=&{GATEWAY_HEADER}
    Set Suite Variable        ${RESP}
    ${resp_body}=        To Json     ${RESP.text}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created ID
    ${created_campaign_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_id}
    Set Suite Variable        ${created_campaign_id}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created Extra Reward ID
    ${created_extra_reward_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_extra_rewards_id}
    Set Suite Variable        ${created_extra_reward_id}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created Main Reward ID
    ${created_main_reward_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_main_rewards_id}
    Set Suite Variable        ${created_main_reward_id}

Create E-Stamp Campaign Reward Is Not Found
    [Arguments]     ${name}     ${max_stamp}      ${start_date}      ${end_date}     ${status}      ${brand_id}    ${outlet_id}    ${terminal_id}
    ${create_campaign_body}=    Set Variable    {"type":"ESTAMP","name":"${name}","campaignData":{"maxStampQuantity":${max_stamp}},"rules":[{"trigger":{"criteria":[{"type":"PURCHASE","level":"SKU","spending":{"spendingConditions":[{"option":"EVERY","amount":100,"currency":"THB"}]}}]},"benefit":{"data":[{"type":"STAMP_EARNING","amount":1}]}},{"trigger":{"criteria":[{"type":"PURCHASE","level":"SKU","spending":{"spendingConditions":[{"option":"EVERY","amount":100,"currency":"THB"}]}}]},"benefit":{"data":[{"type":"STAMP_EARNING","amount":1}]}}],"startDate":"${start_date}","endDate":"${end_date}","status":"${status}","platform":"O2O","participants":[{"merchantId":"${brand_id}","outletId":"${outlet_id}","terminalId":"${terminal_id}"}],"financing":[{"type":"MERCHANT","name":"${brand_id}"}]}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${create_campaign_api}    data=${create_campaign_body}    headers=&{GATEWAY_HEADER}
    Set Suite Variable        ${RESP}
    ${resp_body}=        To Json     ${RESP.text}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created ID
    ${created_campaign_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_id}
    Set Suite Variable        ${created_campaign_id}

Create E-Stamp Campaign Incorrect Reward Benefit
    [Arguments]     ${name}     ${max_stamp}      ${start_date}      ${end_date}     ${status}      ${brand_id}    ${outlet_id}    ${terminal_id}
    ${create_campaign_body}=    Set Variable    {"type":"ESTAMP","name":"${name}","campaignData":{"maxStampQuantity":${max_stamp}},"rules":[{"trigger":{"criteria":[{"type":"STAMP_REDEMPTION","totalAmount":5}]},"benefit":{"data":[{"type":"STAMP_EARNING","amount":1}]}},{"trigger":{"criteria":[{"type":"PURCHASE","level":"SKU","spending":{"spendingConditions":[{"option":"EVERY","amount":100,"currency":"THB"}]}}]},"benefit":{"data":[{"type":"STAMP_EARNING","amount":1}]}}],"startDate":"${start_date}","endDate":"${end_date}","status":"${status}","platform":"O2O","participants":[{"merchantId":"${brand_id}","outletId":"${outlet_id}","terminalId":"${terminal_id}"}],"financing":[{"type":"MERCHANT","name":" ${brand_id}"}]}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${create_campaign_api}    data=${create_campaign_body}    headers=&{GATEWAY_HEADER}
    Set Suite Variable        ${RESP}
    ${resp_body}=        To Json     ${RESP.text}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created ID
    ${created_campaign_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_id}
    Set Suite Variable        ${created_campaign_id}

Get E-Stamp Campaign Detail By ID
    [Arguments]     ${created_campaign_id}
    ${RESP}=             Get Request       ${GATEWAY_SESSION}      ${campaign_api}/${created_campaign_id}    headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}

Set E-Stamp Campaign Date Period
    Set Campaign Started
    Set Campaign End Date Next 3 Days

Set E-Stamp Campaign Start Date Is Not Published
    Set Campaign Start Next 3 Days
    Set Campaign End Date Next 3 Days

Set E-Stamp Campaign Start Date Is Passed
    Set Campaign Started
    Set Campaign End Date Next 3 Days

Set E-Stamp Campaign End Date Is Expired
    Set Campaign Start Next 3 Days
    Set Campaign End Date Expired

