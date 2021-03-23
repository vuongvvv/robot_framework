*** Settings ***
Resource      apigee_keywords.robot
Resource    ../common/json_common.robot
Resource    ../common/file_common.robot
Resource    ../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../common/database_common.robot

*** Variables ***
${true_money_payment_code_file_path}    /resources/testdata/apigee/true_money_payment_code.csv
${timestamp_get_line}    2019/09/09
${maximum_create_payment_retry}    2987

# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/237896058/Apigee
*** Keywords ***
Get True You Privilege
    [Arguments]    ${terminal_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${APIGEE_SESSION}    /privilege/v1/terminals/${terminal_id}/true-you-card    params=${params_uri}    headers=&{api_headers}
    Set Test Variable    ${RESP}

Post Redeem By Campaign
    [Arguments]    ${terminal_id}    ${data}
    ${RESP}=    Post Request    ${APIGEE_SESSION}    /privilege/v1/terminals/${terminal_id}/redeem-campaign    data=${data}    headers=&{api_headers}
    Set Test Variable    ${RESP}

Post Redeem By Campaign With Wrong Url
    [Arguments]    ${terminal_id}    ${data}
    ${RESP}=    Post Request    ${APIGEE_SESSION}    /privilege/v1/terminals/${terminal_id}/invalidredeem-campaign    data=${data}    headers=&{api_headers}
    Set Test Variable    ${RESP}

Post Redeem By Code
    [Arguments]    ${terminal_id}    ${data}
    ${RESP}=    Post Request    ${APIGEE_SESSION}    /privilege/v1/terminals/${terminal_id}/redeem-code    data=${data}    headers=&{api_headers}
    Set Test Variable    ${RESP}

Post Earn Point
    [Arguments]    ${terminal_id}    ${data}
    ${RESP}=    Post Request    ${APIGEE_SESSION}    /privilege/v1/terminals/${terminal_id}/earn-point    data=${data}    headers=&{api_headers}
    Set Test Variable    ${RESP}

Post Create Payment
    [Arguments]    ${terminal_id}    ${data}
    ${RESP}=    Post Request    ${APIGEE_SESSION}    /payment/v1/terminals/${terminal_id}/payments    data=${data}    headers=&{api_headers}
    Set Test Variable    ${RESP}

Get Payment Code From Postgres Database
    Connect Postgres Database
    ${query_result}=    Query Database    select id,payment_code from o2oautomation.payment_code where mark_as_delete=false order by random() limit 1;
    ${list_id_payment_code}=    Get From List    ${query_result}    0
    ${payment_code}=    Get From List    ${list_id_payment_code}    1
    Disconnect Database
    [Return]    ${payment_code}

Update Payment Code To Be Used On Postgres Database
    [Arguments]    ${used_payment_code}
    Connect Postgres Database
    Execute Sql Command    UPDATE o2oautomation.payment_code SET mark_as_delete=true WHERE payment_code='${used_payment_code}';
    Disconnect Database

Create Payment By Random Code
    [Arguments]    ${terminal_id}    ${data}    ${max_retry}=6
    FOR    ${index}    IN RANGE    1    ${max_retry}
        # Build request body for Create Payment API
        ${request_body} =    To JSON    ${data}
        ${random_ref_code_status} =    Is Property With Value Exist In Json    payment.clientTrxId    RANDOM_TRANSACTION_REF_CODE    ${request_body}
        ${true_money_payment_code}=    Get Payment Code From Postgres Database
        ${UPDATED_REQUEST_BODY} =   Update Value To Json    ${request_body}    $.payment.code    ${true_money_payment_code}
        Run Keyword If    ${random_ref_code_status}==${TRUE}    Update Transaction Ref Code Into Create Payment Body    ${UPDATED_REQUEST_BODY}
        ${request_body_string} =    JSONLibrary.Convert JSON To String    ${UPDATED_REQUEST_BODY}
        # Call Create Payment API
        Post Create Payment    ${terminal_id}    ${request_body_string}
        Update Payment Code To Be Used On Postgres Database    ${true_money_payment_code}
        EXIT FOR LOOP IF  '${RESP.status_code}' == '${SUCCESS_CODE}'
    END
    Set Test Variable    ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}    ${true_money_payment_code}

