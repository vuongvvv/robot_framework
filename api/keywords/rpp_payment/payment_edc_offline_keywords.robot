*** Settings ***
Resource    ../../resources/init.robot
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot
Resource    ../common/file_common.robot
Resource    ../apigee/apigee_privilege_keywords.robot

*** Keywords ***
Post Create EDC Payment
    [Arguments]   ${data}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}   /edc-app-services/v1/payments/charge   data=${data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Void Transaction EDC Payment
    [Arguments]   ${data}
    ${RESP}=    Post Request    ${RPP_GATEWAY_SESSION}   /edc-app-services/v2/voids    data=${data}    headers=&{RPP_GATEWAY_HEADERS}
    Set Test Variable    ${RESP}

Post Create Edc Payment By Random Code
    [Arguments]    ${data}    ${max_retry}=6
    FOR    ${index}    IN RANGE    1    ${max_retry}
        # Build request body for Create Payment API
        ${request_body} =    To JSON    ${data}
        ${random_ref_code_status} =    Is Property With Value Exist In Json    $.client_trx_id    RANDOM_TRANSACTION_REF_CODE    ${request_body}
        ${true_money_payment_code}=    Get Payment Code From Postgres Database
        ${UPDATED_REQUEST_BODY} =   Update Value To Json    ${request_body}    $.payment_code    ${true_money_payment_code}
        Run Keyword If    ${random_ref_code_status}==${TRUE}    Update Transaction Ref Code Into Edc Create Payment Body    ${UPDATED_REQUEST_BODY}
        ${request_body_string} =    JSONLibrary.Convert JSON To String    ${UPDATED_REQUEST_BODY}
        # Call Create Payment API
        Post Create EDC Payment    ${request_body_string}
        Update Payment Code To Be Used On Postgres Database    ${true_money_payment_code}
        EXIT FOR LOOP IF  '${RESP.status_code}' == '${SUCCESS_CODE}'
    END
    Set Test Variable    ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}    ${true_money_payment_code}

Get EDC Trace Id
    ${TEST_VARIABLE_TRACE_ID}=    Get Property Value From Json By Index    .trace_id     0
    Set Test Variable    ${TEST_VARIABLE_TRACE_ID}

Update Transaction Ref Code Into Edc Create Payment Body
    [Arguments]    ${update_request_body}
    Generate Transaction Reference    10
    ${updated_request_body} =   Update Value To Json    ${update_request_body}    $.client_trx_id    ${TRANSACTION_REFERENCE}
    Set Test Variable    ${UPDATED_REQUEST_BODY}    ${updated_request_body}
