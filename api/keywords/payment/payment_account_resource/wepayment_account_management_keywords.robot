#Reference Document: https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1790706742/WePayment+Payment+Account+API

*** Keywords ***
#PAYMENT ACCOUNT MANAGEMENT
Post Create Payment Account
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Payment Account List
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Payment Account By Id
    [Arguments]    ${payment_account_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/${payment_account_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Payment Account
    [Arguments]    ${payment_account_id}    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/${payment_account_id}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#OMISE ACCOUNT MANAGEMENT
Post Create Omise Account
    [Arguments]    ${payment_account_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/${payment_account_id}/omise-account    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Omise Account
    [Arguments]    ${payment_account_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/${payment_account_id}/omise-account    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Omise Account
    [Arguments]    ${payment_account_id}    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/${payment_account_id}/omise-account    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#ACCESS CONTROL MANAGEMENT - APP CLIENT
Post Create App Client
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/app-client    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get List All App Client
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/app-client    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update App Client
    [Arguments]    ${client_id}    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/app-client/${client_id}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#ACCESS CONTROL MANAGEMENT
Post Manage Authority
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/authority    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Access Management Authority
    [Arguments]    ${project_id}    ${key_subject}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /accessmanagement/api/projects/${WEPAYMENT_PROJECT_ID}/policies/subjects/key/${key_subject}/resources/key/${project_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
