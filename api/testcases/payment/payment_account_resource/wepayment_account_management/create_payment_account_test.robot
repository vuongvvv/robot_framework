*** Settings ***
Documentation    Tests to verify that wePayment onboard - crate payment account api works correctly

Resource    ../../../../resources/init.robot
Resource    ../../../../keywords/payment/payment_account_resource/wepayment_account_management_keywords.robot
Resource    ../../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
Test Teardown    Delete All Sessions
#Require Client Scope: payment.payment.actAsAdmin
*** Variables ***
${project_id}    create-pma-0000000000
${company_name}    Can Remove create payment account by automate test script
${platform_name}    AUTOMATE
${client_callback_url}    https://en5eemosh0b12.x.pipedream.net
${email}    payment.automation@ascendcorp.com

*** Test Cases ***
TC_O2O_24230
    [Documentation]    Unable to create payment account when request with invalid client scope
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
    Post Create Payment Account
    ...    {"projectId":"${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/payment-account
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_24231
    [Documentation]    Verify response when projectId is empty
    [Tags]    Medium    Regression    payment
    Post Create Payment Account
    ...    {"projectId":"","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    paymentAccountId
    Response Should Contain Property With Empty Value    projectId
    Response Should Contain Property With Value    shopId    00000
    Response Should Contain Property With Null Value    ownerClientId
    Response Should Contain Property With Value    companyName    ${company_name}
    Response Should Contain Property With Value    platformName    ${platform_name}
    Response Should Contain Property With Null Value    o2oPublicKey
    Response Should Contain Property With Null Value    o2oPrivateKey
    Response Should Contain Property With Value    clientCallbackUrl    ${client_callback_url}
    Response Should Contain Property With Value    email    ${email}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Null Value    omiseAccount
    Response Should Contain Property With Empty Value    appClients
    Response Should Contain Property With Empty Value    recipients
    Response Should Contain Property With Empty Value    subscriptions
    Response Should Contain Property With Value    status    WAITING_TO_APPROVE
    Response Should Contain Property With Value    ip    192.168.0.0.1
    Response Should Contain Property With Boolean Value    enabled    ${FALSE}

TC_O2O_24232
    [Documentation]    Verify response when projectId is null
    [Tags]    Medium    Regression    payment
    Post Create Payment Account
    ...    {"projectId": null,"shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": null}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Null Value    projectId
    Response Should Contain Property With Null Value    omiseAccount
    Response Should Contain Property With Boolean Value    enabled    ${FALSE}
    Response Should Contain Property With Null Value    ip

TC_O2O_24234
    [Documentation]    Verify response when input projectId over 50 characters
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    51
    Post Create Payment Account
    ...    {"projectId": "${TRANSACTION_REFERENCE}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": null}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    projectId length must be less than or equal to 50
    Response Should Not Contain Property    errors..activityId

TC_O2O_24235
    [Documentation]    Verify response when input projectId with special characters
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    10
    Post Create Payment Account
    ...    {"projectId": "A's ${TRANSACTION_REFERENCE}+%","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    projectId    A's ${TRANSACTION_REFERENCE}+%
    Response Should Contain Property With Null Value    omiseAccount

TC_O2O_24236
    [Documentation]    Verify response when shopId is empty
    [Tags]    Medium    Regression    payment
    Post Create Payment Account
    ...    {"projectId":"${project_id}","shopId":"","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    shopId
    Response Should Contain Property With Null Value    omiseAccount

TC_O2O_24237
    [Documentation]    Verify response when shopId is null
    [Tags]    Medium    Regression    payment
    Post Create Payment Account
    ...    {"projectId":"${project_id}","shopId":null,"companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Null Value    shopId
    Response Should Contain Property With Null Value    omiseAccount

TC_O2O_24239
    [Documentation]    Verify response when input shopId over 50 characters
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    51
    Post Create Payment Account
    ...    {"projectId": "${project_id}","shopId":"${TRANSACTION_REFERENCE}","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    shopId length must be less than or equal to 50
    Response Should Not Contain Property    errors..activityId

TC_O2O_24240
    [Documentation]    Verify response when no companyName in request body
    [Tags]    Medium    Regression    payment
    Post Create Payment Account
    ...    {"projectId":"${project_id}","shopId":"00000","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Null Value    companyName
    Response Should Contain Property With Null Value    omiseAccount

TC_O2O_24241
    [Documentation]    Verify response when input companyName over 100 characters
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    101
    Post Create Payment Account
    ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${TRANSACTION_REFERENCE}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    companyName length must be less than or equal to 100
    Response Should Not Contain Property    errors..activityId

TC_O2O_24242
    [Documentation]    Verify response when input companyName with special characters
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    10
    Post Create Payment Account
    ...    {"projectId": "${project_id}","shopId":"00000","companyName":"ASC's ${TRANSACTION_REFERENCE}+%","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    companyName    ASC's ${TRANSACTION_REFERENCE}+%
    Response Should Contain Property With Null Value    omiseAccount

TC_O2O_24243
     [Documentation]    Verify response when no platformName in request body
     [Tags]    Medium    Regression    payment
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    companyName    ${company_name}
     Response Should Contain Property With Null Value    platformName

TC_O2O_24244
     [Documentation]    Verify response when input platformName over 100 characters
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    101
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${TRANSACTION_REFERENCE}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/payment-account
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    platformName length must be less than or equal to 100
     Response Should Not Contain Property    errors..activityId

TC_O2O_24245
     [Documentation]    Verify response when input platformName with special characters
     [Tags]    Medium    Regression    payment
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"Link'd%","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    companyName    ${company_name}
     Response Should Contain Property With Value    platformName    Link'd%

TC_O2O_24246
     [Documentation]    Verify response when no enabled flag in request body
     [Tags]    Medium    Regression    payment
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Boolean Value    enabled    ${TRUE}

TC_O2O_24247
     [Documentation]    Verify response when no clientCallbackUrl in request body
     [Tags]    Medium    Regression    payment
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Null Value    clientCallbackUrl

TC_O2O_24248
     [Documentation]    Verify response when clientCallbackUrl over 100 characters
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    101
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${TRANSACTION_REFERENCE}","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/payment-account
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    clientCallbackUrl length must be less than or equal to 100
     Response Should Not Contain Property    errors..activityId

TC_O2O_24249
     [Documentation]    Verify response when clientCallbackUrl is empty
     [Tags]    Medium    Regression    payment
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"","email": "${email}","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Empty Value    clientCallbackUrl

TC_O2O_24250
     [Documentation]    Verify response when input email with invalid format
     [Tags]    Medium    Regression    payment
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "payment.automation@ascendcorp","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/payment-account
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    email is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_24251
     [Documentation]    Verify response when input email over 100 characters
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    91
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${TRANSACTION_REFERENCE}@gmail.com","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/payment-account
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    email length must be less than or equal to 100
     Response Should Not Contain Property    errors..activityId

TC_O2O_24252
     [Documentation]    Verify response when email is null
     [Tags]    Medium    Regression    payment
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": null,"mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Null Value    email

TC_O2O_24253
     [Documentation]    Verify response when email is empty
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    91
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0.1"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/payment-account
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    email is invalid.
     Response Should Not Contain Property    errors..activityId

TC_O2O_24254
     [Documentation]    Verify response when input mobile start with 66xxx
     [Tags]    Medium    Regression    payment
     #total mobile digit !> 10
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"6610090735","ip": "192.168.0.0.1"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value    mobile    6610090735

TC_O2O_24256
     [Documentation]    Verify response when input mobile with string value
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    91
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"02-0139273 ext.163-164","ip": "192.168.0.0.1"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/payment-account
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    mobile Invalid Format: Mobile No. must be in 10 digit
     Response Should Not Contain Property    errors..activityId

TC_O2O_24257
     [Documentation]    Verify response when input mobile number over 10 characters
     [Tags]    Medium    Regression    payment
     Generate Transaction Reference    91
     Post Create Payment Account
     ...    {"projectId": "${project_id}","shopId":"00000","companyName":"${company_name}","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"${client_callback_url}","email": "${email}","mobile":"66810090735","ip": "192.168.0.0.1"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    ${API_HOST}/payment
     Response Should Contain Property With Value    title    Method argument not valid
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    path    /api/v1/payment-account
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    errors..code    0_request_validation
     Response Should Contain Property With Value    errors..message    mobile Invalid Format: Mobile No. must be in 10 digit
     Response Should Not Contain Property    errors..activityId
