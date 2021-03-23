*** Settings ***
Resource    ../common/api_common.robot
# Document : https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1200720435/Payment+SCB+Credit+Card

*** Variables ***
${amount}    220
${maximum_random_txref}    10
${valid_credit_card}    00acuiWUJwD8cgVwesx1wzqrHvTIwuREtPN01Ph6lRPrzIFj+H5yj3h6UsUtD+hT0/+t3KZZEp/xysrFCv8WrNeKefwtltCvLlZTSkpQ1sBORqO9DTa4MYT2fqXnrCaBJBoAM2u3PzQ76C7s72kvzkx9qfz1WbDBheURcHFEcvue+nU=U2FsdGVkX1+WL6cQecdCtGQfiSncWO9ZfZSLp/eAWEMaXhjPUywtcC/ECFv2CbuQ
${credit_card_with_valid_ipp_plan}    00acWHLH4+R7DRt0Pf/it/ms67o/EP5m5LNWn6EOKTX5CMuUDyySAIuMSGraZ8bqurzr7gQgLXnWdhyulNvO4l/kQycSL5sCd8uXzZZvbC80K+46KsD4D6B2JRoMIETMaDZvP+g3fBPagXJMaF0dsdynarspGhmZJZzYrHval82Kiho=U2FsdGVkX19STAP/ohxWm+NdPf/bXPgiCva+bm2biMF3ITETra1aNUa3g2IvZA8A
${reject_credit_card}    00acAmPUF7FQPM1X34QMj5dAe6KaNU0QfJEhpZYJCj7X59grPJvwoC01wmmSVLAtFRq9OAuYbbFJNr/txV3N9pxGvr2js0G3LbOhfdDYNAIEI5Z+DSeAUcCNVET2zxnD0Ux4nrDL7sTsc7oPNUAjtb17bu+bFqxOIJcVx63pXzaQk5c=U2FsdGVkX19Fx7WRl55GBTZv1plhrY7ti9J3uvAODPyiIKcsTyiqnEOdUE7iiKQU
${undecrypt_credit_card}    00acuiWUJwD8cgVwesx1wzqrHvTIwuREtPN01Ph6lRPrzIFj+H5yj3h6UsUtD+hT0/+t3KZZEp/xysrFCv8WrNeKefwtltCvLlZTSkpQ1sBORqO9DTa4MYT2fqXnrCaBJBoAM2u3PzQ76C7s72kvzkx9qfz1WbDBheURcHFEcvue+nU=U2FsdGVkX1+WL6cQecdCtGQfiSncWO9ZfZSLp/eAWEMaXhjPUywtcC/ECFv2CbUq
${aws_session}    https://37ukq4mk70.execute-api.ap-southeast-1.amazonaws.com

