*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/rpp_gateway_common.robot
Resource    ../rpp_payment/rpp_payment_keywords.robot
Resource    ../rpp_payment/payment_edc_offline_keywords.robot
Resource    ../payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../apigee/apigee_payment_keywords.robot

*** Variables ***
${amount}    300
${alipay_success_code_prefix}    acm20001
${TRUE_DIGITAL_CARD}    0610090735
${success_otp_code}    111111
${expire_tmn_token}    eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJtZXJjaGFudC5tZXJjaGFudC53cml0ZSIsInBheW1lbnQuZXNjcm93LmwiLCJwYXltZW50UmF3VHguY3JlYXRlIiwibWVyY2hhbnQub3V0bGV0LnJlYWQiLCJwYXltZW50LnBheW1lbnQucmVhZCIsInBheW1lbnRUeC5jcmVhdGUiLCJtZXJjaGFudC5tZXJjaGFudC5yZWFkIiwic21zLmNyZWF0ZSIsInBheW1lbnQucGF5bWVudC5hY3RBc0FkbWluIiwicGF5bWVudC5wYXltZW50LndyaXRlIiwicGF5bWVudC5lc2Nyb3cuciIsIm1lcmNoYW50LnRlcm1pbmFsLnJlYWQiXSwiZXhwIjoxNTc1MTEyMjY4LCJpYXQiOjE1NzUwMjU4NjgsImp0aSI6ImM0M2IxZWM2LTY4ODMtNDY0Ni04ZDU0LWRhZDYyM2E4YzUxNyIsImNsaWVudF9pZCI6InBheW1lbnQifQ.ms6WuCxJZBzd_Mvx6Ocxfvp6gHG07V3SZVD3v5FmCyQBrztDUBqeq0704qS7xyhTiBA20u0AVImKZJeS8TftbbC4ltkN3B-ydQ4DY-waBc-luAWyr2765AVvkcyDMCpYCCbI-drrjy3ah6Qecha6E0e_uZ4stWqxUTJzh0hJ_5SvcZrmqLNrVbYt-rmgkYhbZZXw15hNG22GPgtOOy-5RVY45cZmZYVtVDD27hveCXBIkbBde1RVV7XpTjtYkSWisAdYIxI23dCmpeTjYs3GaoLoWjAbZ5YNr16XkFfNV447vbBQGohPb5ybTT8LNXoSHYcUBQzbLUMLnAU-oBi0TQ

${invalid_tmn_token}    eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiI2NjYzOTIwMjMyNiIsInNjb3BlIjpbInBheW1lbnQucGF5bWVudC53cml0ZSJdLCJleHAiOjE1NzUzNDcwOTUsImlhdCI6MTU3NTM0Njc5NSwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0ASIiwibWVyY2hhbnRTdWJzY3JpYmVyLm1zZy5hY3RBc0FkbWluIl0sImp0aSI6IjQxM2YzYWVmLTM4OWMtNDJkYS05MTAyLTM0MmU4M2ZhYzViNCIsImNsaWVudF9pZCI6IlRDX08yT18xMzQzNiJ9.oIQdnrmePfsH5vt4xx8kUg8brqfuV7zGwzpGlwDEZDl_sJCKEAaP08N7x9oPYr2OM_iNKnnu29oMGhzQYvuYAe0gaPswuCvFlQh3v6XubMGmDhpp4a4b3DpYT3hPCYbh5KE7rOIBsDLaNl_8djCkO7C0_Sdw-lcZ34SXu7o-l3xgu3DrE5cOqN3aHQm9hkdcnh1PTBOCp90Gm33V4S8rAiSNGaU-3xLS1nXEyC82MGuHOFw11rJmUlbAzcglkGeostsCds5T0SBuzyegyWDjZtMCIGnI-JDZIBC0LtKECWRdliods-8zRpePnI3mR6Ikdb4_UFjnpzItHMzoleZFFg

*** Keywords ***
Post Request Otp Of Truecard
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /edc-app-services/api/v3/payments/otp/request    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Otp Reference Of Truecard
    ${TRUE_CARD_OTP_REF}=    Get Property Value From Json By Index    .otp_ref    0
    Set Test Variable    ${TRUE_CARD_OTP_REF}

Get Authorized Code Of Truecard
    ${TRUE_CARD_AUTH_CODE}=    Get Property Value From Json By Index    .auth_code    0
    Set Test Variable    ${TRUE_CARD_AUTH_CODE}

