*** Settings ***
Resource    ../common/date_time_common.robot

*** Keywords ***
Get Apigee Payment Status
    [Arguments]      ${transaction_reference_Id}
    ${resp}=    Get Request    ${APIGEE_SESSION}    /payment/v1/payment/${transaction_reference_Id}/status    headers=&{api_headers}
    Set Test Variable    ${resp}

Get Transaction By Reference ID
    ${TEST_VARIABLE_TX_REF}=    Get Property Value From Json By Index    .transactionReferenceId    0
    Set Test Variable    ${TEST_VARIABLE_TX_REF}

Get Apigee Payment Status By ClientTrxId
    [Arguments]      ${terminal_id}      ${clientTrxId}      ${brandId}      ${branchId}
    ${resp}=    Get Request    ${APIGEE_SESSION}    /payment/v1/payment/terminals/${terminal_id}/client-trxs/${clientTrxId}/status?brandId=${brandId}&branchId=${branchId}    headers=&{api_headers}
    Set Test Variable    ${resp}

Generate Alipay Barcode
    [Arguments]   ${alipay_code_prefix}
    Get Unix Time Stamp From Current Date    timestamp
    ${str_unix_time_stamp}=   Convert To String    ${UNIX_TIME_STAMP}
    ${result_unix_time_stamp}=   Remove String     ${str_unix_time_stamp}  .
    Set Test Variable   ${ALIPAY_BARCODE}   ${alipay_code_prefix}${result_unix_time_stamp}
