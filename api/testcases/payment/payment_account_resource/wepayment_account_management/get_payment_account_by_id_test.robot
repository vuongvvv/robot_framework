*** Settings ***
Documentation    Tests to verify that wePayment onboard - get payment account by id api works correctly

Resource    ../../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../../resources/init.robot
Resource    ../../../../keywords/payment/payment_account_resource/wepayment_account_management_keywords.robot
Resource    ../../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_admin
Test Teardown    Delete All Sessions
#Require Client Scope: payment.payment.actAsAdmin

*** Test Cases ***
TC_O2O_24271
    [Documentation]    [query by Id] Unable to query payment account when request with invalid client scope
    [Tags]    Medium    Regression    payment
    [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}    grant_type=client_credentials    client_id_and_secret=robotautomationclientpayment_creditcard
    Get Payment Account By Id    ${VALID_PAYMENT_ACCOUNT_ID}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    payment.internal.forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    path    /api/v1/payment-account/${VALID_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    message    error.forbidden
    Response Should Contain Property With Value    errors..code    0_access_is_denied
    Response Should Contain Property With Value    errors..message    Access is denied

TC_O2O_24272
    [Documentation]    Verify response when query with invalid payment account id
    [Tags]    Medium    Regression    Smoke    payment
    Get Payment Account By Id    INVALID
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Internal Bad Request
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    path    /api/v1/payment-account/INVALID
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_payment_account_not_found
    Response Should Contain Property With Value    errors..message    Payment Account Not Found
    Response Should Not Contain Property    errors..activityId

TC_O2O_24273
    [Documentation]    Able to query with valid payment account id case omise account is null
    [Tags]    Medium    Regression    Smoke    payment
    Get Payment Account By Id    ${NO_OMISE_ACCOUNT}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    paymentAccount.createdDate
    Response Should Contain Property With Value    paymentAccount.paymentAccountId    ${NO_OMISE_ACCOUNT}
    Response Should Contain Property With Value    paymentAccount.projectId    ${WEPAYMENT_PROJECT_ID}
    Response Should Contain Property With Value    paymentAccount.shopId    00610
    Response Should Contain Property With Null Value    paymentAccount.ownerClientId
    Response Should Contain Property With Value    paymentAccount.companyName    Please do not remove automation Merchant Case No Omise Mapping
    Response Should Contain Property With Value    paymentAccount.platformName    AUTOMATE-TEST-001
    Response Should Contain Property With Null Value    paymentAccount.o2oPublicKey
    Response Should Contain Property With Null Value    paymentAccount.o2oPrivateKey
    Response Should Contain Property With Value    paymentAccount.clientCallbackUrl    https://en5eemosh0b12.x.pipedream.net
    Response Should Contain Property With Value    paymentAccount.email    payment.automation@ascendcorp.com
    Response Should Contain Property With Value    paymentAccount.mobile    0610090735
    Response Should Contain Property With Null Value    paymentAccount.omiseAccount
    Response Should Contain Property With Empty Value    paymentAccount.appClients
    Response Should Contain Property With Null Value    paymentAccount.recipients
    Response Should Contain Property With Null Value    paymentAccount.subscriptions
    Response Should Contain Property With Value    paymentAccount.status    APPROVED
    Response Should Contain Property With Null Value    paymentAccount.ip
    Response Should Contain Property With Boolean Value    paymentAccount.enabled    ${true}
    Response Should Contain Property With Null Value    omiseAscendWallet

TC_O2O_24274
    [Documentation]    Able to query with valid payment account id case omise account is already mapped
    [Tags]    Medium    Regression    Smoke    payment
    Get Payment Account By Id    ${INACTIVE_PAYMENT_ACCOUNT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    paymentAccount.createdDate
    Response Should Contain Property With Value    paymentAccount.paymentAccountId    ${INACTIVE_PAYMENT_ACCOUNT_ID}
    Response Should Contain Property With Value    paymentAccount.projectId    ${WEPAYMENT_PROJECT_ID}
    Response Should Contain Property With Value    paymentAccount.shopId    00511
    Response Should Contain Property With Null Value    paymentAccount.ownerClientId
    Response Should Contain Property With Value    paymentAccount.companyName    Please do not remove automation Merchant tested flow
    Response Should Contain Property With Value    paymentAccount.platformName    AUTOMATE-INACTIVE-001
    Response Should Contain Property With Null Value    paymentAccount.o2oPublicKey
    Response Should Contain Property With Null Value    paymentAccount.o2oPrivateKey
    Response Should Contain Property With Value    paymentAccount.clientCallbackUrl    https://en5eemosh0b12.x.pipedream.net
    Response Should Contain Property With Value    paymentAccount.email    payment.automation@ascendcorp.com
    Response Should Contain Property With Value    paymentAccount.mobile    0610090735
    Response Should Contain Property With String Value    paymentAccount.omiseAccount.createdDate
    Response Should Contain Property With String Value    paymentAccount.omiseAccount.omiseAccountId
    Response Should Contain Property With Null Value    paymentAccount.omiseAccount.email
    Response Should Contain Property With Null Value    paymentAccount.omiseAccount.omisePublicKey
    Response Should Contain Property With Null Value    paymentAccount.omiseAccount.omiseSecretKey
    Response Should Contain Property With Null Value    paymentAccount.omiseAccount.clientRedirectUrl
    Response Should Contain Property With Null Value    paymentAccount.omiseAccount.ascendFeeRate
    Response Should Contain Property With Null Value    paymentAccount.omiseAccount.omiseFeeRate
    Response Should Contain Property With Value    paymentAccount.omiseAccount.categoryId    ${CATEGORY_ID}
    Response Should Contain Property With String Value    paymentAccount.omiseAccount.topUpRate
    Response Should Contain Property With String Value    paymentAccount.omiseAccount.additionalRate
    Response Should Contain Property With String Value    paymentAccount.omiseAccount.additionalRateDesc
    Response Should Contain Property With Boolean Value    paymentAccount.omiseAccount.settledByOmiseFlag    ${FALSE}
    Response Should Contain Property With String Value    paymentAccount.omiseAccount.tmnTopUpRate
    Response Should Contain Property With Boolean Value    paymentAccount.omiseAccount.enabled    ${TRUE}
    Response Should Contain Property With Empty Value    paymentAccount.appClients
    Response Should Contain Property With Null Value    paymentAccount.recipients
    Response Should Contain Property With Null Value    paymentAccount.subscriptions
    Response Should Contain Property With Value    paymentAccount.status    WAITING_TO_APPROVE
    Response Should Contain Property With Null Value    paymentAccount.ip
    Response Should Contain Property With Boolean Value    paymentAccount.enabled    ${false}
    Response Should Contain Property With String Value    omiseAscendWallet.categoryName
    Response Should Contain Property With String Value    omiseAscendWallet.merchantDiscountRate
    Response Should Contain Property With String Value    omiseAscendWallet.omisePublicKey
    Response Should Contain Property With String Value    omiseAscendWallet.tmnMdr
