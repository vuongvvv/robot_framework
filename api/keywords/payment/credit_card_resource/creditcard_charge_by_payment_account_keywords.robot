*** Variables ***
${amount}    220
${omise_valid_visa_card}    4111111111111111
${omise_valid_master_card}    5555555555554444
${insufficient_fund_visa_card}    4111111111140011
${enrollment_fail_jcb_card}    3530111111100002
${payment_rejected_jcb_card}    3530111111160014
${payment_rejected_3ds_visa_card}    4111111111150002
${payment_rejected_3ds_master_card}    5555551111120002
${aws_session_url}    https://37ukq4mk70.execute-api.ap-southeast-1.amazonaws.com
${omise_generate_payment_ticket_url}    https://vault.omise.co
${returnUrl}    https://enais36npgxlo.x.pipedream.net

*** Keywords ***
Set Gateway Header With Kms Security Header For Wepayment
    &{WEPAYMENT_GATEWAY_HEADER}=    Create Dictionary    authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json    X-o2o-key=${O2O_KEY}    X-o2o-iv=${O2O_IV_KEY}    X-o2o-signature=${O2O_SIGNATURE}    X-o2o-timestamp=${O2O_TIMESTAMP}
    Set Test Variable    &{WEPAYMENT_GATEWAY_HEADER}

Post Payment Charge With Credit Card By Payment Account
    [Arguments]    ${data}
    Set Gateway Header With Kms Security Header For Wepayment
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /payment/api/v1/credit-card/charge    data=${data}    headers=&{WEPAYMENT_GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Generate Omise Payment Ticket
Generate Omise Payment Token
    [Arguments]    ${card_number}    ${input_omise_publickey}=${OMISE_PUBLIC_KEY}
    Set Test Variable    ${OMISE_PUBLIC_KEY}    ${input_omise_publickey}
    Create Omise Session
    &{data}=    Create Dictionary    card[name]=JOHN DOE    card[city]=Bangkok    card[postal_code]=10320    card[number]=${card_number}    card[security_code]=123    card[expiration_month]=7    card[expiration_year]=2022
    ${RESP}=    Post Request    omise_session    /tokens    data=&{data}    headers=&{OMISE_HEADER}
    Set Test Variable    ${RESP}
    Fetch Property From Response    .id    OMISE_PAYMENT_TOKEN
    Fetch Property From Response    .card.id    OMISE_CREDITCARD_ID

Create Omise Session
    Create Session    omise_session    ${omise_generate_payment_ticket_url}    verify=true
    Set Gateway Header For Omise

Set Gateway Header For Omise
    ${authorization_key}=    Generate Authorization Key    ${OMISE_PUBLIC_KEY}    ${EMPTY}
    &{OMISE_HEADER}=    Create Dictionary    Authorization=Basic ${authorization_key}    Content-Type=application/x-www-form-urlencoded
    Set Test Variable    &{OMISE_HEADER}

#KMS Encryption
Post Encrypt Message With KMS For Omise
    [Arguments]    ${data}
    Create Aws Session For Omise
    ${RESP}=    Post Request    aws_session    /encrypt/    data=${data}    headers=&{AWS_HEADER}
    Set Test Variable    ${RESP}
    Fetch Property From Response    .X-o2o-key    O2O_KEY
    Fetch Property From Response    .X-o2o-iv    O2O_IV_KEY
    Fetch Property From Response    .X-o2o-signature    O2O_SIGNATURE
    Fetch Property From Response    .X-o2o-timestamp    O2O_TIMESTAMP

Create Aws Session For Omise
    Create Session    aws_session    ${aws_session_url}    verify=true
    Set Gateway Header For Aws Omise

Set Gateway Header For Aws Omise
    &{AWS_HEADER}=    Create Dictionary    Content-Type=application/json    x-api-key=GOlnZFdf9X95rm0gG4Qbd6R3rCOYsaCq2CqtjVHF
    Set Test Variable    &{AWS_HEADER}

# Data Preparation
Prepare Encryption Message Before Charge With Omise Gateway
    [Arguments]   ${request_message}
    Post Encrypt Message With KMS For Omise
    ...    {"version": "2","publicKey": "${CLIENT_WEPAYMENT_O2O_PUBLICKEY}",${request_message},"cardToken": "${OMISE_PAYMENT_TOKEN}"}
    Set Test Variable    ${REQUEST_MESSAGE}    ${request_message}
