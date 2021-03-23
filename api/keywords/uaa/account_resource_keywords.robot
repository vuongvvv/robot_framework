*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/string_common.robot

*** Keywords ***
Get Account
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /uaa/api/account    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Save Account
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/account    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Change Password
    [Arguments]    ${password}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/account/change-password    data=${password}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Finish Password Reset
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/account/reset-password/finish    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Request Password Reset
    [Arguments]    ${mail}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/account/reset-password/init    data=${mail}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Social User Connection
    [Arguments]    ${provider_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /uaa/api/account/social-user-connection    params=providerId=${provider_id}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Activate Account
    [Arguments]    ${key}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /uaa/api/activate    params=key=${key}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Is Authenticated
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /uaa/api/authenticate    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Request Change Mobile Phone
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/account/change-mobile/sms-otp    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Verify Otp For Change Mobile Phone
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/account/change-mobile/sms-otp/validation    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Link Account
    [Arguments]    ${provider_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /uaa/api/account/identity-providers/${provider_id}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Fetch Reference And Transaction Id From Egg Digital
    ${TEST_DATA_REFERENCE_ID_FROM_EGG_DIGITAL}=    Get Property Value From Json By Index    reference    0
    ${TEST_DATA_TRANSACTION_ID_FROM_EGG_DIGITAL}=    Get Property Value From Json By Index    transactionId    0
    Set Test Variable    ${TEST_DATA_REFERENCE_ID_FROM_EGG_DIGITAL}
    Set Test Variable    ${TEST_DATA_TRANSACTION_ID_FROM_EGG_DIGITAL}

Generate Not Existing Phone Number On Uaa
    ${random_numbers}=    Get Random Strings    9    [NUMBERS]
    Set Test Variable    ${TEST_DATA_NOT_EXISTING_PHONE_NUMBER_ON_UAA}    66${random_numbers}

Format Mobile Number As Thai Format
    [Arguments]    ${mobile_number}
    ${TEST_DATA_MOBILE_NUMBER_AS_66_FORMAT}=    Format Mobile Number    ${mobile_number}
    Set Test Variable    ${TEST_DATA_MOBILE_NUMBER_AS_66_FORMAT}