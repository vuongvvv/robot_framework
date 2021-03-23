*** Settings ***
Documentation    Tests to verify 2C2P VOID API by credit card
Resource    ../../../api/resources/init.robot
Resource    ../../../api/resources/testdata/payment/merchant_list.robot
Resource    ../../../api/keywords/payment/merchant_payment_resource_keyword.robot
Resource    ../../../api/keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../api/keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Resource    ../../../api/keywords/payment_transaction/merchant_payment_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_creditcard
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.charge,payment.payment.read,paymentTx.read,payment.payment.void

*** Variables ***
${external_ref_id_length}    20
@{activity_list}    VOID    CHARGE

*** Test Cases ***
TC_O2O_21752
    [Documentation]    System allow to charge and void by credit_card when credit card partner is SCB without IPP or recurring plan
    [Tags]    High    Regression    E2E    Sanity
    Generate Transaction Reference    ${external_ref_id_length}
    #Step1. Get Outlet Meta data and Encrypt message to charge without IPP or recurring plan
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    #Step2. Post request to charge without IPP or recurring plan
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${SCB_MERCHANT_ID}","trueyouOutletId": "${SCB_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "E2E Charge by Automation","userDefine2": "Case1 SCB_Account without IPP or Recurring Plan","userDefine3": "AUTOMATE"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    #Step3. Verify transaction status by activity
    Get Payment By Client Ref Id    clientRefId=E2E-${TRANSACTION_REFERENCE}&trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    E2E Charge by Automation
    Response Should Contain Property With Value    userDefine2    Case1 SCB_Account without IPP or Recurring Plan
    Response Should Contain Property With Value    userDefine3    AUTOMATE
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    #Step4. Verify Transaction in Elastic search Should Not Sync
    Verify Elastic Search Transaction Should Not Sync    transaction_reference:${ACTIVITY_ID}
    #Step5. Encrypt and Post request to void the transaction
    Prepare The Encrypt Message    ${SCB_MERCHANT_ID}    ${SCB_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "EVOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "EVOID-${TRANSACTION_REFERENCE}","userDefine1": "E2E void","userDefine2": "automation script"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    EVOID-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    VOID
    Fetch Property From Response    .activityId    ACTIVITY_ID
    #Step6. Query specific transaction (Merchant / Admin)
    Get Specific Transaction By Merchant Or Admin    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property Value Include In List    activities..action    ${activity_list}
    #Step7. Verify Transaction in Elastic search Should Not Sync
    Verify Elastic Search Transaction Should Not Sync    transaction_reference:${ACTIVITY_ID}

TC_O2O_21753
    [Documentation]    System allow to charge and void by credit_card when credit card partner is 2C2P without IPP or recurring plan
    [Tags]    High    Regression    E2E    Sanity
    Generate Transaction Reference    ${external_ref_id_length}
    #Step1. Get Outlet Meta data and Encrypt message to charge without IPP or recurring plan
    Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}"}
    #Step2. Post request to charge without IPP or recurring plan
    Post Payment Charge By Credit Card    {"trueyouMerchantId": "${2C2P_MERCHANT_ID}","trueyouOutletId": "${2C2P_ACTIVE_OUTLET}","amount": "${amount}","currency": "${TH_CURRENCY}","clientRefId": "E2E-${TRANSACTION_REFERENCE}","paymentMethod": "CREDIT_CARD","paymentInfo" :"${valid_credit_card}","userDefine1": "E2E Charge by Automation","userDefine2": "Case1 SCB_Account without IPP or Recurring Plan","userDefine3": "AUTOMATE"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    Fetch Property From Response    .activityId    ACTIVITY_ID
    Fetch Property From Response    .transaction.transactionId    TRANSACTION_ID
    #Step3. Verify transaction status by activity
    Get Payment By Client Ref Id    clientRefId=E2E-${TRANSACTION_REFERENCE}&trueyouMerchantId=${2C2P_MERCHANT_ID}&trueyouOutletId=${2C2P_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    activityId    ${ACTIVITY_ID}
    Response Should Contain Property With Value    clientRefId    E2E-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    statusDescription    SUCCESS
    Response Should Contain Property With Value    userDefine1    E2E Charge by Automation
    Response Should Contain Property With Value    userDefine2    Case1 SCB_Account without IPP or Recurring Plan
    Response Should Contain Property With Value    userDefine3    AUTOMATE
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    APPROVE
    Response Should Contain Property With Value    transaction.paymentMethod    CREDIT_CARD
    #Step4. Verify Transaction in Elastic search Should Not Sync
    Verify Elastic Search Transaction Should Not Sync    transaction_reference:${ACTIVITY_ID}
    #Step5. Encrypt and Post request to void the transaction
    Prepare The Encrypt Message    ${2C2P_MERCHANT_ID}    ${2C2P_ACTIVE_OUTLET}    {"publicKey": "MERCHANT_PUBLIC_KEY","transactionId":"${TRANSACTION_ID}","clientRefId": "EVOID-${TRANSACTION_REFERENCE}"}
    Post Payment Void By Credit Card    ${TRANSACTION_ID}     {"clientRefId": "EVOID-${TRANSACTION_REFERENCE}","userDefine1": "E2E void","userDefine2": "automation script"}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    activityId
    Response Should Contain Property With Value    clientRefId    EVOID-${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    transaction.transactionId    ${TRANSACTION_ID}
    Response Should Contain Property With Value    transaction.status    VOID
    Fetch Property From Response    .activityId    ACTIVITY_ID
    #Step6. Query specific transaction (Merchant / Admin)
    Get Specific Transaction By Merchant Or Admin    ${TRANSACTION_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    transactionId    ${TRANSACTION_ID}
    Response Should Contain Property Value Include In List    activities..action    ${activity_list}
    #Step7. Verify Transaction in Elastic search Should Not Sync
    Verify Elastic Search Transaction Should Not Sync    transaction_reference:${ACTIVITY_ID}
