*** Settings ***
Resource    ../../resources/init.robot
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot
Resource    ../common/file_common.robot
Resource    ../apigee/apigee_privilege_keywords.robot

*** Variable ***
${payment_bs_v2_url}    /crm-ms-payment-api/v2/api/charges
${payment_bs_v4_url}    /crm-ms-payment-api/v4/api/charges

*** Keywords ***
Get RPP Payment Status
    ${RESP}=    Get Request    ${RPP_GATEWAY_SESSION}    /crm-ms-payment-api/v1/api/payment/${TEST_VARIABLE_TX_REF_ID}/status    headers=${RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Void Transaction RPP Payment
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}    /crm-ms-payment-api/v4/api/charges/cancel    data=${data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Create RPP Payment
    [Arguments]    ${url}    ${data}    &{gateway_headers}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}    ${url}    data=${data}    headers=&{gateway_headers}
    Set Test Variable    ${RESP}

Post Create RPP Payment By Random Code
    [Arguments]    ${url}    ${data}    ${gateway_headers}    ${max_retry}=6
    # Build request body for Create Payment API
    FOR    ${index}    IN RANGE    1    ${max_retry}
        ${request_body} =    To JSON    ${data}
        ${random_client_trx_id} =    Is Property With Value Exist In Json    $.client_trx_id    RANDOM_CLIENT_TRANSACTION_ID    ${request_body}
        ${random_transaction_reference_id} =   Is Property With Value Exist In Json    tx_ref_id        RANDOM_TRANSACTION_REFERENCE_ID    ${request_body}
        ${true_money_payment_code}=    Get Payment Code From Postgres Database
        ${UPDATED_REQUEST_BODY} =   Update Value To Json    ${request_body}    $.payment_code    ${true_money_payment_code}
        Run Keyword If    ${random_client_trx_id}==${TRUE}    Update Client Transaction ID Into Create Payment Body    ${UPDATED_REQUEST_BODY}
        Run Keyword If    ${random_transaction_reference_id}==${TRUE}    Update Transaction Reference ID Into Create Payment Body    ${UPDATED_REQUEST_BODY}
        ${request_body_string} =    JSONLibrary.Convert JSON To String    ${UPDATED_REQUEST_BODY}
        # Call Create Payment API
        Post Create RPP Payment    ${url}    ${request_body_string}    &{gateway_headers}
        Update Payment Code To Be Used On Postgres Database    ${true_money_payment_code}
        ${property_value}=    Get Value From Json    ${RESP.json()}    $.status.code
        EXIT FOR LOOP IF  '${property_value}' == '${SUCCESS_CODE}'
    END
    Set Test Variable    ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}    ${true_money_payment_code}

Get Status Code
    ${TEST_VARIABLE_STATUS_CODE}=    Get Property Value From Json By Index    .status.code    0
    Set Test Variable    ${TEST_VARIABLE_STATUS_CODE}

Get Transaction Ref Number
    ${TEST_VARIABLE_TX_REF_ID}=    Get Property Value From Json By Index    .tx_ref_id   0
    Set Test Variable    ${TEST_VARIABLE_TX_REF_ID}

Get Errors Message
    ${TEST_VARIABLE_Errors_MESSAGE}=    Get Property Value From Json By Index    errors.message    0
    Set Test Variable    ${TEST_VARIABLE_Errors_MESSAGE}

Update Client Transaction ID Into Create Payment Body
    [Arguments]    ${update_request_body}
    Generate Client Transaction ID   6
    ${updated_request_body} =   Update Value To Json    ${update_request_body}    $.client_trx_id    ${CLIENT_TRANSACTION_ID}
    Set Test Variable    ${UPDATED_REQUEST_BODY}    ${updated_request_body}

Update Transaction Reference ID Into Create Payment Body
    [Arguments]    ${update_request_body}
    Generate Transaction Reference   20
    ${updated_request_body} =   Update Value To Json    ${update_request_body}    $.tx_ref_id       ${TRANSACTION_REFERENCE}
    Set Test Variable    ${UPDATED_REQUEST_BODY}    ${updated_request_body}
