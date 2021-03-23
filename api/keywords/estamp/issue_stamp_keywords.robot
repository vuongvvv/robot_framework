*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${issue_stamp_api}              /estamp-v2/api/issued-stamps
${approve_issued_stamp_api}         /estamp-v2/api/unique-codes
${edc_approve_issued_stamp_api}     /estamp-v2/edc/api/unique-codes

*** Keywords ***
Generate Unique Code To Issue Stamp
    [Arguments]     ${created_stamp_account_id}      ${stamp_amount}
    ${generate_uniquecode_body}=    Set Variable    {"stampAccountId":"${created_stamp_account_id}","stampAmount":"${stamp_amount}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${issue_stamp_api}    data=${generate_uniquecode_body}    headers=&{GATEWAY_HEADER}
    Set Suite Variable        ${RESP}
    ${resp_body}=        To Json     ${RESP.text}
    Run Keyword If    '${RESP}'=='<Response [${CREATED_CODE}]>'   Get Generated Unique Code Number
    ${generate_uniquecode_code}=   Set Variable If	'${RESP}'=='<Response [${CREATED_CODE}]>'    ${get_code}
    Set Suite Variable        ${generate_uniquecode_code}

Get Generated Unique Code Number
    ${get_code}=    Get Value From Json    ${RESP.json()}    $.uniqueCode.code
    ${get_code}=    Get From List    ${get_code}    0
    Set Suite Variable    ${get_code}

TSM Merchant Use Unique Code To Approve Issued Stamp
    [Arguments]     ${generate_uniquecode_code}
    ${RESP}=             Put Request       ${GATEWAY_SESSION}      ${approve_issued_stamp_api}/${generate_uniquecode_code}/issued-stamp-approval    headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}

EDC Merchant Use Unique Code To Approve Issued Stamp
    [Arguments]     ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    ${ecd_issued_body}=    Set Variable    {"brand":"${brand_code}","outlet":"${outlet_id}","terminal":"${terminal_id}"}
    ${RESP}=             Put Request       ${GATEWAY_SESSION}      ${edc_approve_issued_stamp_api}/${generate_uniquecode_code}/issued-stamp-approval   data=${ecd_issued_body}  headers=&{GATEWAY_HEADER}
    Set Suite Variable    ${RESP}