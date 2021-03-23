*** Settings ***
Documentation    Tests to verify that recipient API - add new recipient api works correctly

Resource    ../../../../resources/init.robot
Resource    ../../../../keywords/payment/payment_account_resource/recipient_management_keyword.robot
Resource    ../../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclient_wepayment
Test Teardown    Delete All Sessions
#Require Wepayment Client Scope: payment.recipient.create

*** Test Cases ***
TC_O2O_25122
    [Documentation]    [Create recipients] Not allow to create recipients when request with invalid payment account id
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    INVALID
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/payment-account/INVALID/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_found
    Response Should Contain Property With Value    errors..message    Payment Account Not Found

TC_O2O_25123
    [Documentation]    [Create recipients] Not allow to create recipients when payment account status is inactive
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${INACTIVE_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${INACTIVE_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_active
    Response Should Contain Property With Value    errors..message    Payment Account is inactive

TC_O2O_25124
    [Documentation]    [Create recipients] Not allow to create recipients when omise account status is inactive
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${INACTIVE_OMISE_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    External Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${INACTIVE_OMISE_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_omise_not_active
    Response Should Contain Property With Value    errors..message    Omise Account is inactive

TC_O2O_25125
    [Documentation]    [Create recipients][omise account] Not allow to create recipients when no omise account mapping
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${NO_OMISE_ACCOUNT}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${NO_OMISE_ACCOUNT}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_omise_account_not_found
    Response Should Contain Property With Value    errors..message    Omise Account Not Found

TC_O2O_25126
    [Documentation]    [Create recipients][merchant authority] Not allow to create recipients when no merchant authority
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_no_authority
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_25127
    [Documentation]    [Create recipients][app client scope] Not allow to create recipients when request with invalid client scope
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_25128
    [Documentation]    [Create recipients] Not allow to input name with html tag
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "</br>O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    name The HTML tag are not allowed

TC_O2O_25129
    [Documentation]    [Create recipients] Not allow to input name over 255 charactors
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    256
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "${TRANSACTION_REFERENCE}","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    name length must be less than or equal to 255

TC_O2O_25130
    [Documentation]    [Create recipients] Not allow to input name with empty value
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    name must not be empty

TC_O2O_25131
    [Documentation]    [Create recipients] Not allow to input name with null value
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : null,"email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    name must not be empty

TC_O2O_25132
    [Documentation]    [Create recipients] Allow to input name with special charactor
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "INPUT+name's_with%special@Cha(*)","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    name    INPUT+name's_with%special@Cha(*)
    Response Should Contain Property With Value    email    automation.payment@ascendcorp.com
    Response Should Contain Property With Value    description    CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT
    Response Should Contain Property With Boolean Value    verified    ${FALSE}
    Response Should Contain Property With Boolean Value    active    ${FALSE}
    Fetch Property From Response    .id    O2O_RECIPIPIENT_ID
    #Destroy Recipient From Omise Dashboard
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25133
    [Documentation]    [Create recipients] Allow to input duplicate name
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "AUTOMATE_DUPLICATE_RECIPIENT_TEST","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    name    AUTOMATE_DUPLICATE_RECIPIENT_TEST
    Response Should Contain Property With Value    email    automation.payment@ascendcorp.com
    Response Should Contain Property With Value    description    CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT
    Response Should Contain Property With Boolean Value    verified    ${FALSE}
    Response Should Contain Property With Boolean Value    active    ${FALSE}
    Fetch Property From Response    .id    O2O_RECIPIPIENT_ID
    #Destroy Recipient From Omise Dashboard
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25134
    [Documentation]    [Create recipients] Not allow to input email with html tag
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "RECIPIENT001","email" : "</automation>.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    email is invalid.

TC_O2O_25135
    [Documentation]    [Create recipients] Not allow to input email over 255 characters
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    233
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "RECIPIENT001","email" : "${TRANSACTION_REFERENCE}.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    email length must be less than or equal to 255

TC_O2O_25136
    [Documentation]    [Create recipients] Not allow to input email is invalid pattern
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "RECIPIENT001","email" : "automation.payment@ascendcorp","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    email is invalid.

TC_O2O_25137
    [Documentation]    [Create recipients] Not allow to input email is empty value
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "RECIPIENT001","email" : "","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    email is invalid.

TC_O2O_25138
    [Documentation]    [Create recipients] Allow to create recipients when email is null
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "RECIPIENT001","email" : null,"description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    name    RECIPIENT001
    Response Should Contain Property With Null Value    email
    Response Should Contain Property With Value    description    CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT
    Response Should Contain Property With Boolean Value    verified    ${FALSE}
    Response Should Contain Property With Boolean Value    active    ${FALSE}
    Fetch Property From Response    .id    O2O_RECIPIPIENT_ID
    #Destroy Recipient From Omise Dashboard
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25139
    [Documentation]    [Create recipients] Allow to create recipients when description is null
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : null,"type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    name    RECIPIENT001
    Response Should Contain Property With Value    email    automation.payment@ascendcorp.com
    Response Should Contain Property With Null Value    description
    Response Should Contain Property With Boolean Value    verified    ${FALSE}
    Response Should Contain Property With Boolean Value    active    ${FALSE}
    Fetch Property From Response    .id    O2O_RECIPIPIENT_ID
    #Destroy Recipient From Omise Dashboard
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25140
    [Documentation]    [Create recipients] Not allow to input description with html tag
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT</br>","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    description The HTML tag are not allowed

TC_O2O_25141
    [Documentation]    [Create recipients] Not allow to input description over 255 charactors
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    256
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "${TRANSACTION_REFERENCE}","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    description length must be less than or equal to 255

TC_O2O_25142
    [Documentation]    [Create recipients] Allow to create recipients when input type as Individual
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Individual","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    name    O2O_RECIPIENT001
    Response Should Contain Property With Value    email    automation.payment@ascendcorp.com
    Response Should Contain Property With Value    description    CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT
    Response Should Contain Property With Boolean Value    verified    ${FALSE}
    Response Should Contain Property With Boolean Value    active    ${FALSE}
    Fetch Property From Response    .id    O2O_RECIPIPIENT_ID
    #Destroy Recipient From Omise Dashboard
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25143
    [Documentation]    [Create recipients] Allow to create recipients when input type as Corporation
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    name    O2O_RECIPIENT001
    Response Should Contain Property With Value    email    automation.payment@ascendcorp.com
    Response Should Contain Property With Value    description    CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT
    Response Should Contain Property With Boolean Value    verified    ${FALSE}
    Response Should Contain Property With Boolean Value    active    ${FALSE}
    Fetch Property From Response    .id    O2O_RECIPIPIENT_ID
    #Destroy Recipient From Omise Dashboard
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25144
    [Documentation]    [Create recipients] Not allow to create recipients when input type with lower case
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "individual","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    type is invalid.
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    type is invalid.

TC_O2O_25145
    [Documentation]    [Create recipients] Not allow to input type with null value
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : null,"taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    type must not be empty

TC_O2O_25146
    [Documentation]    [Create recipients] Not allow to input taxId over 255 charactors
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    256
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "${TRANSACTION_REFERENCE}","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    taxId length must be less than or equal to 255

TC_O2O_25147
    [Documentation]    [Create recipients] Not allow to input taxId with html tag
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "0-3283-90011-45-7</br>","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    taxId The HTML tag are not allowed

TC_O2O_25148
    [Documentation]    [Create recipients] Allow to input taxId with null value
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : null,"bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    name    O2O_RECIPIENT001
    Response Should Contain Property With Value    email    automation.payment@ascendcorp.com
    Response Should Contain Property With Value    description    CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT
    Response Should Contain Property With Boolean Value    verified    ${FALSE}
    Response Should Contain Property With Boolean Value    active    ${FALSE}
    Fetch Property From Response    .id    O2O_RECIPIPIENT_ID
    #Destroy Recipient From Omise Dashboard
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25149
    [Documentation]    [Create recipients] Verify response when input invalid bank_account_brand
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "BBB","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    bankAccountBrand is invalid.

TC_O2O_25150
    [Documentation]    [Create recipients] Not support when input bank_account_brand with upper case
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "SCB","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    bankAccountBrand is invalid.

TC_O2O_25151
    [Documentation]    [Create recipients] Not allow to input bank_account_brand with empty value
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    bankAccountBrand must not be empty

TC_O2O_25153
    [Documentation]    [Create recipients] Allow to input bank_account_number with xxxxxxxxx format
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "6629800001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    paymentAccountId    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    name    O2O_RECIPIENT001
    Response Should Contain Property With Value    email    automation.payment@ascendcorp.com
    Response Should Contain Property With Value    description    CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT
    Response Should Contain Property With Boolean Value    verified    ${FALSE}
    Response Should Contain Property With Boolean Value    active    ${FALSE}
    Fetch Property From Response    .id    O2O_RECIPIPIENT_ID
    #Destroy Recipient From Omise Dashboard
    Delete Recipients From Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}    ${O2O_RECIPIPIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_25154
    [Documentation]    [Create recipients] Not allow to input bank_account_number with empty value
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    bankAccountNumber must not be empty

TC_O2O_25155
    [Documentation]    [Create recipients] Not allow to input bank_account_number with null value
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : null,"bank_account_name" : "Payment Automated"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    bankAccountNumber must not be empty

TC_O2O_25156
    [Documentation]    [Create recipients] Not allow to input bank_account_name with empty value
    [Tags]    Medium    Regression    payment
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "O2O_RECIPIENT001","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT" ,"type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : ""}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    bankAccountName must not be empty

TC_O2O_26452
    [Documentation]    [Create recipients][wepayment app_client] Not allow to create recipients when not found app client in wePayment
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_onetime_otp
    Post Create Recipients To Payment Account    ${VALID_PAYMENT_ACCOUNT_ID}
    ...    {"name" : "INPUT+name's_with%special@Cha(*)","email" : "automation.payment@ascendcorp.com","description" : "CAN REMOVE NEW RECIPIENT WAS CREATED FROM AUTOMATION TEST SCRIPT","type" : "Corporation","taxId" : "0-3283-90011-45-7","bank_account_brand" : "scb","bank_account_number" : "662-980-0001","bank_account_name" : "Payment Automated"}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.unauthorized
    Response Should Contain Property With Value    status    ${401}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}/recipient
    Response Should Contain Property With Value    message    error.unauthorized
    Response Should Contain Property With Value    errors..code    0_unauthorized
    Response Should Contain Property With Value    errors..message    unauthorized