*** Keywords ***
# Payment Merchant Charge by CreditCard API
Post Payment Charge By Credit Card
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/charge    data=${data}    headers=&{O2O_KMS_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Payment Charge By Credit Card With Recurring Plan
    [Arguments]    ${merchant}    ${outlet}    ${recurring_plan}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/charge
    ...    data={"trueyouMerchantId": "${merchant}","trueyouOutletId": "${outlet}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "RECURRING-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}",${recurring_plan}}
    ...    headers=&{O2O_KMS_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Payment Charge By Credit Card With Installment Plan
    [Arguments]    ${merchant}    ${outlet}    ${min_amount}    ${installment_plan}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/charge
    ...    data={"trueyouMerchantId": "${merchant}","trueyouOutletId": "${outlet}","amount": "${min_amount}","currency": "${TH_CURRENCY}","clientRefId": "IPP-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${credit_card_with_valid_ipp_plan}",${installment_plan}}
    ...    headers=&{O2O_KMS_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Payment Merchant Void by CreditCard API
Post Payment Void By Credit Card
    [Arguments]    ${id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/${id}/void    data=${data}    headers=&{O2O_KMS_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Payment Merchant Refund by CreditCard API
Post Payment Refund By Credit Card
    [Arguments]    ${id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/${id}/refund    data=${data}    headers=&{O2O_KMS_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Create Merchant Payment DataKeyParis API
Post Generate Data Keypair For Merchant To Support 2C2P Payment
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/dataKeyPairs    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Payment Merchant Recurring Update API
Post Update 2C2P Recurring Plan
    [Arguments]    ${trx_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/${trx_id}/recurring    data=${data}    headers=&{O2O_KMS_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Payment Merchant Recurring Cancel API
Post Cancel 2C2P Recurring Plan
    [Arguments]    ${trx_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/${trx_id}/recurring/cancel    data=${data}    headers=&{O2O_KMS_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Merchant Payment Query by ClientRefId API
Get Payment By Client Ref Id
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/query-activity    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Search Merchant Payment Transaction API
Get Payment Transaction List By Merchant Or Admin
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Search Specific Detail Merchant Payment Transaction API
Get Specific Transaction By Merchant Or Admin
    [Arguments]    ${trx_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/${trx_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Payment Merchant Query Recurring History API
Get Merchant Query Recurring History
    [Arguments]    ${trx_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/${trx_id}/recurring/history    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

# Get Payment Merchant Recurring Subscription API
Get Merchant Query Recurring Subscription Plan
    [Arguments]    ${trx_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/transactions/${trx_id}/recurring    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Data Preparation Script
Prepare The Charge Transaction
    [Arguments]    ${trueyou_merchant}=${SCB_MERCHANT_ID}    ${trueyou_outlet}=${SCB_ACTIVE_OUTLET}
    Generate Transaction Reference    10
    Prepare The Encrypt Message    ${trueyou_merchant}    ${trueyou_outlet}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${trueyou_merchant}","trueyouOutletId": "${trueyou_outlet}","amount": "1400","currency": "${TH_CURRENCY}","clientRefId": "AUTO-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${trueyou_merchant}","trueyouOutletId": "${trueyou_outlet}","amount": "1400","currency": "${TH_CURRENCY}","clientRefId": "AUTO-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "automate_script1","userDefine2": "automate_script2","userDefine3": "automate_script3"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Fetch Property From Response    .clientRefId    CLIENT_REF_ID
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID

Prepare The Encrypt Message With Recurring Plan
    [Arguments]    ${merchant}    ${outlet}    ${recurring_plan}
    Fetch O2O Credit Card Publickey    ${merchant}    ${outlet}
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","trueyouMerchantId": "${merchant}","trueyouOutletId": "${outlet}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "RECURRING-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}",${recurring_plan}}
    Set Gateway Header With Kms Security Header

Prepare The Encrypt Message With Installment Plan
    [Arguments]    ${merchant}    ${outlet}    ${min_amount}    ${installment_plan}
    Fetch O2O Credit Card Publickey    ${merchant}    ${outlet}
    Post Encrypt Message With KMS    {"publicKey": "${O2O_CREDIT_CARD_PUBLIC_KEY}","trueyouMerchantId": "${merchant}","trueyouOutletId": "${outlet}","amount": "${min_amount}","currency": "${TH_CURRENCY}","clientRefId": "IPP-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${credit_card_with_valid_ipp_plan}",${installment_plan}}
    Set Gateway Header With Kms Security Header

Prepare The Charge Transaction With Recurring Plan
    [Arguments]    ${merchant}    ${outlet}    ${recurring_plan}
    Prepare The Encrypt Message With Recurring Plan    ${merchant}    ${outlet}    ${recurring_plan}
    Post Payment Charge By Credit Card With Recurring Plan    ${merchant}    ${outlet}    ${recurring_plan}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID

Prepare The Encrypt Message
    [Arguments]    ${merchant}    ${outlet}    ${data}
    Fetch O2O Credit Card Publickey    ${merchant}    ${outlet}
    ${request_body} =    To JSON    ${data}
    ${UPDATED_REQUEST_BODY} =   Update Value To Json    ${request_body}    $.publicKey    ${O2O_CREDIT_CARD_PUBLIC_KEY}
    ${request_body_string} =    JSONLibrary.Convert JSON To String    ${UPDATED_REQUEST_BODY}
    Post Encrypt Message With KMS    ${request_body_string}
    Set Gateway Header With Kms Security Header

Prepare The Encrypt Message For Invalid Merchant
    [Arguments]    ${merchant}    ${outlet}    ${data}
    Generate Publickey For Invalid Merchant    ${merchant}    ${outlet}
    ${request_body} =    To JSON    ${data}
    ${UPDATED_REQUEST_BODY} =   Update Value To Json    ${request_body}    $.publicKey    ${O2O_CREDIT_CARD_PUBLIC_KEY}
    ${request_body_string} =    JSONLibrary.Convert JSON To String    ${UPDATED_REQUEST_BODY}
    Post Encrypt Message With KMS    ${request_body_string}
    Set Gateway Header With Kms Security Header

Prepare The Settled Transaction
    Get Payment Transaction List By Merchant Or Admin    trueyouMerchantId.equals=${SCB_MERCHANT_ID}&trueyouOutletId.equals=${SCB_ACTIVE_OUTLET}&status.equals=SETTLED&gatewayType.equals=2C2P&sort=createdDate,desc&size=1
    Response Correct Code    ${SUCCESS_CODE}
    ${transaction_id}=    Get Property Value From Json By Index    .transactionId    0
    ${full_amount}=    Get Property Value From Json By Index    .amount    0
    Set Test Variable    ${TRANSACTION_ID}    ${transaction_id}
    Set Test Variable    ${FULL_AMOUNT}    ${full_amount}

Prepare The Transaction With Select Recurring Type
    [Arguments]    ${merchant}    ${outlet}    ${recurring_type}
    Run Keyword If    '${recurring_type}'=='INTERVAL'    Generate Charge Transaction With Recurring Type Is Interval    ${merchant}    ${outlet}
    Run Keyword If    '${recurring_type}'=='FIXDATE'    Generate Charge Transaction With Recurring Type Is Fixdate    ${merchant}    ${outlet}

Generate Charge Transaction With Recurring Type Is Interval
    [Arguments]    ${merchant}    ${outlet}
    Generate Transaction Reference    22
    Get Date With Format And Increment    %d%m%y%y    1 day
    Prepare The Charge Transaction With Recurring Plan    ${merchant}    ${outlet}    "recurring": {"type": "INTERVAL","interval": {"recurringInterval": 10,"chargeNextDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
    Response Should Contain Property With Value    recurring.type    INTERVAL

Generate Charge Transaction With Recurring Type Is Fixdate
    [Arguments]    ${merchant}    ${outlet}
    Generate Transaction Reference    22
    Get Date With Format And Increment    %d%m    1 day
    Prepare The Charge Transaction With Recurring Plan    ${merchant}    ${outlet}    "recurring": {"type": "FIXDATE","fixDate" : {"chargeOnDate": "${DESIRED_DATE}"},"recurringAmount": "${amount}","recurringCount": "0","accumulateMaxAmount": "${amount}"}
    Response Should Contain Property With Value    recurring.type    FIXDATE

Post Encrypt Message With KMS
    [Arguments]    ${data}
    Create Aws Session
    ${RESP}=    Post Request    aws_session    /encrypt/    data=${data}    headers=&{AWS_HEADER}
    Set Test Variable    ${RESP}
    Fetch Property From Response    .X-o2o-key    O2O_KEY
    Fetch Property From Response    .X-o2o-iv    O2O_IV_KEY
    Fetch Property From Response    .X-o2o-signature    O2O_SIGNATURE
    Fetch Property From Response    .X-o2o-timestamp    O2O_TIMESTAMP

Fetch O2O Credit Card Publickey
    [Arguments]    ${merchant}    ${outlet}
    Get Outlet Payment Infomation    trueyouMerchantId=${merchant}&trueyouOutletId=${outlet}
    Response Correct Code    ${SUCCESS_CODE}
    ${O2O_CREDIT_CARD_PUBLIC_KEY}=    Get Property Value From Json By Index    .o2oCreditCardPublicKey    0
    Set Test Variable   ${O2O_CREDIT_CARD_PUBLIC_KEY}

Get Date With Format And Increment
    [Arguments]    ${result_format}    ${increment}=0
    ${desired_date} =    Get Current Date    result_format=${result_format}    increment=${increment}
    Set Test Variable    ${DESIRED_DATE}    ${desired_date}
    [Return]    ${DESIRED_DATE}

Set Gateway Header For Aws
    &{AWS_HEADER}=    Create Dictionary    Content-Type=application/json    x-api-key=GOlnZFdf9X95rm0gG4Qbd6R3rCOYsaCq2CqtjVHF
    Set Test Variable    &{AWS_HEADER}

Set Gateway Header With Kms Security Header
    &{O2O_KMS_GATEWAY_HEADER}=    Create Dictionary    authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json    X-o2o-key=${O2O_KEY}    X-o2o-iv=${O2O_IV_KEY}    X-o2o-signature=${O2O_SIGNATURE}    X-o2o-timestamp=${O2O_TIMESTAMP}
    Set Test Variable    &{O2O_KMS_GATEWAY_HEADER}

Create Aws Session
    Create Session    aws_session    ${aws_session}    verify=true
    Set Gateway Header For Aws

Generate Publickey For Invalid Merchant
    [Arguments]    ${merchant}    ${outlet}
    Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"${merchant}", "trueyouOutletId":"${outlet}"}
    Response Correct Code    ${SUCCESS_CODE}
    ${O2O_CREDIT_CARD_PUBLIC_KEY}=    Get Property Value From Json By Index    .publicKey    0
    Set Test Variable    ${O2O_CREDIT_CARD_PUBLIC_KEY}
