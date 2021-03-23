*** Settings ***
Resource    ../common/string_common.robot
Resource    ../common/json_common.robot

*** Keywords ***
Generate Transaction Reference Id
    ${TRANSACTION_REFERENCE_ID}=    Random Unique String By Epoch Datetime
    Set Test Variable    ${TRANSACTION_REFERENCE_ID}

Post Redeem By Code
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    /edc-app-services/v1/redeems/code    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Redeem By Campaign
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    /edc-app-services/v1/redeems/campaign    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Void
    [Arguments]     ${request_data}
    ${RESP}=      Post Request     ${RPP_GATEWAY_SESSION}    /edc-app-services/v1/voids    data=${request_data}   headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Fetch Trace Id
    ${TEST_DATA_TRACE_ID}=    Get Property Value From Json By Index    trace_id    0
    Set Test Variable    ${TEST_DATA_TRACE_ID}

Fetch Transaction Reference Id
    ${TEST_DATA_TRANSACTION_REFERENCE_ID}=    Get Property Value From Json By Index    tx_ref_id    0
    Set Test Variable    ${TEST_DATA_TRANSACTION_REFERENCE_ID}