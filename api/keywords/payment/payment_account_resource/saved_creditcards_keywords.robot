*** Settings ***
Resource    ../../payment/credit_card_resource/creditcard_charge_by_payment_account_keywords.robot
#Reference Document: https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1567326231/Omise+-+Credit+Card

*** Keywords ***
Get Saved Credit Cards
    [Arguments]    ${payment_account_id}    ${client_username}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /payment/api/v1/payment-account/${payment_account_id}/wp-cards    params=clientUsername=${client_username}&gateway=OMISE    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Saved Credit Cards
    [Arguments]    ${payment_account_id}    ${wp_card_id}
    ${RESP}=      Delete Request     ${GATEWAY_SESSION}    /payment/api/v1/payment-account/${payment_account_id}/wp-cards/${wp_card_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#DATA PREPARATION
Remove Existing Saved Credit Cards Before Executing Test
    [Arguments]    ${payment_account_id}    ${client_username}    ${loop}=3
    FOR    ${index}    IN RANGE    0    ${loop}
        Get Saved Credit Cards    ${payment_account_id}    ${client_username}
        Response Correct Code    ${SUCCESS_CODE}
        Run Keyword And Ignore Error    Run Keywords    Fetch Property From Response    .cards..wpCardId    WP_CARD_ID    AND    Delete Saved Credit Cards    ${payment_account_id}    ${WP_CARD_ID}
    END

Prepare Wpcard Id
    [Arguments]    ${credit_card}=4111111111111111    ${payment_account_id}=${VALID_PAYMENT_ACCOUNT_ID}    ${client_username}=PREPARE_AUTOMATE
    #Prepare Step
    Remove Existing Saved Credit Cards Before Executing Test    ${payment_account_id}    ${client_username}
    Generate Transaction Reference    ${external_ref_id_length}
    Generate Omise Payment Token    ${credit_card}
    Prepare Encryption Message Before Charge With Omise Gateway
    ...    "paymentAccountId": "${payment_account_id}","clientRefId": "PREPARE-${TRANSACTION_REFERENCE}","manualCapture": false,"rememberCard": true,"clientUsername": "${client_username}","email": "payment.automation@ascendcorp.com","amount": "${amount}","currency": "${TH_CURRENCY}","oCardId": "${OMISE_CREDITCARD_ID}"
    Post Payment Charge With Credit Card By Payment Account    {${REQUEST_MESSAGE},"cardToken": "${OMISE_PAYMENT_TOKEN}","oCardId": "${OMISE_CREDITCARD_ID}"}
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Property From Response    .wpCardId    WP_CARD_ID
