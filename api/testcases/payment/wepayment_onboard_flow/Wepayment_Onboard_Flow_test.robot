*** Settings ***
Documentation    Tests to verify that wePayment onboard flow api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/payment_account_resource/wepayment_account_management_keywords.robot
Resource    ../../../keywords/webhook/event_config_resource_keyword.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
Test Teardown    Run Keywords    Delete Even Configs By Id    ${WEPAYMENT_PROJECT_ID}    ${WEBHOOK_CONFIG_ID}    AND    Delete All Sessions
#Require Client Scope: payment.payment.actAsAdmin

*** Variables ***
@{validate_scope}    payment.creditCard.capture    payment.creditCard.charge    payment.creditCard.delete
${platform_name}    AUTOMATE

*** Test Cases ***
TC_O2O_24342
    [Documentation]    [Omsie] Able to onboarding New wePayment account successful
    #Note! Not require to execute via Pipline due to No API to remove payment account from our database.
    [Tags]    ExcludeHigh    Regression    ExcludeE2E
    #Step1. Create payment account
    Post Create Payment Account    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Can Remove create payment account by automate test script","platformName":"${platform_name}","enabled":false,"clientCallbackUrl":"https://en61zvygrqni8.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}","ip": null}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    paymentAccountId
    Response Should Contain Property With Value    projectId    ${WEPAYMENT_PROJECT_ID}
    Response Should Contain Property With Value    companyName    Can Remove create payment account by automate test script
    Response Should Contain Property With Null Value    omiseAccount
    Response Should Contain Property With Value    status    WAITING_TO_APPROVE
    Response Should Contain Property With Boolean Value    enabled    ${FALSE}
    Fetch Property From Response    .paymentAccountId    PAYMENT_ACCOUNT_ID
    #Step1.1 Verify Webhook Config should be created
    Get All Even Configs    ${WEPAYMENT_PROJECT_ID}    key.equals=${PAYMENT_ACCOUNT_ID}&event.equals=WEPAYMENT
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .id
    Fetch Webhook Config Id
    Response Should Contain Property With Value    .key    ${PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    .event    WEPAYMENT
    Response Should Contain Property With Value    .endpoint    https://en61zvygrqni8.x.pipedream.net
    Response Should Contain Property With Value    .app    payment
    Response Should Contain Property With Value    .failedEndpoint    ${WE_PLATFORM_HOST}/bifrost/api/webhook/projects/${WEPAYMENT_PROJECT_ID}/webhook-recoveries
    Response Should Contain Property With Value    .maxRetryTime    ${5}
    Response Should Contain Property With Value    .intervalRetryTime    ${10}
    Response Should Contain Property With Value    .headers.Content-Type    application/json
    #Step2. Create Omise account
    Post Create Omise Account    ${PAYMENT_ACCOUNT_ID}    {"additionalRate": "1.8999234","additionalRateDesc": "Create By Automation","categoryId": "${CATEGORY_ID}","enabled": false,"paymentAccountStatus": "REJECTED","topUpRate": "1","tmnTopUpRate": "0"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    omiseAccountId
    Response Should Contain Property With Value    topUpRate    ${1}
    Response Should Contain Property With Value    additionalRate    ${1.8999234}
    Response Should Contain Property With Value    additionalRateDesc    Create By Automation
    Response Should Contain Property With Value    categoryId    ${CATEGORY_ID}
    Response Should Contain Property With String Value    omiseAscendWallet.categoryName
    Response Should Contain Property With String Value    omiseAscendWallet.merchantDiscountRate
    Response Should Contain Property With String Value    omiseAscendWallet.omisePublicKey
    Response Should Contain Property With String Value    omiseAscendWallet.tmnMdr
    Response Should Contain Property With Value    tmnTopUpRate    ${0}
    Response Should Contain Property With Boolean    settledByOmiseFlag
    Response Should Contain Property With Boolean Value    enabled    ${FALSE}
    Fetch Property From Response    .omiseAccountId    OMISE_ACCOUNT_ID
    #Step2.1 Create Omise account should mapped with payment account correctly
    Get Payment Account By Id    ${PAYMENT_ACCOUNT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    paymentAccount.paymentAccountId    ${PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    paymentAccount.projectId    ${WEPAYMENT_PROJECT_ID}
    Response Should Contain Property With Value    paymentAccount.shopId    00510
    Response Should Contain Property With Value    paymentAccount.companyName    Can Remove create payment account by automate test script
    Response Should Contain Property With Value    paymentAccount.platformName    ${platform_name}
    Response Should Contain Property With Value    paymentAccount.clientCallbackUrl    https://en61zvygrqni8.x.pipedream.net
    Response Should Contain Property With Value    paymentAccount.email    payment.automation@ascendcorp.com
    Response Should Contain Property With Value    paymentAccount.mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    paymentAccount.omiseAccount.omiseAccountId    ${OMISE_ACCOUNT_ID}
    Response Should Contain Property With Value    paymentAccount.omiseAccount.categoryId    ${CATEGORY_ID}
    Response Should Contain Property With Value    paymentAccount.omiseAccount.topUpRate    ${1}
    Response Should Contain Property With Value    paymentAccount.omiseAccount.additionalRate    ${1.8999234}
    Response Should Contain Property With Value    paymentAccount.omiseAccount.additionalRateDesc    Create By Automation
    Response Should Contain Property With Boolean    paymentAccount.omiseAccount.settledByOmiseFlag
    Response Should Contain Property With Value    paymentAccount.omiseAccount.tmnTopUpRate    ${0}
    Response Should Contain Property With Value    paymentAccount.omiseAccount.additionalRate    ${1.8999234}
    Response Should Contain Property With Boolean Value    paymentAccount.omiseAccount.enabled    ${FALSE}
    Response Should Contain Property With Value    paymentAccount.status    WAITING_TO_APPROVE
    # Step3. Create App client
    Post Create App Client    {"clientId": "robotautomationclientpayment_omise","clientDesc": "Client For Automation Scripts"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/payment-account/app-client
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_duplicate_app_client
    Response Should Contain Property With Value    errors..message    Client is duplicate
    #Step4. Manage access management control
    Post Manage Authority    {"paymentAccountId": "${PAYMENT_ACCOUNT_ID}","clientId": "robotautomationclientpayment_omise","actions": ["payment.creditCard.capture","payment.creditCard.charge","payment.creditCard.delete"]}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    paymentAccountId    ${PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    clientId    robotautomationclientpayment_omise
    Response Should Contain Property With Null Value    username
    Response Should Contain Property Value Is List    actions    ${validate_scope}
    #Step5. rollback client scope
    Post Manage Authority    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientId": "robotautomationclientpayment_omise","actions": ["invalid.scope"]}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_24343
    [Documentation]    [Omsie] Able to onboarding Existing wePayment account successful
    [Tags]    High    Regression    E2E    Payment
    # Step1. Verify existing payment account
    Get Payment Account By Id    ${PID_FOR_ACCESS_CONTROL}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    paymentAccount.paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    paymentAccount.projectId    ${WEPAYMENT_PROJECT_ID}
    Response Should Contain Property With Value    paymentAccount.shopId    00510
    Response Should Contain Property With Value    paymentAccount.companyName    Please do not remove automation Merchant tested flow
    Response Should Contain Property With Value    paymentAccount.platformName    AUTOMATE-TEST-003
    Response Should Contain Property With Value    paymentAccount.status    APPROVED
    #Step1.1 Update existing payment account
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}","ip": "192.168.0.0"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    ip    192.168.0.0
    #Step1.2 Verify Webhook Config should be created
    Get All Even Configs    ${WEPAYMENT_PROJECT_ID}    key.equals=${PID_FOR_ACCESS_CONTROL}&event.equals=WEPAYMENT
    Response Correct Code    ${SUCCESS_CODE}
    Fetch Webhook Config Id
    Response Should Contain Property With String Value    .id
    Response Should Contain Property With Value    .key    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    .event    WEPAYMENT
    Response Should Contain Property With Value    .endpoint    https://en5eemosh0b12.x.pipedream.net
    Response Should Contain Property With Value    .app    payment
    Response Should Contain Property With Value    .failedEndpoint    ${WE_PLATFORM_HOST}/bifrost/api/webhook/projects/${WEPAYMENT_PROJECT_ID}/webhook-recoveries
    Response Should Contain Property With Value    .maxRetryTime    ${5}
    Response Should Contain Property With Value    .intervalRetryTime    ${10}
    Response Should Contain Property With Value    .headers.Content-Type    application/json
    #Step2. Verify existing Omise account
    Get Omise Account    ${PID_FOR_ACCESS_CONTROL}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    omiseAccountId
    Response Should Contain Property With Value    topUpRate    ${1}
    Response Should Contain Property With Value    additionalRate    ${1.8999234}
    Response Should Contain Property With Value    additionalRateDesc    Create By Automation
    Response Should Contain Property With Value    categoryId    ${CATEGORY_ID}
    Response Should Contain Property With String Value    omiseAscendWallet.categoryName
    Response Should Contain Property With String Value    omiseAscendWallet.merchantDiscountRate
    Response Should Contain Property With String Value    omiseAscendWallet.omisePublicKey
    Response Should Contain Property With String Value    omiseAscendWallet.tmnMdr
    Response Should Contain Property With Value    tmnTopUpRate    ${0}
    Response Should Contain Property With Boolean    settledByOmiseFlag
    Response Should Contain Property With Boolean    enabled
    #Step3. Verify Get List All App client should be worked
    Get List All App Client
    Response Correct Code    ${SUCCESS_CODE}
    #Step3.1 Verify Update App client should be worked
    Put Update App Client    robotautomationclientpayment_omise    {"clientId": "robotautomationclientpayment_omise","clientDesc": "update"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    clientId    robotautomationclientpayment_omise
    Response Should Contain Property With Value    clientDesc    update
    Response Should Contain Property With String Value    o2oPublicKey
    Fetch Property From Response    .id    APP_CLIENT_ID
    #Step4. Manage access management control
    Post Manage Authority    {"paymentAccountId": "${PID_FOR_ACCESS_CONTROL}","clientId": "robotautomationclientpayment_omise","actions": ["payment.creditCard.capture","payment.creditCard.charge","payment.creditCard.delete"]}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    paymentAccountId    ${PID_FOR_ACCESS_CONTROL}
    Response Should Contain Property With Value    clientId    robotautomationclientpayment_omise
    Response Should Contain Property With Null Value    username
    Response Should Contain Property Value Is List    actions    ${validate_scope}
    #Step4.1 Verify Client authority
    Get Access Management Authority    ${PID_FOR_ACCESS_CONTROL}    ${APP_CLIENT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .id
    Response Should Contain Property With Value    .projectId    ${WEPAYMENT_PROJECT_ID}
    Response Should Contain Property With Value    .description    Policy for paymentAccountId:${PID_FOR_ACCESS_CONTROL}, clientId:robotautomationclientpayment_omise
    #Step5. rollback client scope
    Put Update Payment Account    ${PID_FOR_ACCESS_CONTROL}    {"projectId":"${WEPAYMENT_PROJECT_ID}","shopId":"00510","companyName":"Please do not remove automation Merchant tested flow","platformName":"AUTOMATE-TEST-003","enabled":true,"clientCallbackUrl":"https://en5eemosh0b12.x.pipedream.net","email": "payment.automation@ascendcorp.com","mobile":"${TMN_WALLET_MOBILE}","ip": null}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Null Value    ip  
    Post Manage Authority    {"paymentAccountId": "${VALID_PAYMENT_ACCOUNT_ID}","clientId": "robotautomationclientpayment_omise","actions": ["invalid.scope"]}
    Response Correct Code    ${SUCCESS_CODE}
    Put Update App Client    robotautomationclientpayment_omise    {"clientId": "robotautomationclientpayment_omise","clientDesc": "payment account for automate please do not remove"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    id
    Response Should Contain Property With Value    clientId    robotautomationclientpayment_omise
    Response Should Contain Property With Value    clientDesc    payment account for automate please do not remove
    Response Should Contain Property With String Value    o2oPublicKey
