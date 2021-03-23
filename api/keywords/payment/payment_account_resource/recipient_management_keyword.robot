#Reference Document: https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1864335954/WePayment+Recipient+API

*** Keywords ***
Post Create Recipients To Payment Account
    [Arguments]    ${payment_account_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/${payment_account_id}/recipient    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Recipients From Payment Account
    [Arguments]    ${payment_account_id}    ${recipient_id}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /payment/api/v1/payment-account/${payment_account_id}/recipient/${recipient_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Prepare Recipient Id
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "PREPARE-recipient-automate","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .id    O2O_RECIPIPIENT_ID
