*** Variables ***
${payment_transaction}    /paymenttransaction/api/transactions

*** Keywords ***
Post Create Payment Transaction
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${payment_transaction}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Data preparation
Generate Transaction Reference
    [Arguments]    ${length}
    ${random_string}=    Generate Random String    ${length}
    Set Suite Variable    ${TRANSACTION_REFERENCE}    ${random_string}

Generate Transaction Date With Format
    [Arguments]    ${increment}    ${format}
    ${current_date_string}=    Get Current Date    time_zone=local    increment=${increment}    result_format=${format}    exclude_millis=False
    Set Test Variable    ${TRANSACTION_DATE}    ${current_date_string}

Prepare Payment Transaction Test Data
    Generate Transaction Reference    255
    Generate Transaction Date With Format    -2 hours    %Y-%m-%dT%H:%M:%S.%fZ

Generate Client Transaction ID
    [Arguments]    ${length}
    ${random_string}=    Generate Random String    ${length}
    ${current_date}=  Get Current Date  result_format=%d%m%Y
    Set Test Variable    ${CLIENT_TRANSACTION_ID}    ${random_string}${current_date}

Generate Raw Payment Money Amount
    ${random_int}=    Generate Random String    1    123456789
    Set Test Variable    ${SATANG_MONEY_AMOUNT}    ${${random_int}000}
    Set Test Variable    ${BATH_MONEY_AMOUNT}    ${${random_int}0}
