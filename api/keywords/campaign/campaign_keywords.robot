*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${campaign_api}             /campaign/api/campaigns

*** Keywords ***
Set Campaign Start Date
    ${today}=      Get Current Date        UTC
    ${start_date}=      Convert Date       ${today}       result_format=%Y-%m-%dT%H:%M:%S.%fZ
    Set Suite Variable    ${start_date}

Set Campaign End Date At Next 30 Days
    ${today}=      Get Current Date        UTC      increment=30 days
    ${end_date}=      Convert Date       ${today}       result_format=%Y-%m-%dT%H:%M:%S.%fZ
    Set Suite Variable    ${end_date}

Set Campaign Date Period
    Set Campaign Start Date
    Set Campaign End Date At Next 30 Days

Set Campaign End Date is Yesterday
    ${today}=      Get Current Date        UTC      increment=-1 day
    ${end_date}=      Convert Date       ${today}       result_format=%Y-%m-%dT%H:%M:%S.%fZ
    Set Test Variable    ${end_date}

Create Campaign
    [Arguments]     ${campaign_type}    ${campaign_group}   ${spending_amount}    ${payment_id}     ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}    ${start_date}     ${end_date}     ${status}
    ${create_campaign_body}=    Set Variable    {"type":"${campaign_type}","group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${campaign_api}    data=${create_campaign_body}    headers=&{GATEWAY_HEADER}
    Set Suite Variable        ${RESP}
    ${resp_body}=        To Json     ${RESP.text}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created ID
    ${created_campaign_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_id}
    Set Suite Variable        ${created_campaign_id}

#Template Keywords
Create Campaign With Required Fields Is Empty
    [Arguments]    ${campaign_type}    ${campaign_group}   ${spending_amount}    ${payment_id}     ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}    ${start_date}     ${end_date}     ${status}
    ${create_campaign_body}=    Set Variable    {"type":"${campaign_type}","group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${campaign_api}    data=${create_campaign_body}    headers=&{GATEWAY_HEADER}
    Set Suite Variable        ${RESP}
    Response Correct Code    ${BAD_REQUEST_CODE}

Create Campaign With Required Fields Is Missing
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${campaign_api}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    Method argument not valid

Create Campaign With Multiple Payment Method
    [Arguments]     ${campaign_type}    ${campaign_group}   ${spending_amount}    ${payment_id_1}     ${payment_id_2}   ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}    ${start_date}     ${end_date}     ${status}
    ${create_campaign_body}=    Set Variable    {"type":"${campaign_type}","group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id_1},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"},{"id":${payment_id_2},"methodCode":"ALIPAY","methodName":"Alipay","description":"Paid via Alipay"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${campaign_api}    data=${create_campaign_body}    headers=&{GATEWAY_HEADER}
    Set Suite Variable        ${RESP}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Created ID
    ${created_campaign_id}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_id}
    Set Suite Variable        ${created_campaign_id}

Update Campaign By ID
    [Arguments]      ${created_campaign_id}     ${campaign_type}    ${campaign_group}   ${spending_amount}    ${payment_id}     ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}    ${start_date}     ${end_date}     ${status}
    ${update_campaign_body}=    Set Variable    {"id":${created_campaign_id},"type":"${campaign_type}","group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"},{"id":2,"methodCode":"ALIPAY","methodName":"Alipay","description":"Paid via Alipay"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${campaign_api}    data=${update_campaign_body}      headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Update Campaign With Multiple Payment Method
    [Arguments]      ${created_campaign_id}     ${campaign_type}    ${campaign_group}   ${spending_amount}    ${payment_id_1}     ${payment_id_2}   ${point}    ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}    ${start_date}     ${end_date}     ${status}
    ${update_campaign_body}=    Set Variable    {"id":${created_campaign_id},"type":"${campaign_type}","group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id_1},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"},{"id":${payment_id_2},"methodCode":"ALIPAY","methodName":"Alipay","description":"Paid via Alipay"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${campaign_api}    data=${update_campaign_body}      headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Template Keywords
Update Campaign With Required Fields Is Empty
    [Arguments]      ${created_campaign_id}     ${campaign_type}    ${campaign_group}   ${spending_amount}    ${payment_id}     ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}    ${start_date}     ${end_date}     ${status}
    Update Campaign By ID    ${created_campaign_id}     ${campaign_type}    ${campaign_group}   ${spending_amount}    ${payment_id}     ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}            ${start_date}     ${end_date}     ${status}
    Response Correct Code    ${BAD_REQUEST_CODE}

Update Campaign With Required Fields Is Missing
    [Arguments]    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${campaign_api}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    Method argument not valid

Get Campaign By ID
    [Arguments]     ${created_campaign_id}
    ${RESP}=             Get Request       ${GATEWAY_SESSION}      ${campaign_api}/${created_campaign_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Campaign Under Merchant Type
    [Arguments]     ${campaign_group}
    ${RESP}=             Get Request       ${GATEWAY_SESSION}      ${campaign_api}?group.equals=${campaign_group}&type.equals=merchant    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    Response Should Contain All Property Values Contain    .type        merchant    ${TRUE}
    Response Should Contain All Property Values Contain    .group       ${campaign_group}    ${TRUE}

Get All Campaign Under Customer Type
    [Arguments]     ${campaign_group}
    ${RESP}=             Get Request       ${GATEWAY_SESSION}      ${campaign_api}?group.equals=${campaign_group}&type.equals=customer    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    Response Should Contain All Property Values Contain    .type        customer    ${TRUE}
    Response Should Contain All Property Values Contain    .group       ${campaign_group}    ${TRUE}

Delete Campaign By ID
    [Arguments]    ${created_campaign_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${campaign_api}/${created_campaign_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Update Campaign Status
    [Arguments]      ${created_campaign_id}     ${campaign_status}
    ${create_campaign_body}=    Set Variable    {"id":${created_campaign_id},"status":"${campaign_status}"}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${campaign_api}/status    data=${create_campaign_body}      headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}