Update Transaction Ref Code Into Create Payment Body
    [Arguments]    ${update_request_body}
    Generate Transaction Reference    10
    ${updated_request_body} =   Update Value To Json    ${update_request_body}    $.payment.clientTrxId    ${TRANSACTION_REFERENCE}
    Set Test Variable    ${UPDATED_REQUEST_BODY}    ${updated_request_body}

Post Void Payment
    [Arguments]    ${terminal_id}    ${trace_id}    ${data}
    ${RESP}=    Post Request    ${APIGEE_SESSION}    /payment/v1/terminals/${terminal_id}/payments/${trace_id}/void    data=${data}    headers=&{api_headers}
    Set Test Variable    ${RESP}

Post Void Earn Point
    [Arguments]    ${terminal_id}    ${trace_id}    ${data}
    ${RESP}=    Post Request    ${APIGEE_SESSION}    /privilege/v1/terminals/${terminal_id}/earn-point/${trace_id}/void    data=${data}    headers=&{api_headers}
    Set Test Variable    ${RESP}

Post Void Redeem By Campaign
    [Arguments]    ${terminal_id}    ${trace_id}    ${data}
    ${RESP}=    Post Request    ${APIGEE_SESSION}    /privilege/v1/terminals/${terminal_id}/burn-point/${trace_id}/void    data=${data}    headers=&{api_headers}
    Set Test Variable    ${RESP}

# Template
Get True You Privilege With Missing Or Empty Required Fields
    [Arguments]    ${terminal_id}    ${params_uri}    ${return_name}    ${return_message}
    Get True You Privilege    ${terminal_id}    ${params_uri}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .fields..name    ${return_name}
    Response Should Contain Property With Value    .fields..message    ${return_message}

Get True You Privilege With Invalid Params
    [Arguments]    ${terminal_id}    ${params_uri}    ${display_code}    ${return_message}
    Get True You Privilege    ${terminal_id}    ${params_uri}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    API_3_PARTY
    Response Should Contain Property With Value    .displayCode    ${display_code}
    Response Should Contain Property With Value    .messsage    ${return_message}
    Response Should Contain Property With Empty Value    .fields

Redeem By Campaign With Missing Fields
    [Arguments]    ${terminal_id}    ${data}    ${return_name}    ${return_message}
    Post Redeem By Campaign    ${terminal_id}    ${data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Bad Request
    Response Should Contain Property With Value    .fields..name    ${return_name}
    Response Should Contain Property With Value    .fields..message    ${return_message}

Get Trace Id
    ${TEST_VARIABLE_TRACE_ID}=    Get Property Value From Json By Index    .traceId    0
    Set Test Variable    ${TEST_VARIABLE_TRACE_ID}

Redeem By Campaign With Invalid Fields
    [Arguments]    ${terminal_id}    ${data}    ${return_code}    ${code}    ${display_code}    ${return_message}
    Post Redeem By Campaign    ${terminal_id}    ${data}
    Response Correct Code    ${return_code}
    Response Should Contain Property With Value    .code    ${code}
    Response Should Contain Property With Value    .displayCode    ${display_code}
    Response Should Contain Property With Value    .messsage    ${return_message}
    Response Should Contain Property With Empty Value    .fields

#Test data preparation
Generate Voided Trace Id
    Post Redeem By Campaign    ${TERMINAL_ID}    {"brandId":"${BRAND_ID}","branchId":"${BRANCH_ID}", "campaignCode": "${CAMPAIGN_CODE}","account":{"type":"${ACCOUNT_TYPE}","value":"${ACCOUNT_VALUE}"}}
    Get Trace Id
    Post Void Redeem By Campaign    ${TERMINAL_ID}    ${TEST_VARIABLE_TRACE_ID}    { "brandId": "${BRAND_ID}", "branchId": "${BRANCH_ID}" }

Get Test Data True Money Payment Code
    ${random_line_number} =    Evaluate    random.randint(0,2987)    random
    ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE} =    Get Line Content From File    /resources/testdata/apigee/true_money_payment_code.csv    ${random_line_number}
    Set Test Variable    ${TEST_DATA_TRUE_MONEY_PAYMENT_CODE}