Get Mobile Number Of Truecard
    ${TRUE_CARD_MOBILE_NO}=    Get Property Value From Json By Index    .mobile    0
    Set Test Variable    ${TRUE_CARD_MOBILE_NO}

Get Access Token of Truecard
    ${TRUE_CARD_TMN_TOKEN}=    Get Property Value From Json By Index    .accessToken    0
    Set Test Variable    ${TRUE_CARD_TMN_TOKEN}

Get True Card Transaction Reference Id
    ${TRUE_CARD_TX_REF}=    Get Property Value From Json By Index    .transaction_reference_id    0
    Set Test Variable    ${TRUE_CARD_TX_REF}

Post Payment Charge By Api Version 3
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /edc-app-services/api/v3/payments/charge/truecard    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Payment Cancel By Api Version 3
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /edc-app-services/api/v3/void    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Trace Id Of Charge By Truecard
    ${TRUE_CARD_TRACE_ID}=    Get Property Value From Json By Index    .trace_id    0
    Set Test Variable    ${TRUE_CARD_TRACE_ID}

Set Gateway Header With Invalid Access Token
    &{GATEWAY_HEADER}=    Create Dictionary    authorization=Bearer ${invalid_tmn_token}     Content-Type=application/json
    Set Test Variable    &{GATEWAY_HEADER}

Set Gateway Header Without Authorization
    &{GATEWAY_HEADER}=    Create Dictionary    Content-Type=application/json
    Set Test Variable    &{GATEWAY_HEADER}

Set Gateway Header With Expired Token
    &{GATEWAY_HEADER}=    Create Dictionary    authorization=Bearer ${expire_tmn_token}    Content-Type=application/json
    Set Test Variable    &{GATEWAY_HEADER}

Post Request Otp By Truecard And Get Reference Information
    [Arguments]    ${truecard_number}
    Post Request Otp Of Truecard    { "truecard": "${truecard_number}" }
    Response Correct Code    ${SUCCESS_CODE}
    Get Otp Reference Of Truecard
    Get Authorized Code Of Truecard
    Get Mobile Number Of Truecard

Post Request Payment Charge By Truecard To Prepare Data Before Cancel
    [Arguments]    ${truecard_number}    ${transaction_channel}
    Post Request Otp By Truecard And Get Reference Information    ${truecard_number}
    Post Payment Charge By Api Version 3    { "brand_id": "${BRAND_ID}", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": ${amount}, "currency": "${TH_CURRENCY}", "mobile": "${TRUE_CARD_MOBILE_NO}", "otp_ref": "${TRUE_CARD_OTP_REF}", "otp_code": "${success_otp_code}", "auth_code": "${TRUE_CARD_AUTH_CODE}", "description": "Prepare data before payment cancel", "transaction_channel": "${transaction_channel}" }
    Response Correct Code    ${SUCCESS_CODE}
    Get Trace Id Of Charge By Truecard

Post Request Payment Charge By Wallet To Prepare Data Before Cancel
    Post Create Edc Payment By Random Code    { "tx_ref_id": "", "brand_id": "${BRAND_ID}", "tmn_merchant_id": "${TMN_MERCHANT_ID} ", "outlet_id": "${BRANCH_ID}", "terminal_id": "${TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "payment_code": "RANDOM_TRUE_MONEY_PAYMENT_CODE", "payment_method" : "WALLET", "description": "Automation Post Request Payment Charge By Wallet To Prepare Data Before Cancel", "client_trx_id": ""}
    Response Correct Code    ${SUCCESS_CODE}
    Get EDC Trace Id

Post Request Payment Charge By Alipay To Prepare Data Before Cancel
    Generate Alipay Barcode    ${alipay_success_code_prefix}
    Post Create EDC Payment    { "tx_ref_id": "", "brand_id": "${ALIPAY_BRAND_ID}", "tmn_merchant_id": "${ALIPAY_TMN_MERHANT_ID} ", "outlet_id": "${ALIPAY_ฺBRANCH_ID}", "terminal_id": "${ALIPAY_TERMINAL_ID}", "amount": "${amount}", "currency": "${TH_CURRENCY}", "payment_code": "${ALIPAY_BARCODE}", "payment_method" : "ALIPAY", "description": "Automation Post Request Payment Charge By Alipay To Prepare Data Before Cancel", "client_trx_id": ""}
    Response Correct Code    ${SUCCESS_CODE}
    Get EDC Trace Id
