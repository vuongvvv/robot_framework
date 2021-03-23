*** Settings ***
Resource    ../common/api_common.robot

*** Variables ***
${query_elastic_path}    /paymenttransaction/api/merchant-payment/_search/transactions
${maximum_search_payment_retry}    10

*** Keywords ***
Get Search Payment Transaction From Elastic Search
    [Arguments]    ${params_uri}=${EMPTY}    ${headers}=&{GATEWAY_HEADER}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${query_elastic_path}   params=${params_uri}    headers=&{headers}
    Set Test Variable    ${RESP}

Get Search Transaction
    [Arguments]    ${transaction_reference}
    Wait Until Keyword Succeeds    ${maximum_search_payment_retry}    0.5s    Verify Sync Elastic Search Transaction    query=transaction_reference:${transaction_reference}

Get Search Transaction After Cancel Transaction Success
    [Arguments]    ${transaction_reference}
    Verify Sync Elastic Search Transaction    query=transaction_reference:${transaction_reference}
    ${property_value}=    Get Value From Json    ${RESP.json()}    $..paymentMethod.digitalWallet.type
    ${property_value}    Set Variable    ${property_value}[0]
    Run Keyword If    ${property_value == 'ALIPAY'}   Wait Until Keyword Succeeds    ${maximum_search_payment_retry}    0.5s    Verify Sync Elastic Search Transaction    query=transaction_reference:${transaction_reference} AND transaction_type:CANCEL
    ...    ELSE    Wait Until Keyword Succeeds    ${maximum_search_payment_retry}    0.5s    Verify Sync Elastic Search Transaction    query=source_transaction_id:${transaction_reference}C

Verify Page Size
    [Arguments]    ${size_number}
    Should Contain    &{RESP.headers}[Link]    </api/merchant-payment/_search/transactions?page=0&size=${size_number}>

Response Should Not Found
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty

Verify Sync Elastic Search Transaction
    [Arguments]    ${params}
    Get Search Payment Transaction From Elastic Search    ${params}
    Response Should Contain Property With String Or Null    .transactionReference

Verify Elastic Search Transaction Should Not Sync
    [Arguments]    ${params_uri}
    FOR    ${index}    IN RANGE    0    5
        Get Search Payment Transaction From Elastic Search    query=${params_uri}
        Response Should Not Found
        #everage sync time to elastic search is 1sec, create the loop for check the transaction didn't sync as expected.
        Sleep    0.2
    END
