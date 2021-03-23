*** Settings ***
Documentation    Tests to verify that one-time OTP: Refund OTP api are works correctly

Resource    ../../../api/resources/init.robot
Resource    ../../../api/resources/testdata/payment/merchant_list.robot
Resource    ../../../api/keywords/payment/truemoney_wallet_resource_keywords.robot
Resource    ../../../api/keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../api/keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../api/keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Resource    ../../../api/keywords/payment_transaction/merchant_payment_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_onetime_otp
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_19978
    [Documentation]    User can charge, refund and get wallet balance without store wallet list
    [Tags]    High    Regression    E2E
    #Step1: Send request OTP from TMN
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With Value    linkingAgreement   https://www.truemoney.com/terms-conditions/?utm_source=inapp&online_merchant
    Response Should Contain Property With String Value    authCode
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet
    #Step2: Send request to verify OTP with store flag is false
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "E2E-AUTOMATED","mobile": "${TMN_WALLET_MOBILE}","store": false,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    paymentCode
    Response Should Contain Property With String Value    accessToken
    Response Should Not Contain Property    authId
    Get PaymentCode From Truemoney
    Get Accesstoken From Truemoney
    #Step3: Verify tmn wallet list should not store
    Get Truemoney Wallet List    trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}&clientUsername=E2E-AUTOMATED
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty
    #Step4: Send request to payment charge
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"paymentCode": "${PAYMENT_CODE}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","amount": "43050","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "E2E TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    43050
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    E2E TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    #Step5: Send request to verify payment status
    Get Payment By Client Ref Id    clientRefId=E2E-${TRANSACTION_REFERENCE}&trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    43050
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    E2E TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    #Step6: Get the transaction from elastic search (charge)
    Get Search Transaction    ${ACTIVITY_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .transactionReference    ${ACTIVITY_ID}
    Response Should Contain Property With String Value    .transactionDate
    Response Should Contain Property With Value    .amount    ${43050}
    Response Should Contain Property With Value    .payee.merchantId    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    .payee.outletId    ${WALLET_ACTIVE_OUTLET}
    Response Should Contain Property With Null Value    .payee.terminalId
    Response Should Contain Property With Null Value    .payee.mobile
    Response Should Contain Property With Null Value    .payer
    Response Should Contain Property With Value    .paymentStatus    SUCCESS
    Response Should Contain Property With Value    .paymentStatusDescription    SUCCESS
    Response Should Contain Property With Value    .sourceTransactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    .transactionType    CHARGE
    Response Should Contain Property With Value    .paymentChannel    APP
    Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    AUTH_CODE
    Response Should Not Contain Property    .paymentMethod.digitalWallet.qrTagId
    Response Should Contain Property With Value    .clientRefId    E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With String Value    .externalRefId
    Response Should Contain Property With Null Value    .recurringSequenceNo
    Response Should Contain Property With Null Value    .recurringRefId
    Response Should Contain Property With Null Value    .installment
    #Step7: Send request to payment cancel
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"E2EV-${TRANSACTION_REFERENCE}","amount":"43050","userDefine1":"REGRESSION FOR REFUND","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REFUND E2E TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    E2EV-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    43050
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REFUND E2E TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    REFUND
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    Fetch Property From Response    .activityId    ACTIVITY_ID
    #Step8: send request to verify payment status after payment cancel success
    Get Payment By Client Ref Id    clientRefId=E2EV-${TRANSACTION_REFERENCE}&trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    E2EV-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    43050
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REFUND E2E TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    REFUND
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    #Step9: Get the transaction from elastic search (VOID)
    Get Search Transaction    ${ACTIVITY_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .transactionReference    ${ACTIVITY_ID}
    Response Should Contain Property With String Value    .transactionDate
    Response Should Contain Property With Value    .amount    ${43050}
    Response Should Contain Property With Value    .payee.merchantId    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    .payee.outletId    ${WALLET_ACTIVE_OUTLET}
    Response Should Contain Property With Null Value    .payee.terminalId
    Response Should Contain Property With Null Value    .payee.mobile
    Response Should Contain Property With Null Value    .payer
    Response Should Contain Property With Value    .paymentStatus    SUCCESS
    Response Should Contain Property With Value    .paymentStatusDescription    SUCCESS
    Response Should Contain Property With Value    .sourceTransactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    .transactionType    REFUND
    Response Should Contain Property With Value    .paymentChannel    APP
    Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    AUTH_CODE
    Response Should Not Contain Property    .paymentMethod.digitalWallet.qrTagId
    Response Should Contain Property With Value    .clientRefId    E2EV-${TRANSACTION_REFERENCE}
    Response Should Contain Property With String Value    .externalRefId
    Response Should Contain Property With Null Value    .recurringSequenceNo
    Response Should Contain Property With Null Value    .recurringRefId
    Response Should Contain Property With Null Value    .installment
    #Step10: send request to get TMN balance
    Post TrueMoney Request Get Balance    {"accessToken" : "${TMN_ACCESS_TOKEN}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    0
    Response Should Contain Property With Value    status.message    success
    Response Should Contain Property With String Value    data.balance

TC_O2O_19979
    [Documentation]    User can charge, refund and get wallet balance with store wallet list and can delete wallet list
    [Tags]    High    Regression    E2E
    # Step1: Send request OTP from TMN
    Post Request Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","mobile": "${TMN_WALLET_MOBILE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    otpRef
    Response Should Contain Property With Value    linkingAgreement   https://www.truemoney.com/terms-conditions/?utm_source=inapp&online_merchant
    Response Should Contain Property With String Value    authCode
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet
    # Step2: Send request to verify OTP with store flag is true
    Post Verify Otp From Truemoney Wallet    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientUsername": "E2E-AUTOMATED2","mobile": "${TMN_WALLET_MOBILE}","store": true,"otpRef": "${OTP_REF}","otpCode": "${valid_otp_code}","authCode": "${AUTH_CODE}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    authId
    Response Should Not Contain Property    paymentCode
    Response Should Not Contain Property    accessToken
    Get Auth Id From Truemoney
    # Step3: Verify tmn wallet list should be store
    Get Truemoney Wallet List    trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}&clientUsername=E2E-AUTOMATED2
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .authId
    Response Should Contain Property With Value    .mobile    ${TMN_WALLET_MOBILE}
    # Step4: Send request to payment charge
    Generate Transaction Reference    ${external_ref_id_length}
    Post Charge With Truemoney Wallet    {"authId": "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","amount": "43050","paymentMethod": "WALLET","currency": "${TH_CURRENCY}","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "E2E TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    43050
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    E2E TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With String Value    transaction.transactionId
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    # Step5: Send request to verify payment status
    Get Payment By Client Ref Id    clientRefId=E2E-${TRANSACTION_REFERENCE}&trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    43050
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    E2E TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    # Step6: Send request to payment cancel
    Post Refund With Truemoney Wallet    ${TRANSACTION_ID}    {"clientRefId":"E2EV-${TRANSACTION_REFERENCE}","amount":"43050","userDefine1":"REGRESSION FOR REFUND","userDefine1": "GENERATE BY AUTOMATION","userDefine2": "REFUND E2E TEST","userDefine3": "ONE TIME OTP EPIC"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    E2EV-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    43050
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REFUND E2E TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    REFUND
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    Fetch Property From Response    .activityId    ACTIVITY_ID
    # Step7: send request to verify payment status after payment cancel success
    Get Payment By Client Ref Id    clientRefId=E2EV-${TRANSACTION_REFERENCE}&trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    E2EV-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    43050
    Response Should Contain Property With Value    currency    ${TH_CURRENCY}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    GENERATE BY AUTOMATION
    Response Should Contain Property With Value    userDefine2    REFUND E2E TEST
    Response Should Contain Property With Value    userDefine3    ONE TIME OTP EPIC
    Response Should Contain Property With String Value    createdDate
    Response Should Contain Property With String Value    lastModifiedDate
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    REFUND
    Response Should Contain Property With Value    transaction.'trueyouMerchantId'    ${WALLET_MERCHANT_ID}
    Response Should Contain Property With Value    transaction.'trueyouOutletId'    ${WALLET_ACTIVE_OUTLET}
    Response Should Not Contain Property    transaction.'trueyouTerminalId'
    Response Should Not Contain Property    transaction.paymentAccountId
    Response Should Contain Property With Value    transaction.gatewayType    TMN
    Response Should Contain Property With Value    transaction.paymentMethod    WALLET
    Response Should Contain Property With String Value    transaction.createdDate
    Response Should Contain Property With String Value    transaction.lastModifiedDate
    Response Should Contain Property With Null Value    wpCardId
    # Step8: send request to get TMN balance
    Post TrueMoney Request Get Balance    {"authId" : "${AUTH_ID}","trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    0
    Response Should Contain Property With Value    status.message    success
    Response Should Contain Property With String Value    data.balance
    # Step9: send request to delete wallet list
    Delete Truemoney Wallet List    ${AUTH_ID}    {"trueyouMerchantId": "${WALLET_MERCHANT_ID}","trueyouOutletId": "${WALLET_ACTIVE_OUTLET}"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body
    # Step10: Verify tmn wallet list after delete
    Get Truemoney Wallet List    trueyouMerchantId=${WALLET_MERCHANT_ID}&trueyouOutletId=${WALLET_ACTIVE_OUTLET}&clientUsername=E2E-AUTOMATED2
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty
