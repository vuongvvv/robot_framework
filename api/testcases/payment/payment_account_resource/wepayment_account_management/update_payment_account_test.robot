*** Settings ***
Documentation    Tests to verify that wePayment onboard - update payment account api works correctly

Resource    ../../../../resources/init.robot
Resource    ../../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../../keywords/payment/payment_account_resource/wepayment_account_management_keywords.robot
Resource    ../../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
Test Teardown    Delete All Sessions
#Require Client Scope: payment.payment.actAsAdmin
*** Variables ***
@{validate_message}    projectId length must be less than or equal to 50    shopId length must be less than or equal to 50
${company_name}    Please do not remove automation Merchant tested flow

*** Test Cases ***
TC_O2O_24258
    [Documentation]    Unable to update payment account when request with invalid client scope
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"${company_name}","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_24259
    [Documentation]    Unable to update payment account when payment account id is invalid
    [Tags]    Medium    Regression    payment
    Put Update Payment Account    INVALID
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"${company_name}","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/payment-account/INVALID
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_found
    Response Should Contain Property With Value    errors..message    Payment Account Not Found
    Response Should Not Contain Property    errors..activityId

TC_O2O_24260
    [Documentation]    Able to update projectId when input value not over 50 characters
    [Tags]    Medium    Regression    payment
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"update-pma-0000000000","shopId":"00510","companyName":"${company_name}","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With Value   paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    projectId    update-pma-0000000000
    Response Should Contain Property With Value    shopId    00510
    Response Should Contain Property With Null Value    ownerClientId
    Response Should Contain Property With Value    companyName    ${company_name}
    Response Should Contain Property With Value    platformName    Automation
    Response Should Contain Property With Null Value    o2oPublicKey
    Response Should Contain Property With Null Value    o2oPrivateKey
    Response Should Contain Property With Value    clientCallbackUrl    https://en5eemosh0b12.x.pipedream.net
    Response Should Contain Property With Value    email    payment.automation@ascendcorp.com
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With String Value    omiseAccount
    Response Should Contain Property With Boolean Value    enabled    ${TRUE}
    #Rollback Merchant Information
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   projectId    ${WEPAYMENT_PROJECT_ID}

TC_O2O_24261
    [Documentation]    Able to update shopId when input value not over 50 characters
    [Tags]    Medium    Regression    payment
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"11510","companyName":"${company_name}","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With Value   paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    projectId    ${WEPAYMENT_PROJECT_ID}
    Response Should Contain Property With Value    shopId    11510
    #Rollback Merchant Information
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   shopId    00510

TC_O2O_24262
    [Documentation]    Unable to update payment account  when input projectId and shopId over 50 characters
    [Tags]    Medium    Regression    payment
    Generate Transaction Reference    51
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${TRANSACTION_REFERENCE}","shopId":"${TRANSACTION_REFERENCE}","companyName":"Automation Merchant tested flow","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property Value Include In List    errors..message    ${validate_message}
    Response Should Not Contain Property    errors..activityId

TC_O2O_24263
    [Documentation]    Able to update companyName when input value not over 100 characters
    [Tags]    Medium    Regression    payment
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"ASC automate for update payment account test script","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With Value   paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    companyName    ASC automate for update payment account test script
    #Rollback Merchant Information
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   companyName    Please do not remove automation Merchant tested flow

TC_O2O_24264
    [Documentation]    Able to update platformName when input value not over 100 characters
    [Tags]    Medium    Regression    payment
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"${company_name}","platformName":"UPDATE_PLATFORM_NAME","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With Value   paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    platformName    UPDATE_PLATFORM_NAME
    #Rollback Merchant Information
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   platformName    AUTOMATE-TEST-003

TC_O2O_24265
     [Documentation]    Able to update enable flag
     [Tags]    Medium    Regression    payment
     Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
     ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"${company_name}","platformName":"Automation","enabled":false,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With String Value    createdDate
     Response Should Contain Property With Value   paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
     Response Should Contain Property With Boolean Value    enabled    ${FALSE}
     #Rollback Merchant Information
     Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
     ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Boolean Value   enabled    ${TRUE}

TC_O2O_24267
    [Documentation]    Able to update clientCallbackUrl when  input value not over 100 characters
    [Tags]    Medium    Regression    payment
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"${company_name}","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://gmail.com/","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With Value   paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    clientCallbackUrl    https://gmail.com/
    #Rollback Merchant Information
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   clientCallbackUrl    https://en5eemosh0b12.x.pipedream.net

TC_O2O_24268
    [Documentation]    Able to update email when  input value not over 100 characters
    [Tags]    Medium    Regression    payment
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"${company_name}","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "update.storm.payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With Value   paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    email    update.storm.payment.automation@ascendcorp.com
    #Rollback Merchant Information
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   email    payment.automation@ascendcorp.com

TC_O2O_24269
    [Documentation]    Able to update mobile number when input with valid format
    [Tags]    Medium    Regression    payment
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"${company_name}","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"0873338888"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With Value   paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    mobile    0873338888
    #Rollback Merchant Information
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   mobile    ${TMN_WALLET_MOBILE}

TC_O2O_24270
    [Documentation]    Unable to update mobile number when input value not equal 10 characters
    [Tags]    Medium    Regression    payment
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}
    ...    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"${company_name}","platformName":"Automation","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"023338888"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    mobile Invalid Format: Mobile No. must be in 10 digit
    Response Should Not Contain Property    errors..activityId
